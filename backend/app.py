# backend/app.py
import os
import json
from flask import Flask, request, jsonify  # type: ignore
from flask_cors import CORS
from dotenv import load_dotenv
from supabase import create_client, Client
import google.generativeai as genai
from PIL import Image
import io
import re
from datetime import datetime
import mimetypes # Usado para detectar o tipo do arquivo de exemplo

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
model = genai.GenerativeModel('gemini-2.5-flash')
# 2. CARREGAMENTO DOS EXEMPLOS VISUAIS (OTIMIZADO)
# -----------------------------------------------------------------
def load_prompt_examples():
    """Carrega imagens de exemplo e as prepara para a API do Gemini."""
    example_parts = []
    examples_dir = os.path.join(os.path.dirname(__file__), 'prompt_examples')
    try:
        if not os.path.isdir(examples_dir):
            print(f"AVISO: Diretório de exemplos '{examples_dir}' não encontrado. A IA funcionará sem exemplos visuais.")
            return []

        # Adiciona uma introdução para os exemplos no prompt
        example_parts.append("INÍCIO DOS EXEMPLOS VISUAIS PARA REFERÊNCIA:")

        for filename in os.listdir(examples_dir):
            filepath = os.path.join(examples_dir, filename)
            if os.path.isfile(filepath):
                # Informa no prompt qual arquivo de exemplo está sendo enviado
                example_parts.append(f"\nExemplo de documento '{filename}':")
                # Detecta o mimetype e lê o conteúdo do arquivo
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

# 3. PROMPT PRINCIPAL PARA A IA
# -----------------------------------------------------------------
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
        "cep": "...",  # Dê prioridade máxima para encontrar o CEP. O CEP é composto de 8 dígitos, pode estar em diferentes formatos.
        "logradouro": "...",
        "numero": "...",
        "complemento": "...",
        "bairro": "...",
        "nome_cidade": "...",
        "uf_cidade": "..."
    }},
    "schooling_data": {{
        "requer_matricula_em": "Ensino Fundamental" ou "Ensino Médio", # NOVO CAMPO: Indica o nível de ensino que o aluno requer matrícula.
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

# Funções de padronização (movidas de standardize.py)
def parse_date(value):
    if not value:
        return None
    for fmt in ("%Y-%m-%d", "%d/%m/%Y", "%d-%m-%Y", "%d.%m.%Y"):
        try:
            return datetime.strptime(value, fmt).strftime("%Y-%m-%d")
        except Exception:
            continue
    return value if isinstance(value, str) and len(value) == 10 else None

def parse_bool(value):
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        v = value.strip().lower()
        if v in ["sim", "true", "verdadeiro", "yes"]:
            return True
        if v in ["não", "nao", "false", "falso", "no"]:
            return False
    if isinstance(value, int):
        return value == 1
    return None

def parse_list(value):
    if value is None:
        return []
    if isinstance(value, list):
        return value
    if isinstance(value, str):
        return [v.strip() for v in value.split(",") if v.strip()]
    return []

def parse_str(value):
    if value is None:
        return None
    return str(value).strip()

STATE_ABBREVIATIONS = {
    "acre": "AC", "alagoas": "AL", "amapa": "AP", "amazonas": "AM", "bahia": "BA",
    "ceara": "CE", "distrito federal": "DF", "espirito santo": "ES", "goias": "GO",
    "maranhao": "MA", "mato grosso": "MT", "mato grosso do sul": "MS", "minas gerais": "MG",
    "para": "PA", "paraiba": "PB", "parana": "PR", "pernambuco": "PE", "piaui": "PI",
    "rio de janeiro": "RJ", "rio grande do norte": "RN", "rio grande do sul": "RS",
    "rondonia": "RO", "roraima": "RR", "santa catarina": "SC", "sao paulo": "SP",
    "sergipe": "SE", "tocantins": "TO"
}

SERIES_MAP = {
    "4 serie": "4ª Série Ensino Fundamental",
    "5 serie": "5ª Série Ensino Fundamental",
    "6 serie": "6ª Série Ensino Fundamental",
    "7 serie": "7ª Série Ensino Fundamental",
    "8 serie": "8ª Série Ensino Fundamental",
    "9 serie": "8ª Série Ensino Fundamental", # Mapeia 9ª série para 8ª Série Ensino Fundamental
    "1 ano": "1ª Série do Ensino Médio",
    "2 ano": "2ª Série do Ensino Médio",
    "3 ano": "3ª Série do Ensino Médio"
}

PROGRESSION_MAP = {
    "4ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Fundamental", "proxima_serie": "5ª Série Ensino Fundamental"},
    "5ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Fundamental", "proxima_serie": "6ª Série Ensino Fundamental"},
    "6ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Fundamental", "proxima_serie": "7ª Série Ensino Fundamental"},
    "7ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Fundamental", "proxima_serie": "8ª Série Ensino Fundamental"},
    "8ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Médio", "proxima_serie": "1ª Série do Ensino Médio"},
    "9ª Série Ensino Fundamental": {"requer_matricula_em": "Ensino Médio", "proxima_serie": "1ª Série do Ensino Médio"}, # Adicionado para consistência
    "1ª Série do Ensino Médio": {"requer_matricula_em": "Ensino Médio", "proxima_serie": "2ª Série do Ensino Médio"},
    "2ª Série do Ensino Médio": {"requer_matricula_em": "Ensino Médio", "proxima_serie": "3ª Série do Ensino Médio"},
    "3ª Série do Ensino Médio": {"requer_matricula_em": "Ensino Médio", "proxima_serie": "Concluído"}, # Adicionado para completar o mapa
}

