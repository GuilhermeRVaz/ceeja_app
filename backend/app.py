# ARQUIVO FINAL E CORRIGIDO: backend/app.py

import os
import json
import requests # Importa a biblioteca para fazer chamadas de rede
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from supabase import create_client, Client
import google.generativeai as genai
import mimetypes
from standardize import standardize_extracted_data

# --- CONFIGURAÇÃO (sem alterações) ---
load_dotenv()

app = Flask(__name__)
CORS(app)

# Configura o cliente do Supabase
url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
supabase: Client = create_client(url, key)

# Configura a API do Gemini
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')


# --- PROMPTS E EXEMPLOS (sem alterações) ---
def load_prompt_examples():
    """Carrega imagens de exemplo e as prepara para a API do Gemini."""
    example_parts = []
    examples_dir = os.path.join(os.path.dirname(__file__), 'prompt_examples')
    try:
        if not os.path.isdir(examples_dir):
            print(f"AVISO: Diretório de exemplos '{examples_dir}' não encontrado. A IA funcionará sem exemplos visuais.")
            return []

        example_parts.append("INÍCIO DOS EXEMPLOS VISUAIS PARA REFERÊNCIA:")

        for filename in os.listdir(examples_dir):
            filepath = os.path.join(examples_dir, filename)
            if os.path.isfile(filepath):
                example_parts.append(f"\nExemplo de documento '{filename}':")
                mime_type, _ = mimetypes.guess_type(filepath)
                if mime_type and (mime_type.startswith('image/') or mime_type == 'application/pdf'):
                    with open(filepath, 'rb') as f:
                        file_content = f.read()
                        example_parts.append({"mime_type": mime_type, "data": file_content})
        example_parts.append("\nFIM DOS EXEMPLOS VISUAIS. A seguir, os documentos do usuário para extração.")
        print(f"Sucesso: {len(os.listdir(examples_dir))} arquivos de exemplo carregados.")
        return example_parts
    except Exception as e:
        print(f"ERRO ao carregar arquivos de exemplo: {e}")
        return []

PROMPT_EXAMPLE_PARTS = load_prompt_examples()

