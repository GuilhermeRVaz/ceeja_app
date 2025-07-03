import pytest
from standardize import standardize_extracted_data

def test_standardize_extracted_data():
    raw = {
        "personal_data": {
            "nome": "  Maria da Silva  ",
            "sexo": "Feminino",
            "data de nascimento": "15/01/2000",
            "possui_internet": "Sim",
            "is_gemeo": "não",
            "telefone": " 11999999999 ",
            "email": None
        },
        "address_data": {
            "rua": "Rua das Flores",
            "numero": "123",
            "cidade": "São Paulo",
            "uf": "SP",
            "cep": "12345-678"
        },
        "schooling_data": {
            "ultima serie": "3ª Série do Ensino Médio",
            "ra": "123456789",
            "tem_progressao_parcial": "false",
            "dependencias": "Matemática, Português",
            "eliminou_disciplinas": ["História"],
            "data_aceite": "2024-02-01"
        }
    }
    expected = {
        "personal_data": {
            "nome_completo": "Maria da Silva",
            "nome_social": None,
            "nome_afetivo": None,
            "sexo": "Feminino",
            "rg": None,
            "rg_digito": None,
            "rg_uf": None,
            "rg_data_emissao": None,
            "cpf": None,
            "raca_cor": None,
            "data_nascimento": "2000-01-15",
            "idade": None,
            "nome_mae": None,
            "nome_pai": None,
            "possui_internet": True,
            "possui_device": None,
            "telefone": "11999999999",
            "email": None,
            "is_gemeo": False,
            "nome_gemeo": None,
            "trabalha": None,
            "profissao": None,
            "empresa": None,
            "is_pcd": None,
            "deficiencia": None
        },
        "address_data": {
            "cep": "12345-678",
            "logradouro": "Rua das Flores",
            "numero": "123",
            "complemento": None,
            "bairro": None,
            "nome_cidade": "São Paulo",
            "uf_cidade": "SP",
            "nacionalidade": None,
            "pais_origem": None,
            "nascimento_uf": None,
            "nascimento_cidade": None
        },
        "schooling_data": {
            "ultima_serie_concluida": "3ª Série do Ensino Médio",
            "ra": "123456789",
            "tem_progressao_parcial": False,
            "dependencias": ["Matemática", "Português"],
            "nome_escola": None,
            "tipo_escola": None,
            "nivel_ensino": None,
            "estudou_no_ceeja": None,
            "eliminou_disciplina": None,
            "eliminou_disciplinas": ["História"],
            "itinerario_formativo": None,
            "optou_ensino_religioso": None,
            "optou_educacao_fisica": None,
            "aceitou_termos": None,
            "data_aceite": "2024-02-01"
        }
    }
    result = standardize_extracted_data(raw)
    assert result == expected

if __name__ == "__main__":
    pytest.main([__file__]) 