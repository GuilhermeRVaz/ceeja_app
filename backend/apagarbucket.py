import os
from supabase import create_client, Client
from dotenv import load_dotenv

# Configuração para carregar o arquivo .env do diretório do script
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
load_dotenv(dotenv_path=dotenv_path)

# Leitura das credenciais
url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")

# Validação das credenciais
if not url or not key:
    raise ValueError("ERRO: As variáveis SUPABASE_URL e/ou SUPABASE_SERVICE_ROLE_KEY não foram encontradas.")

try:
    supabase: Client = create_client(url, key)
except Exception as e:
    print(f"Ocorreu um erro ao inicializar o cliente Supabase: {e}")
    exit()

bucket_name = "documents"

def get_all_file_paths_recursively(path=""):
    """
    Lista todos os arquivos em um bucket de forma recursiva, 
    navegando por todas as subpastas.
    """
    try:
        # Lista o conteúdo do caminho (path) atual
        res = supabase.storage.from_(bucket_name).list(path)
        
        all_files = []
        for item in res:
            # Constrói o caminho completo do item
            current_path = f"{path}/{item['name']}" if path else item['name']
            
            # Se o item não tiver 'id', é uma "pasta".
            # O Supabase retorna 'id: None' para pastas.
            if item.get('id') is None:
                print(f"Entrando na pasta: {current_path}...")
                # Chama a função recursivamente para a subpasta
                all_files.extend(get_all_file_paths_recursively(current_path))
            else:
                # Se tem 'id', é um arquivo. Adiciona à lista.
                print(f"Arquivo encontrado: {current_path}")
                all_files.append(current_path)
        
        return all_files
    except Exception as e:
        print(f"Erro ao listar arquivos em '{path}': {e}")
        return []

def clear_entire_bucket():
    """
    Encontra todos os arquivos recursivamente e os remove.
    """
    print(f"Iniciando varredura completa do bucket '{bucket_name}'...")
    
    # 1. Obter a lista de TODOS os arquivos em todas as pastas
    files_to_delete = get_all_file_paths_recursively()

    if not files_to_delete:
        print("Nenhum arquivo encontrado no bucket. Nada a fazer.")
        return

    print("-" * 30)
    print(f"Total de {len(files_to_delete)} arquivo(s) encontrado(s) para remoção.")
    print("Iniciando a remoção...")

    try:
        # 2. Remover todos os arquivos encontrados de uma vez
        response = supabase.storage.from_(bucket_name).remove(files_to_delete)
        print(f"Operação concluída. Todos os arquivos e pastas foram removidos com sucesso do bucket '{bucket_name}'.")
    except Exception as e:
        print(f"Ocorreu um erro durante a remoção dos arquivos: {e}")

if __name__ == "__main__":
    clear_entire_bucket()