PROMPT_GEMINI = f"""
Analise cuidadosamente TODOS os documentos do usuário enviados APÓS a seção de exemplos.
Sua tarefa é extrair o máximo de informações possíveis para uma matrícula escolar, buscando cada campo em TODOS os documentos fornecidos.

Exemplos visuais de documentos e localização dos campos
RG (Carteira de Identidade):
Veja a imagem de exemplo enviada (RG com anotações).
O número do RG está no topo direito, seguido do dígito.
A data de expedição/emissão está no canto superior direito.
O estado de expedição (UF) está no topo, próximo ao título "ESTADO DE SÃO PAULO".
O nome completo está abaixo do título "NOME".
A filiação (nomes da mãe e do pai) está logo abaixo do nome.
O CPF pode aparecer na parte inferior do RG.
A data de nascimento está destacada ao lado do local de nascimento.
Comprovante de Residência:
Veja a imagem de exemplo enviada (conta de energia com anotações).
O endereço completo, CEP (CEP é composto de 8 dígitos, pode aparecer como xxxxx-xxx, xxxxxxxx, ou xx.xxx-xxx) e cidade estão no topo, geralmente à esquerda.
**O CEP é fundamental: sempre procure e extraia o CEP, mesmo que esteja em formato diferente ou junto ao endereço.**
**Exemplos de CEP válidos: 17012-345, 17012345, 17.012-345.**
**Ignore códigos de barras, números de conta, ou outros números longos que não estejam no contexto do endereço.**
Ignore o nome do titular do comprovante.
Certidão de Nascimento/Casamento:
Veja a imagem de exemplo enviada (certidão de casamento com anotações).
O nome completo, data de nascimento, local de nascimento, nomes dos pais, data de expedição da certidão, local de emissão, subdistrito, número da folha, número do livro e número do registro estão destacados na imagem. Se a certidão contiver "República Federativa do Brasil", defina a nacionalidade como "Brasileira".
Histórico Escolar e Declaração de Escolaridade:
Veja as imagens de exemplo enviadas (histórico escolar frente e verso).
**Para Declarações de Escolaridade:**
  - **Nome da Escola:** Procure o nome completo da escola que emitiu a declaração.
  - **Última Série Concluída:** Identifique a última série ou ano concluído pelo aluno, **NO FORMATO EXATO 'Xª Série Ensino Fundamental' (sem 'do') ou 'Xª Série do Ensino Médio' (com 'do')**. Ex: "5ª Série Ensino Fundamental", "3ª Série do Ensino Médio".
  - **Nível de Ensino:** Infira o nível de ensino (Fundamental ou Médio) com base na "Última Série Concluída".
  - **Estudou no CEEJA:** Se o nome da escola NÃO for "CEEJA", defina como `false`.
**Para Históricos Escolares:**
  - **Nível de Ensino:** Encontrado no topo do histórico escolar (ex: "Histórico Escolar Ensino Fundamental" ou "Histórico Escolar Ensino Médio").
  - **RA do Aluno:** Procure pelo RA (Registro do Aluno), geralmente no topo ou em campos destacados, somente se for do Estado de São Paulo.
  - **Última Série Concluída:** Na frente do histórico, na parte superior das colunas de menções, notas e ano de curso.
  - **Dependências:** Informações sobre promoção parcial e disciplinas cursadas/em dependência, geralmente em observações.
Outro RG (modelo alternativo):
Veja a imagem de exemplo enviada (RG verde).
Os campos seguem o mesmo padrão, mas podem estar em posições diferentes.

Campos a serem extraídos
RG: número, dígito, data de emissão/expedição, UF de expedição, nome completo, filiação (mãe e pai), CPF (se constar).
CPF: número, nome completo.
Certidão de nascimento/casamento: nome completo, data de nascimento, local de nascimento (cidade, estado, país), nomes completos da mãe e pai, data de expedição da certidão, local de emissão (cidade, estado), subdistrito, número da folha, número do livro, número do registro.
Comprovante de residência: cep, logradouro completo, número, complemento, bairro, cidade, estado. Ignore o nome do titular.
**Dê prioridade máxima para encontrar o CEP. O CEP é composto de 8 dígitos, pode estar em diferentes formatos e geralmente está próximo ao endereço.**
Declaração de escolaridade/matrícula/transferência: última série concluída ou série de direito à matrícula, promoção parcial, dependências, nome da escola, cidade da escola, UF da escola, tipo de escola (Pública ou Privada), nível de ensino.
Atestado de eliminação: nível de ensino, se eliminou disciplina (true/false), quais disciplinas foram eliminadas.
Histórico escolar: RA do aluno, última série concluída, dependências, disciplinas cursadas e notas, nome da escola, cidade da escola, UF da escola, tipo de escola (Pública ou Privada), nível de ensino, se estudou no CEEJA (true/false), itinerário formativo.
Outros dados de escolaridade: se optou por ensino religioso (true/false), se optou por educação física (true/false), se aceitou os termos (true/false), data de aceite (YYYY-MM-DD).

**INSTRUÇÕES IMPORTANTES:**
1.  **Use os exemplos visuais** que foram fornecidos no início como referência principal para saber onde encontrar cada dado nos diferentes tipos de documento (RG, Histórico, Certidão, etc.).
2.  **Foco nos Documentos do Usuário:** Sua extração final deve ser baseada APENAS nos documentos do usuário, não nos exemplos.
3.  **Formato JSON Obrigatório:** Retorne o resultado em um único bloco de código JSON, exatamente com a estrutura e chaves definidas abaixo. Não adicione texto, comentários, ou aspas ```json``` ao redor da sua resposta.
4.  **Dados Não Encontrados:** Se uma informação não for encontrada em NENHUM dos documentos, retorne `null` para o campo correspondente.
5.  **Formato de Data:** Todas as datas DEVEM estar no formato `YYYY-MM-DD`.

**ESTRUTURA JSON DE SAÍDA:**

{{
    "personal_data": {{
        "nome_completo": "...",
        "nome_social": "...",
        "nome_afetivo": "...",
        "sexo": "Masculino ou Feminino",
        "rg": "...",
        "rg_digito": "...",
        "rg_uf": "...",
        "rg_data_emissao": "YYYY-MM-DD",
        "cpf": "...",
        "raca_cor": "...",
        "data_nascimento": "YYYY-MM-DD",
        "idade": "...",
        "nome_mae": "...",
        "nome_pai": "...",
        "possui_internet": true/false,
        "possui_device": true/false,
        "telefone": "...",
        "email": "...",
        "is_gemeo": true/false,
        "nome_gemeo": "...",
        "trabalha": true/false,
        "profissao": "...",
        "empresa": "...",
        "is_pcd": true/false,
        "deficiencia": "...",
        "nacionalidade": "...",
        "pais_origem": "...",
        "nascimento_uf": "...",
        "nascimento_cidade": "..."
    }},
    "address_data": {{
        "cep": "...",
        "logradouro": "...",
        "numero": "...",
        "complemento": "...",
        "bairro": "...",
        "nome_cidade": "...",
        "uf_cidade": "..."
    }},
    "schooling_data": {{
        "requer_matricula_em": "Ensino Fundamental" ou "Ensino Médio",
        "ultima_serie_concluida": "...",
        "ra": "...",
        "tem_progressao_parcial": true/false,
        "dependencias": ["Disciplina 1", "série tal", "Disciplina 2" "Série tal"],
        "nome_escola": "...",
        "cidade_escola": "...",
        "uf_escola": "...",
        "tipo_escola": "Pública ou Privada",
        "nivel_ensino": "...",
        "estudou_no_ceeja": true/false,
        "eliminou_disciplina": true/false,
        "eliminou_disciplinas": ["Disciplina A", "Disciplina B"],
        "itinerario_formativo": "...",
        "optou_ensino_religioso": true/false,
        "optou_educacao_fisica": true/false,
        "aceitou_termos": true/false,
        "data_aceite": "YYYY-MM-DD"
    }}
}}

**REGRAS ESPECÍFICAS PARA 'requer_matricula_em' e 'ultima_serie_concluida':**

- **Regra Padrão:** Se o documento de escolaridade (histórico escolar) indicar claramente que a última série concluída com aprovação foi a 7ª série, defina:
  `"requer_matricula_em": "Ensino Fundamental"`
  `"ultima_serie_concluida": "7ª Série do Ensino Fundamental"`

- **Regra de Borda (DP na 8ª Série):** Se o histórico escolar mencionar a 8ª série, mas indicar a existência de "DP", "dependência", "progressão parcial", "reprovado" ou qualquer termo similar para uma ou mais matérias, interprete que a 8ª série NÃO FOI CONCLUÍDA. Neste caso, defina:
  `"requer_matricula_em": "Ensino Fundamental"`
  `"ultima_serie_concluida": "7ª Série do Ensino Fundamental"`

- **Outros Casos:** Para outras últimas séries concluídas, extraia `ultima_serie_concluida` diretamente do documento e infira `requer_matricula_em` (Ensino Fundamental ou Ensino Médio) com base nela.
"""