def standardize_and_normalize_data(raw_data: dict) -> dict:
    standard_data = {
        "personal_data": {},
        "address_data": {},
        "schooling_data": {}
    }

    # Mapeamento de seções em português para o padrão esperado
    section_map = {
        "Dados pessoais": "personal_data",
        "Endereço": "address_data",
        "Escolaridade": "schooling_data"
    }
    for pt_key, std_key in section_map.items():
        if pt_key in raw_data:
            raw_data[std_key] = raw_data[pt_key]

    def get_value(source: dict, keys: list):
        for key in keys:
            if key in source:
                return source[key]
            if key.lower() in source:
                return source[key.lower()]
        return None

    # Maps para os campos
    personal_map = {
        "nome_completo": ["nome", "nome_completo", "nomeCompleto", "nome do titular"],
        "nome_social": ["nome_social", "nome social"],
        "nome_afetivo": ["nome_afetivo", "nome afetivo"],
        "sexo": ["sexo", "gênero", "genero"],
        "rg": ["rg", "registro geral", "numero rg"],
        "rg_digito": ["rg_digito", "digito rg", "dígito rg"],
        "rg_uf": ["rg_uf", "uf rg", "estado rg"],
        "rg_data_emissao": ["rg_data_emissao", "data emissao rg", "data de emissão do rg"],
        "cpf": ["cpf", "cadastro de pessoa fisica"],
        "raca_cor": ["raca_cor", "raça/cor", "cor", "raça"],
        "data_nascimento": ["data_nascimento", "data de nascimento", "nascimento"],
        "idade": ["idade"],
        "nome_mae": ["nome_mae", "mae", "filiação mae", "filiacao mae"],
        "nome_pai": ["nome_pai", "pai", "filiação pai", "filiacao pai"],
        "possui_internet": ["possui_internet", "tem internet"],
        "possui_device": ["possui_device", "tem dispositivo"],
        "telefone": ["telefone", "celular", "contato"],
        "email": ["email", "e-mail"],
        "is_gemeo": ["is_gemeo", "é gemeo", "é gêmeo"],
        "nome_gemeo": ["nome_gemeo", "nome do gemeo", "nome do gêmeo"],
        "trabalha": ["trabalha", "empregado"],
        "profissao": ["profissao", "profissão"],
        "empresa": ["empresa", "local de trabalho"],
        "is_pcd": ["is_pcd", "pcd", "deficiente"],
        "deficiencia": ["deficiencia", "deficiência", "tipo de deficiência"],
        "nacionalidade": ["nacionalidade", "nacionalidade_pessoa", "nacionalidade_paciente"],
        "pais_origem": ["pais_origem", "pais de origem", "pais_origem_pessoa"],
        "nascimento_uf": ["nascimento_uf", "uf nascimento", "uf_nascimento", "estado_nascimento"],
        "nascimento_cidade": ["nascimento_cidade", "cidade nascimento", "cidade_nascimento"]
    }
    address_map = {
        "cep": ["cep"],
        "logradouro": ["logradouro", "rua", "endereco", "endereço"],
        "numero": ["numero", "n"],
        "complemento": ["complemento"],
        "bairro": ["bairro"],
        "nome_cidade": ["cidade", "municipio", "nomeCidade", "nome_cidade"],
        "uf_cidade": ["estado", "uf", "ufCidade", "uf_cidade"],
        "nacionalidade": ["nacionalidade"],
        "pais_origem": ["pais_origem", "país de origem"],
        "nascimento_uf": ["nascimento_uf", "uf nascimento"],
        "nascimento_cidade": ["nascimento_cidade", "cidade nascimento"]
    }
    schooling_map = {
        "requer_matricula_em": ["requer_matricula_em", "requer matricula em", "nível de matrícula"],
        "ultima_serie_concluida": ["ultima serie", "ultima_serie_concluida"],
        "ra": ["ra", "registro do aluno"],
        "tem_progressao_parcial": ["tem_progressao_parcial", "progressao parcial"],
        "dependencias": ["dependencias", "disciplinas em dependencia"],
        "nome_escola": ["escola", "nome da escola", "nome_escola"],
        "tipo_escola": ["tipo_escola", "tipo de escola"],
        "nivel_ensino": ["nivel_ensino", "nível de ensino"],
        "estudou_no_ceeja": ["estudou_no_ceeja", "ceeja"],
        "eliminou_disciplina": ["eliminou_disciplina", "eliminou disciplina"],
        "eliminou_disciplinas": ["eliminou_disciplinas", "disciplinas eliminadas"],
        "itinerario_formativo": ["itinerario_formativo", "itinerário formativo"],
        "optou_ensino_religioso": ["optou_ensino_religioso", "ensino religioso"],
        "optou_educacao_fisica": ["optou_educacao_fisica", "educação física"],
        "aceitou_termos": ["aceitou_termos", "aceitou termos"],
        "data_aceite": ["data_aceite", "data aceite"]
    }

    for std_key, possible_keys in personal_map.items():
        val = get_value(raw_data.get("personal_data", raw_data), possible_keys)
        if std_key in ["data_nascimento", "rg_data_emissao"]:
            val = parse_date(val)
        elif std_key in ["possui_internet", "possui_device", "is_gemeo", "trabalha", "is_pcd"]:
            val = parse_bool(val)
        else:
            val = parse_str(val)
        
        if std_key in ["nascimento_uf", "rg_uf"] and val:
            val = STATE_ABBREVIATIONS.get(val.lower(), val) # Converte para sigla se encontrar
        
        standard_data["personal_data"][std_key] = val

    for std_key, possible_keys in address_map.items():
        val = get_value(raw_data.get("address_data", raw_data), possible_keys)
        val = parse_str(val)
        standard_data["address_data"][std_key] = val

    for std_key, possible_keys in schooling_map.items():
        val = get_value(raw_data.get("schooling_data", raw_data), possible_keys)
        if std_key in ["tem_progressao_parcial", "estudou_no_ceeja", "eliminou_disciplina", "optou_ensino_religioso", "optou_educacao_fisica", "aceitou_termos"]:
            val = parse_bool(val)
        elif std_key in ["dependencias", "eliminou_disciplinas"]:
            val = parse_list(val)
        elif std_key in ["data_aceite"]:
            val = parse_date(val)
        else:
            val = parse_str(val)
        standard_data["schooling_data"][std_key] = val

    # --- Implementar Regras de Negócio para 'requer_matricula_em' e 'ultima_serie_concluida' ---
    ultima_serie_concluida_raw = standard_data["schooling_data"].get("ultima_serie_concluida")
    tem_progressao_parcial = standard_data["schooling_data"].get("tem_progressao_parcial")

    if ultima_serie_concluida_raw:
        # Normaliza a string bruta primeiro para remover " do " se for Ensino Fundamental
        if " do " in ultima_serie_concluida_raw.lower() and \
           ("fundamental" in ultima_serie_concluida_raw.lower() or \
            standard_data["schooling_data"].get("requer_matricula_em") == "Ensino Fundamental"):
            ultima_serie_concluida_raw = ultima_serie_concluida_raw.replace(" do ", " ").strip()

        # Normalização robusta para qualquer variação de "9ª Série Ensino Fundamental"
        import unicodedata
        def strip_accents(text):
            return ''.join(c for c in unicodedata.normalize('NFD', text) if unicodedata.category(c) != 'Mn')

        raw = ultima_serie_concluida_raw.strip()
        raw_noacc = strip_accents(raw.lower().replace('º', '').replace('ª', ''))

        # Se contiver "9 serie ensino fundamental" ou "9 serie do ensino fundamental" ou "9a serie ensino fundamental" etc
        if (
            "9 serie ensino fundamental" in raw_noacc or
            "9 serie do ensino fundamental" in raw_noacc or
            "9a serie ensino fundamental" in raw_noacc or
            "9 ano ensino fundamental" in raw_noacc or
            "9 ano do ensino fundamental" in raw_noacc or
            "9a serie" in raw_noacc or
            "9 serie" in raw_noacc
        ):
            ultima_serie_normalizada = "8 serie"
        else:
            ultima_serie_normalizada = raw_noacc.replace(' do ensino', '').strip()

        serie_concluida_padronizada = SERIES_MAP.get(ultima_serie_normalizada)

        # Aplica a regra de DP da 8ª série (agora incluindo a 9ª série)
        if serie_concluida_padronizada == "8ª Série Ensino Fundamental" and tem_progressao_parcial:
            serie_concluida_padronizada = "7ª Série Ensino Fundamental"
            standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
        elif serie_concluida_padronizada:
            dados_de_progressao = PROGRESSION_MAP.get(serie_concluida_padronizada)
            if dados_de_progressao:
                standard_data["schooling_data"]["requer_matricula_em"] = dados_de_progressao['requer_matricula_em']
            else:
                # Fallback se não encontrar no PROGRESSION_MAP, tenta inferir do nivel_ensino
                nivel_ensino_raw = standard_data["schooling_data"].get("nivel_ensino")
                if nivel_ensino_raw and "fundamental" in nivel_ensino_raw.lower():
                    standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
                elif nivel_ensino_raw and ("medio" in nivel_ensino_raw.lower() or "médio" in nivel_ensino_raw.lower()):
                    standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Médio"
        else:
            # Se não encontrou no SERIES_MAP, tenta inferir do nivel_ensino
            nivel_ensino_raw = standard_data["schooling_data"].get("nivel_ensino")
            if nivel_ensino_raw and "fundamental" in nivel_ensino_raw.lower():
                standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
            elif nivel_ensino_raw and ("medio" in nivel_ensino_raw.lower() or "médio" in nivel_ensino_raw.lower()):
                standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Médio"
        
        standard_data["schooling_data"]["ultima_serie_concluida"] = serie_concluida_padronizada or ultima_serie_concluida_raw
    else:
        # Se ultima_serie_concluida não foi extraída, tenta usar nivel_ensino para requer_matricula_em
        nivel_ensino_raw = standard_data["schooling_data"].get("nivel_ensino")
        if nivel_ensino_raw:
            if "fundamental" in nivel_ensino_raw.lower():
                standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
            elif "medio" in nivel_ensino_raw.lower() or "médio" in nivel_ensino_raw.lower():
                standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Médio"

    # --- AJUSTE: mover nascimento_uf, nascimento_cidade e nacionalidade para personal_data se presentes em address_data ---
    for campo in ["nascimento_uf", "nascimento_cidade", "nacionalidade"]:
        valor = standard_data["address_data"].get(campo)
        if valor:
            standard_data["personal_data"][campo] = valor
            del standard_data["address_data"][campo]

    # --- PÓS-PROCESSAMENTO: tentar extrair o CEP do logradouro ou outros campos se cep vier nulo ---
    def extrair_cep(texto):
        if not texto:
            return None
        match = re.search(r'\b\d{5}-?\d{3}\b', texto)
        if match:
            return match.group().replace('-', '')
        match = re.search(r'\b\d{2}\.\d{3}-\d{3}\b', texto)
        if match:
            return match.group().replace('.', '').replace('-', '')
        return None
    if not standard_data["address_data"].get("cep"):
        for campo in ["logradouro", "complemento", "bairro"]:
            cep_extraido = extrair_cep(standard_data["address_data"].get(campo))
            if cep_extraido:
                standard_data["address_data"]["cep"] = cep_extraido
                break
    return standard_data

