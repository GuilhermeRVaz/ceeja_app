# backend/app.py

import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from supabase import create_client, Client
import google.generativeai as genai
from PIL import Image
import io
from datetime import datetime
from standardize import standardize_extracted_data

# 1. CONFIGURAÇÃO INICIAL
# --------------------------------
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
# Usamos um modelo com capacidade de visão ('pro-vision' ou 'flash' para mais rápido)
model = genai.GenerativeModel('gemini-1.5-flash-latest')

# --------------------------------

@app.route('/', methods=['GET'])
def index():
    return "Servidor de Extração IA para CEEJA está no ar!"


@app.route('/extract-data', methods=['POST'])
def extract_data_route():
    data = request.get_json()
    enrollment_id = data.get('enrollmentId')
    
    if not enrollment_id:
        return jsonify({"error": "enrollmentId não foi fornecido"}), 400

    print(f"--- INICIANDO EXTRAÇÃO IA PARA MATRÍCULA: {enrollment_id} ---")
    
    try:
        # 2. BUSCAR DOCUMENTOS DA MATRÍCULA
        # --------------------------------
        response = supabase.table('document_extractions').select('*').eq('enrollment_id', enrollment_id).execute()
        documents = response.data
        if not documents:
            return jsonify({"error": "Nenhum documento encontrado para esta matrícula"}), 404
        
        # 3. PREPARAR DOCUMENTOS PARA A IA
        # --------------------------------
        # Vamos enviar múltiplos documentos para o Gemini para um contexto mais rico
        # Ele é inteligente o suficiente para juntar as informações.
        parts = []
        prompt_files = [] # Para informar à IA quais arquivos estamos enviando

        for doc in documents:
            # Priorizamos documentos chave como RG, CPF, etc.
            doc_type = doc.get('document_type')
            if doc_type in ['rg_frente', 'rg_verso', 'cpf_doc', 'comprovante_residencia']:
                storage_path = doc['storage_path']
                print(f"Processando e baixando: {storage_path}")
                
                file_content = supabase.storage.from_('documents').download(storage_path)
                
                # O Gemini aceita PDFs e imagens diretamente!
                # Precisamos apenas informar o tipo do arquivo (mimetype).
                mimetype = 'application/pdf' if storage_path.lower().endswith('.pdf') else 'image/jpeg'
                
                parts.append({"mime_type": mimetype, "data": file_content})
                prompt_files.append(f"- {doc.get('file_name')} (tipo: {doc_type})")

        if not parts:
            return jsonify({"error": "Nenhum documento relevante (RG, CPF, etc.) encontrado para processar"}), 404

        # 4. CRIAR O PROMPT E CHAMAR A IA
        # --------------------------------
        # O prompt é a "pergunta" que fazemos para a IA.
        prompt = f"""
Analise cuidadosamente TODOS os documentos enviados (RG, CPF, comprovante de residência, histórico escolar, certidão, etc).

Sua tarefa é extrair o máximo de informações possíveis para matrícula escolar, buscando cada campo em TODOS os documentos. Se não encontrar algum campo, retorne null para ele.

**Retorne o resultado em JSON, exatamente com as chaves abaixo. Não adicione texto extra, apenas o JSON.**

- **Dados pessoais:**
  - nome_completo
  - nome_social
  - nome_afetivo
  - sexo (apenas 'Masculino' ou 'Feminino')
  - rg
  - rg_digito
  - rg_uf
  - rg_data_emissao (formato YYYY-MM-DD)
  - cpf
  - raca_cor
  - data_nascimento (formato YYYY-MM-DD)
  - idade
  - nome_mae
  - nome_pai
  - possui_internet (true/false)
  - possui_device (true/false)
  - telefone
  - email
  - is_gemeo (true/false)
  - nome_gemeo
  - trabalha (true/false)
  - profissao
  - empresa
  - is_pcd (true/false)
  - deficiencia

- **Endereço:**
  - cep
  - logradouro
  - numero
  - complemento
  - bairro
  - nome_cidade
  - uf_cidade
  - nacionalidade
  - pais_origem
  - nascimento_uf
  - nascimento_cidade

- **Escolaridade:**
  - ultima_serie_concluida
  - ra
  - tem_progressao_parcial (true/false)
  - dependencias (lista de disciplinas em dependência, se houver)
  - nome_escola
  - tipo_escola
  - nivel_ensino
  - estudou_no_ceeja (true/false)
  - eliminou_disciplina (true/false)
  - eliminou_disciplinas (lista de disciplinas eliminadas, se houver)
  - itinerario_formativo
  - optou_ensino_religioso (true/false)
  - optou_educacao_fisica (true/false)
  - aceitou_termos (true/false)
  - data_aceite (formato YYYY-MM-DD)

**Exemplo de resposta esperada:**
{{
  "personal_data": {{
    "nome_completo": "Maria da Silva",
    "sexo": "Feminino",
    "rg": "12.345.678-9",
    "rg_digito": "9",
    "rg_uf": "SP",
    "rg_data_emissao": "2015-06-10",
    "cpf": "123.456.789-00",
    "raca_cor": "Branca",
    "data_nascimento": "2000-01-15",
    "idade": 24,
    "nome_mae": "Joana da Silva",
    "nome_pai": "José da Silva",
    "possui_internet": true,
    "possui_device": true,
    "telefone": "11999999999",
    "email": "maria@email.com",
    "is_gemeo": false,
    "nome_gemeo": null,
    "trabalha": false,
    "profissao": null,
    "empresa": null,
    "is_pcd": false,
    "deficiencia": null
  }},
  "address_data": {{
    "cep": "12345-678",
    "logradouro": "Rua das Flores",
    "numero": "123",
    "complemento": "Apto 45",
    "bairro": "Centro",
    "nome_cidade": "São Paulo",
    "uf_cidade": "SP",
    "nacionalidade": "Brasileira",
    "pais_origem": null,
    "nascimento_uf": "SP",
    "nascimento_cidade": "São Paulo"
  }},
  "schooling_data": {{
    "ultima_serie_concluida": "3ª Série do Ensino Médio",
    "ra": "123456789",
    "tem_progressao_parcial": false,
    "dependencias": [],
    "nome_escola": "Escola Estadual ABC",
    "tipo_escola": "Pública",
    "nivel_ensino": "Ensino Médio",
    "estudou_no_ceeja": false,
    "eliminou_disciplina": false,
    "eliminou_disciplinas": [],
    "itinerario_formativo": null,
    "optou_ensino_religioso": false,
    "optou_educacao_fisica": true,
    "aceitou_termos": true,
    "data_aceite": "2024-02-01"
  }}
}}

**IMPORTANTE:**  
- Sempre busque cada campo em todos os documentos, mesmo que estejam em arquivos diferentes.
- Se não encontrar algum campo, retorne null para ele.
- Use sempre o formato de data YYYY-MM-DD.
- Para sexo, retorne apenas 'Masculino' ou 'Feminino'.
"""
        parts.insert(0, prompt)

        print("Enviando dados para o Gemini...")
        response_gemini = model.generate_content(parts)
        
        # Limpa a resposta para garantir que seja um JSON válido
        cleaned_json_text = response_gemini.text.strip().replace("```json", "").replace("```", "")
        extracted_data = json.loads(cleaned_json_text)

        print("--- DADOS ESTRUTURADOS RECEBIDOS DA IA ---")
        print(json.dumps(extracted_data, indent=2))
        print("------------------------------------------")

        # === CHAMANDO A NOVA FUNÇÃO DE PADRONIZAÇÃO ===
        standardized_data = standardize_extracted_data(extracted_data)

        print("--- JSON PADRONIZADO PARA SALVAR ---")
        print(json.dumps(standardized_data, indent=2))
        print("------------------------------------------")
        
        # 5. SALVAR OS DADOS EXTRAÍDOS NO SUPABASE
        # --------------------------------
        print("Salvando dados extraídos na tabela 'enrollments'...")
        supabase.table('enrollments').update({
            'extracted_personal_data': standardized_data.get('personal_data'),
            'extracted_address_data': standardized_data.get('address_data'),
            'extracted_schooling_data': standardized_data.get('schooling_data'),
            'status': 'aguardando_revisao_aluno' # Atualiza o status da matrícula
        }).eq('id', enrollment_id).execute()

        return jsonify({"status": "success", "message": "Dados extraídos e salvos com sucesso."}), 200

    except Exception as e:
        print(f"ERRO GERAL NO FLUXO DE IA: {e}")
        # Opcional: Atualizar o status da matrícula para 'erro_ia'
        supabase.table('enrollments').update({'status': 'erro_ia'}).eq('id', enrollment_id).execute()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)