# --- ROTA DE EXTRAÇÃO DE DADOS (sem alterações) ---
@app.route('/extract-data', methods=['POST'])
def extract_data_route():
    data = request.get_json()
    enrollment_id = data.get('enrollmentId')
    
    if not enrollment_id:
        return jsonify({"error": "enrollmentId não foi fornecido"}), 400

    print(f"--- INICIANDO EXTRAÇÃO IA PARA MATRÍCULA: {enrollment_id} ---")

    try:
        response = supabase.table('document_extractions').select('*').eq('enrollment_id', enrollment_id).execute()
        documents = response.data
        if not documents:
            return jsonify({"error": "Nenhum documento encontrado para esta matrícula"}), 404
        
        parts = []
        if PROMPT_EXAMPLE_PARTS:
            parts.extend(PROMPT_EXAMPLE_PARTS)
        
        parts.append(PROMPT_GEMINI)

        doc_count = 0
        for doc in documents:
            doc_type = doc.get('document_type')
            if doc_type in ['rg_frente', 'rg_verso', 'cpf_doc', 'comprovante_residencia', 'historico_escolar', 'certidao_nascimento_casamento', 'declaracao_escolaridade', 'historico_fundamental']:
                storage_path = doc['storage_path']
                print(f"Processando e baixando documento do usuário: {storage_path}")
                
                file_content = supabase.storage.from_('documents').download(storage_path)
                
                mimetype = 'application/pdf' if storage_path.lower().endswith('.pdf') else 'image/jpeg'
                
                parts.append({"mime_type": mimetype, "data": file_content})
                doc_count += 1
        
        if doc_count == 0:
            return jsonify({"error": "Nenhum documento relevante encontrado para processar nesta matrícula"}), 404

        print(f"Enviando {len(PROMPT_EXAMPLE_PARTS)} partes de exemplo e {doc_count} documentos do usuário para o Gemini...")
        response_gemini = model.generate_content(parts)
        
        cleaned_json_text = response_gemini.text.strip().replace("```json", "").replace("```", "")
        extracted_data = json.loads(cleaned_json_text)

        print("--- DADOS ESTRUTURADOS RECEBIDOS DA IA ---")
        print(json.dumps(extracted_data, indent=2))
        print("------------------------------------------")

        standardized_data = standardize_extracted_data(extracted_data)
        
        print("--- JSON PADRONIZADO PARA SALVAR ---")
        print(json.dumps(standardized_data, indent=2))
        print("------------------------------------------")
        
        print("Salvando dados extraídos na tabela 'enrollments'...")
        supabase.table('enrollments').update({
            'extracted_personal_data': standardized_data.get('personal_data'),
            'extracted_address_data': standardized_data.get('address_data'),
            'extracted_schooling_data': standardized_data.get('schooling_data'),
            'status': 'aguardando_revisao_aluno'
        }).eq('id', enrollment_id).execute()

        return jsonify({"status": "success", "message": "Dados extraídos e salvos com sucesso."}), 200

    except json.JSONDecodeError as e:
        print(f"ERRO DE DECODIFICAÇÃO JSON: {e}")
        if 'response_gemini' in locals():
            print(response_gemini.text)
        supabase.table('enrollments').update({'status': 'erro_ia'}).eq('id', enrollment_id).execute()
        return jsonify({"error": "A resposta da IA não estava em formato JSON válido.", "details": str(e)}), 500
    except Exception as e:
        print(f"ERRO GERAL NO FLUXO DE IA: {e}")
        supabase.table('enrollments').update({'status': 'erro_ia'}).eq('id', enrollment_id).execute()
        return jsonify({"error": str(e)}), 500