# 4. ROTAS DA API
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
        # BUSCAR DOCUMENTOS DA MATRÍCULA
        response = supabase.table('document_extractions').select('*').eq('enrollment_id', enrollment_id).execute()
        documents = response.data
        if not documents:
            return jsonify({"error": "Nenhum documento encontrado para esta matrícula"}), 404
        
        # PREPARAR REQUISIÇÃO PARA A IA (EXEMPLOS + PROMPT + DOCUMENTOS DO USUÁRIO)
        parts = []
        # Adiciona os exemplos visuais carregados no início
        if PROMPT_EXAMPLE_PARTS:
            parts.extend(PROMPT_EXAMPLE_PARTS)
        
        # Adiciona o prompt textual principal
        parts.append(PROMPT_GEMINI)

        # Adiciona os documentos do usuário
        doc_count = 0
        for doc in documents:
            doc_type = doc.get('document_type')
            # Você pode ajustar os tipos de documentos que deseja processar
            if doc_type in ['rg_frente', 'rg_verso', 'cpf_doc', 'comprovante_residencia', 'historico_escolar', 'certidao_nascimento_casamento', 'declaracao_escolaridade', 'historico_fundamental']:
                storage_path = doc['storage_path']
                print(f"Processando e baixando documento do usuário: {storage_path}")
                
                file_content = supabase.storage.from_('documents').download(storage_path)
                
                mimetype = 'application/pdf' if storage_path.lower().endswith('.pdf') else 'image/jpeg'
                
                parts.append({"mime_type": mimetype, "data": file_content})
                doc_count += 1
        
        if doc_count == 0:
            return jsonify({"error": "Nenhum documento relevante encontrado para processar nesta matrícula"}), 404

        # CHAMAR A IA
        print(f"Enviando {len(PROMPT_EXAMPLE_PARTS)} partes de exemplo e {doc_count} documentos do usuário para o Gemini...")
        response_gemini = model.generate_content(parts)
        
        # Limpa a resposta para garantir que seja um JSON válido
        cleaned_json_text = response_gemini.text.strip().replace("```json", "").replace("```", "")
        extracted_data = json.loads(cleaned_json_text)

        print("--- DADOS ESTRUTURADOS RECEBIDOS DA IA ---")
        print(json.dumps(extracted_data, indent=2))
        print("------------------------------------------")

        # PADRONIZAR OS DADOS
        standardized_data = standardize_and_normalize_data(extracted_data) # Alterado aqui
        
        print("--- JSON PADRONIZADO PARA SALVAR ---")
        print(json.dumps(standardized_data, indent=2))
        print("------------------------------------------")
        
        # SALVAR OS DADOS EXTRAÍDOS NO SUPABASE
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
        print("Resposta recebida da IA que causou o erro:")
        if 'response_gemini' in locals():
            print(response_gemini.text)
        supabase.table('enrollments').update({'status': 'erro_ia'}).eq('id', enrollment_id).execute()
        return jsonify({"error": "A resposta da IA não estava em formato JSON válido.", "details": str(e)}), 500
    except Exception as e:
        print(f"ERRO GERAL NO FLUXO DE IA: {e}")
        supabase.table('enrollments').update({'status': 'erro_ia'}).eq('id', enrollment_id).execute()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)