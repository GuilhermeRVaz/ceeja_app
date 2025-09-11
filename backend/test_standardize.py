import json
from standardize import standardize_extracted_data

# JSON de exemplo fornecido pelo usuário (DADOS ESTRUTURADOS RECEBIDOS DA IA)
extracted_data_example = {
  "personal_data": {
    "nome_completo": "BEATRIZ SARAIVA RIBEIRO DE SOUZA",
    "nome_social": None,
    "nome_afetivo": None,
    "sexo": "Feminino",
    "rg": "52381559",
    "rg_digito": "1",
    "rg_uf": "SP",
    "rg_data_emissao": "2008-01-16",
    "cpf": "353.157.028-55",
    "raca_cor": None,
    "data_nascimento": "1999-05-31",
    "idade": None,
    "nome_mae": "MARITÂNIA SARAIVA DE SOUZA",
    "nome_pai": "JAIME RIBEIRO DE SOUZA FILHO",
    "possui_internet": None,
    "possui_device": None,
    "telefone": None,
    "email": None,
    "is_gemeo": False,
    "nome_gemeo": None,
    "trabalha": None,
    "profissao": None,
    "empresa": None,
    "is_pcd": None,
    "deficiencia": None,
    "nacionalidade": "Brasileira",
    "pais_origem": "Brasil",
    "nascimento_uf": "SP",
    "nascimento_cidade": "Araçatuba"
  },
  "address_data": {
    "cep": "16402-643",
    "logradouro": "R MOACYR RIBEIRO FERREIRA",
    "numero": "415",
    "complemento": None,
    "bairro": "JD STA MARIA",
    "nome_cidade": "LINS",
    "uf_cidade": "SP"
  },
  "schooling_data": {
    "requer_matricula_em": "Ensino Médio",
    "ultima_serie_concluida": "8ª S\u00e9rie do Ensino Fundamental",        
    "ra": "104.395.950-6",
    "tem_progressao_parcial": False,
    "dependencias": [],
    "nome_escola": "EE Prof\u00aa Altina Moraes Sampaio",
    "cidade_escola": "Ara\u00e7atuba",
    "uf_escola": "SP",
    "tipo_escola": "P\u00fablica",
    "nivel_ensino": "Ensino Fundamental",
    "estudou_no_ceeja": True,
    "eliminou_disciplina": False,
    "eliminou_disciplinas": [],
    "itinerario_formativo": None,
    "optou_ensino_religioso": False,
    "optou_educacao_fisica": True,
    "aceitou_termos": None,
    "data_aceite": None
  }
}

# JSON esperado pelo usuário (JSON PADRONIZADO PARA SALVAR)
expected_standardized_data = {
  "personal_data": {
    "nome_completo": "BEATRIZ SARAIVA RIBEIRO DE SOUZA",
    "nome_social": None,
    "nome_afetivo": None,
    "sexo": "Feminino",
    "rg": "52381559",
    "rg_digito": "1",
    "rg_uf": "SP",
    "rg_data_emissao": "2008-01-16",
    "cpf": "353.157.028-55",
    "raca_cor": None,
    "data_nascimento": "1999-05-31",
    "idade": None,
    "nome_mae": "MARITÂNIA SARAIVA DE SOUZA",
    "nome_pai": "JAIME RIBEIRO DE SOUZA FILHO",
    "possui_internet": None,
    "possui_device": None,
    "telefone": None,
    "email": None,
    "is_gemeo": False,
    "nome_gemeo": None,
    "trabalha": None,
    "profissao": None,
    "empresa": None,
    "is_pcd": None,
    "deficiencia": None,
    "nacionalidade": "Brasileira",
    "pais_origem": "Brasil",
    "nascimento_uf": "SP",
    "nascimento_cidade": "Araçatuba"
  },
  "address_data": {
    "cep": "16402-643",
    "logradouro": "R MOACYR RIBEIRO FERREIRA",
    "numero": "415",
    "complemento": None,
    "bairro": "JD STA MARIA",
    "nome_cidade": "LINS",
    "uf_cidade": "SP"
  },
  "schooling_data": {
    "requer_matricula_em": "Ensino Fundamental",
    "ultima_serie_concluida": "8ª Série Ensino Fundamental",
    "ra": "104.395.950-6",
    "tem_progressao_parcial": False,
    "dependencias": [],
    "nome_escola": "EE Profª Altina Moraes Sampaio",
    "tipo_escola": "Pública",
    "nivel_ensino": "Ensino Fundamental",
    "estudou_no_ceeja": True,
    "eliminou_disciplina": False,
    "eliminou_disciplinas": [],
    "itinerario_formativo": None,
    "optou_ensino_religioso": False,
    "optou_educacao_fisica": True,
    "aceitou_termos": None,
    "data_aceite": None
  }
}

# Executa a função de padronização
result = standardize_extracted_data(extracted_data_example)

print("--- RESULTADO DA PADRONIZAÇÃO ---")
print(json.dumps(result, indent=2, ensure_ascii=False))
print("----------------------------------")

# Verifica se o resultado é o esperado
if result["schooling_data"]["ultima_serie_concluida"] == expected_standardized_data["schooling_data"]["ultima_serie_concluida"] and \
   result["schooling_data"]["requer_matricula_em"] == expected_standardized_data["schooling_data"]["requer_matricula_em"]:
    print("TESTE BEM SUCEDIDO: A extração da escolaridade está correta.")
else:
    print("TESTE FALHOU: A extração da escolaridade está incorreta.")
    print(f"Esperado ultima_serie_concluida: {expected_standardized_data['schooling_data']['ultima_serie_concluida']}")
    print(f"Recebido ultima_serie_concluida: {result['schooling_data']['ultima_serie_concluida']}")
    print(f"Esperado requer_matricula_em: {expected_standardized_data['schooling_data']['requer_matricula_em']}")
    print(f"Recebido requer_matricula_em: {result['schooling_data']['requer_matricula_em']}")
