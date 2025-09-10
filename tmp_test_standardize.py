import json
from ceeja_app.backend.standardize import standardize_extracted_data

data = {
  "personal_data": {
    "nome_completo": "BEATRIZ SARAIVA RIBEIRO DE SOUZA",
    "sexo": "Feminino",
    "rg": "52381559",
    "rg_digito": "1",
    "rg_uf": "SP",
    "rg_data_emissao": "2008-01-16",
    "cpf": "35315702855",
    "data_nascimento": "1999-05-31",
    "nome_mae": "MARITÂNIA SARAIVA DE SOUZA",
    "nome_pai": "JAIME RIBEIRO DE SOUZA FILHO",
    "nacionalidade": "Brasileira",
    "pais_origem": "Brasil",
    "nascimento_uf": "SP",
    "nascimento_cidade": "Araçatuba"
  },
  "address_data": {
    "cep": "16400-150",
    "logradouro": "R MACHADO BITENCOURT",
    "numero": "57",
    "bairro": "CENTRO",
    "nome_cidade": "LINS",
    "uf_cidade": "SP"
  },
  "schooling_data": {}
}

out = standardize_extracted_data(data)
print(json.dumps(out, indent=2, ensure_ascii=False))
