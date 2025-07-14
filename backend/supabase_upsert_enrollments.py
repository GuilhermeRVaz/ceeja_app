import os
from supabase import create_client, Client
import json

# Configurações do Supabase
SUPABASE_URL = "https://ucxjsrrggejajsxrxnov.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjeGpzcnJnZ2VqYWpzeHJ4bm92Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyMzQ0NzQsImV4cCI6MjA2NDgxMDQ3NH0.40UNE4QXDuSPiBzyWnZaYWHI9mQlj3_fdZvTbGX1vjk"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

def upsert_personal_data(user_id, data):
    allowed_fields = [
        'nome_completo', 'tem_nome_social', 'nome_social', 'tem_nome_afetivo', 'nome_afetivo', 'sexo', 'rg', 'rg_digito', 'rg_uf', 'rg_data_emissao', 'cpf', 'raca_cor', 'data_nascimento', 'nome_mae', 'nome_pai', 'nacionalidade', 'nascimento_uf', 'nascimento_cidade', 'pais_origem', 'possui_internet', 'possui_device', 'telefone', 'email', 'is_gemeo', 'nome_gemeo', 'trabalha', 'profissao', 'empresa', 'is_pcd', 'deficiencia', 'idade'
    ]
    filtered = {k: v for k, v in data.items() if k in allowed_fields}
    filtered['user_id'] = user_id
    print("Upsert personal_data:", filtered)
    result = supabase.table('personal_data').upsert(filtered, on_conflict=['user_id']).execute()
    print("Supabase result:", result)

def upsert_address(user_id, data):
    allowed_fields = [
        'cep', 'logradouro', 'numero', 'complemento', 'bairro', 'nomeCidade', 'ufCidade', 'zona', 'temLocalizacaoDiferenciada', 'localizacaoDiferenciada'
    ]
    mapping = {
        'nome_cidade': 'nomeCidade',
        'uf_cidade': 'ufCidade',
        'tem_localizacao_diferenciada': 'temLocalizacaoDiferenciada',
        'localizacao_diferenciada': 'localizacaoDiferenciada',
    }
    for old, new in mapping.items():
        if old in data:
            data[new] = data.pop(old)
    filtered = {k: v for k, v in data.items() if k in allowed_fields}
    filtered['user_id'] = user_id
    supabase.table('addresses').upsert(filtered, on_conflict=['user_id']).execute()

def upsert_schooling(user_id, data):
    allowed_fields = [
        'nivel_ensino', 'itinerario_formativo', 'ultima_serie_concluida', 'estudou_no_ceeja', 'tem_progressao_parcial', 'progressao_parcial_disciplinas', 'eliminou_disciplina', 'eliminou_disciplina_nivel', 'eliminou_disciplinas', 'optou_ensino_religioso', 'optou_educacao_fisica', 'aceitou_termos', 'data_aceite', 'ra', 'tipo_escola', 'nome_escola'
    ]
    filtered = {k: v for k, v in data.items() if k in allowed_fields}
    filtered['user_id'] = user_id
    supabase.table('schooling_data').upsert(filtered, on_conflict=['user_id']).execute()

def main():
    response = supabase.table('enrollments').select('*').execute()
    rows = response.data
    for row in rows:
        user_id = row['user_id']
        # Personal Data
        if row.get('confirmed_personal_data'):
            pdata = row['confirmed_personal_data']
            if isinstance(pdata, str):
                pdata = json.loads(pdata)
            upsert_personal_data(user_id, pdata)
        # Address
        if row.get('confirmed_address_data'):
            adata = row['confirmed_address_data']
            if isinstance(adata, str):
                adata = json.loads(adata)
            upsert_address(user_id, adata)
        # Schooling
        if row.get('confirmed_schooling_data'):
            sdata = row['confirmed_schooling_data']
            if isinstance(sdata, str):
                sdata = json.loads(sdata)
            upsert_schooling(user_id, sdata)
    print('Upsert concluído!')

if __name__ == '__main__':
    main() 