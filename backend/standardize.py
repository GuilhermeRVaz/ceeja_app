from datetime import datetime
import re

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

def standardize_extracted_data(data: dict) -> dict:
    # Mapeamento de seções em português para o padrão esperado
    section_map = {
        "Dados pessoais": "personal_data",
        "Endereço": "address_data",
        "Escolaridade": "schooling_data"
    }
    # Se vier em português, converte para o padrão
    for pt_key, std_key in section_map.items():
        if pt_key in data:
            data[std_key] = data[pt_key]
    standard_data = {
        "personal_data": {},
        "address_data": {},
        "schooling_data": {}
    }
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
    # Campos de nacionalidade / nascimento podem vir dentro de personal_data
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
        "requer_matricula_em": ["requer_matricula_em", "requer matricula em", "nível de matrícula"], # Novo campo
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
    def get_value(source: dict, keys: list):
        for key in keys:
            if key in source:
                return source[key]
            if key.lower() in source:
                return source[key.lower()]
        return None
    for std_key, possible_keys in personal_map.items():
        val = get_value(data.get("personal_data", data), possible_keys)
        if std_key in ["data_nascimento", "rg_data_emissao"]:
            val = parse_date(val)
        elif std_key in ["possui_internet", "possui_device", "is_gemeo", "trabalha", "is_pcd"]:
            val = parse_bool(val)
        else:
            val = parse_str(val)
        standard_data["personal_data"][std_key] = val
    for std_key, possible_keys in address_map.items():
        val = get_value(data.get("address_data", data), possible_keys)
        val = parse_str(val)
        standard_data["address_data"][std_key] = val
    for std_key, possible_keys in schooling_map.items():
        val = get_value(data.get("schooling_data", data), possible_keys)
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
        # Normaliza a string para comparação (ex: remove acentos, padroniza "ª")
        ultima_serie_normalizada = ultima_serie_concluida_raw.lower().replace('ª', '').replace('º', '').strip()

        # Regra Padrão e Regra de Borda (DP na 8ª Série)
        if "7 serie ensino fundamental" in ultima_serie_normalizada:
            standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
            standard_data["schooling_data"]["ultima_serie_concluida"] = "7ª Série do Ensino Fundamental"
        elif "8 serie ensino fundamental" in ultima_serie_normalizada and tem_progressao_parcial:
            # Se a 8ª série é mencionada E há progressão parcial, assume-se que não foi concluída
            standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
            standard_data["schooling_data"]["ultima_serie_concluida"] = "7ª Série do Ensino Fundamental"
        elif "ensino fundamental" in ultima_serie_normalizada:
            standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Fundamental"
            standard_data["schooling_data"]["ultima_serie_concluida"] = ultima_serie_concluida_raw # Mantém o valor original se não for 7ª ou 8ª com DP
        elif "ensino medio" in ultima_serie_normalizada or "ensino médio" in ultima_serie_normalizada:
            standard_data["schooling_data"]["requer_matricula_em"] = "Ensino Médio"
            standard_data["schooling_data"]["ultima_serie_concluida"] = ultima_serie_concluida_raw
        else:
            # Fallback: Se não for possível inferir, use o valor extraído e tente inferir o nível
            standard_data["schooling_data"]["requer_matricula_em"] = standard_data["schooling_data"].get("nivel_ensino") # Pode ser "Fundamental" ou "Médio"
            standard_data["schooling_data"]["ultima_serie_concluida"] = ultima_serie_concluida_raw
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
            # Remover o campo de address_data após movê-lo para personal_data
            del standard_data["address_data"][campo]
    # --- PÓS-PROCESSAMENTO: tentar extrair o CEP do logradouro ou outros campos se cep vier nulo ---
    def extrair_cep(texto):
        if not texto:
            return None
        # Padrões comuns de CEP no Brasil
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