# === A NOVA ROTA QUE RESOLVE O PROBLEMA ===
@app.route('/finalize-enrollment', methods=['POST'])
def finalize_enrollment_route():
    data = request.get_json()
    enrollment_id = data.get('enrollmentId')
    
    if not enrollment_id:
        return jsonify({"error": "enrollmentId não foi fornecido"}), 400

    print(f"--- FINALIZANDO MATRÍCULA E ACIONANDO EDGE FUNCTION PARA: {enrollment_id} ---")

    try:
        # 1. Salva os dados confirmados pelo aluno que vieram do Flutter
        supabase.table('enrollments').update({
            'confirmed_personal_data': data.get('personalData'),
            'confirmed_address_data': data.get('addressData'),
            'confirmed_schooling_data': data.get('schoolingData'),
            'status': 'concluida' # Atualiza o status para 'concluida'
        }).eq('id', enrollment_id).execute()

        # 2. CHAMA A EDGE FUNCTION, que fará o trabalho pesado
        edge_function_url = f"{os.environ.get('SUPABASE_URL')}/functions/v1/process-enrollment"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {os.environ.get('SUPABASE_SERVICE_ROLE_KEY')}"
        }
        payload = {"enrollment_id": enrollment_id}
        
        # Faz a chamada para a Edge Function
        requests.post(edge_function_url, headers=headers, json=payload)
        
        print(f"--- Chamada para Edge Function enviada para ID: {enrollment_id} ---")
        return jsonify({"status": "success", "message": "Matrícula finalizada e processamento iniciado."}), 200

    except Exception as e:
        print(f"ERRO GERAL AO FINALIZAR: {e}")
        return jsonify({"error": str(e)}), 500
# ==========================================

if __name__ == '__main__':
    app.run(debug=True, port=5000)