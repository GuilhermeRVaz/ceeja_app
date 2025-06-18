import json
import time
import asyncio
import io

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from supabase import create_client, Client
import google.generativeai as genai
from PIL import Image

# --- CONFIGURAÇÕES ---

# Configurações do Supabase (substitua pelos seus dados reais)
SUPABASE_URL = "https://ucxjsrrggejajsxrxnov.supabase.co"
# Use a service_role key para acesso total no backend
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjeGpzcnJnZ2VqYWpzeHJ4bm92Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyMzQ0NzQsImV4cCI6MjA2NDgxMDQ3NH0.40UNE4QXDuSPiBzyWnZaYWHI9mQlj3_fdZvTbGX1vjk"

# Configurações do Gemini (substitua pela sua chave de API)
GEMINI_API_KEY = "AIzaSyAuDz9LKkdPZIcUJI5MhRFqHvBqC2NoHMI"

# --- INICIALIZAÇÃO DOS CLIENTES ---

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
genai.configure(api_key=GEMINI_API_KEY)
# Usando o modelo de visão do Gemini
model = genai.GenerativeModel('gemini-pro-vision')


# --- FUNÇÕES DE AUTOMAÇÃO (SELENIUM) ---

def login_sed(driver, username, password):
    """Realiza o login no sistema SED."""
    driver.get('https://sed.educacao.sp.gov.br/NCA/FichaAluno/Index')
    # Espera explícita pelo campo de login, mais robusto que time.sleep()
    WebDriverWait(driver, 20).until(
        EC.visibility_of_element_located((By.ID, 'name'))
    )

    login_field = driver.find_element(By.ID, 'name')
    login_field.send_keys(username)
    password_field = driver.find_element(By.ID, 'senha')
    password_field.send_keys(password)
    time.sleep(1)  # Pequena pausa antes do clique
    login_button = driver.find_element(By.ID, 'botaoEntrar')
    login_button.click()
    # Espera pela caixa de busca do menu, um bom indicador de que o login foi bem-sucedido
    WebDriverWait(driver, 20).until(
        EC.visibility_of_element_located((By.ID, 'decorMenuFilterTxt'))
    )
    print("Login no SED realizado com sucesso.")


def navigate_to_ficha_aluno(driver):
    """Navega para a página de Ficha do Aluno."""
    try:
        search_box = WebDriverWait(driver, 20).until(
            EC.element_to_be_clickable((By.ID, 'decorMenuFilterTxt'))
        )
        search_box.click()
        search_box.send_keys('ficha do aluno')
        search_box.send_keys(Keys.ENTER)
        # Espera o título da página carregar para garantir a navegação
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.XPATH, "//h2[contains(text(), 'Ficha do Aluno')]"))
        )
        print("Navegou para a Ficha do Aluno.")
    except Exception as e:
        print(f"Erro ao navegar para Ficha do Aluno: {e}")
        # Tenta navegar diretamente se a busca rápida falhar
        driver.get('https://sed.educacao.sp.gov.br/NCA/FichaAluno/Index')
        time.sleep(5)


def select_search_type(driver, search_type_text):
    """Seleciona o tipo de pesquisa no dropdown."""
    dropdown_button_xpath = '//*[@id="Pesquisa"]/div[1]/div[2]/div/div/button'
    dropdown_element = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.XPATH, dropdown_button_xpath))
    )
    # Usar JavaScript para clicar pode evitar problemas de interceptação
    driver.execute_script("arguments[0].click();", dropdown_element)

    option_xpath = f"//a/span[text()='{search_type_text}']"
    option_element = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.XPATH, option_xpath))
    )
    driver.execute_script("arguments[0].click();", option_element)
    time.sleep(1) # Pausa para a interface se ajustar


def perform_search(driver, search_value, input_id):
    """Preenche o campo de pesquisa e clica no botão Pesquisar."""
    search_input = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, input_id))
    )
    search_input.clear()
    search_input.send_keys(search_value)

    search_button = driver.find_element(By.ID, 'btnPesquisar')
    search_button.click()
    # Espera pela animação de 'loading' desaparecer (se houver) ou pela tabela
    WebDriverWait(driver, 15).until(
        EC.presence_of_element_located((By.ID, 'tabelaDados_wrapper'))
    )
    time.sleep(2) # Pequena pausa para a tabela renderizar completamente


def get_search_results(driver):
    """Extrai os resultados da tabela de pesquisa."""
    results = []
    try:
        table = driver.find_element(By.ID, 'tabelaDados')
        rows = table.find_elements(By.TAG_NAME, 'tr')
        # Ignora o cabeçalho da tabela (índice 0)
        for row in rows[1:]:
            cols = row.find_elements(By.TAG_NAME, 'td')
            if len(cols) >= 2:  # Garante que há pelo menos Nome e RA
                nome = cols[0].text.strip()
                ra = cols[1].text.strip()
                results.append({'nome': nome, 'ra': ra})
    except Exception:
        # Nenhuma tabela de dados encontrada
        pass
    return results


# --- FUNÇÕES ASSÍNCRONAS (SUPABASE & GEMINI) ---

async def _download_file_from_supabase(file_path: str) -> bytes | None:
    """Baixa um arquivo do Supabase Storage."""
    try:
        # O nome do bucket que você usa para documentos
        bucket_name = 'documents'
        # O método download retorna os bytes diretamente, não um objeto que precisa de await
        return supabase.storage.from_(bucket_name).download(file_path)
    except Exception as e:
        print(f"Erro ao baixar arquivo '{file_path}' do Supabase Storage: {e}")
        return None


async def _extract_text_from_image_with_gemini(image_bytes: bytes, prompt: str) -> str | None:
    """Extrai texto de uma imagem usando a API Gemini."""
    try:
        img = Image.open(io.BytesIO(image_bytes))
        # CORREÇÃO PRINCIPAL: Usar a versão async da função
        response = await model.generate_content_async([prompt, img])
        return response.text
    except Exception as e:
        print(f"Erro ao extrair texto da imagem com Gemini: {e}")
        return None


async def get_enrollment_data(enrollment_id: str):
    """Busca os dados de matrícula no Supabase."""
    try:
        # O cliente Supabase é síncrono por padrão, então não use 'await' aqui
        response = supabase.from_('enrollment_requests').select('*').eq('id', enrollment_id).limit(1).execute()
        if response.data and len(response.data) > 0:
            return response.data[0]
        return None
    except Exception as e:
        print(f"Erro ao buscar dados de matrícula no Supabase: {e}")
        return None


async def update_enrollment_status(enrollment_id: str, status: str, message: str = None, ra: str = None):
    """Atualiza o status da matrícula no Supabase."""
    try:
        update_data = {'status': status, 'last_update_message': message}
        if ra:
            update_data['ra_found'] = ra

        # O cliente Supabase é síncrono por padrão, então não use 'await' aqui
        supabase.from_('enrollment_requests').update(update_data).eq('id', enrollment_id).execute()
        print(f"Status da matrícula {enrollment_id} atualizado para '{status}'. Mensagem: {message}")
    except Exception as e:
        print(f"Erro ao atualizar status da matrícula {enrollment_id} no Supabase: {e}")


async def search_ra_in_sed(enrollment_id: str):
    """
    Função principal para buscar o RA do aluno no SED.
    Retorna o RA se encontrado, ou None caso contrário.
    """
    enrollment_data = await get_enrollment_data(enrollment_id)
    if not enrollment_data:
        print(f"Dados de matrícula para o ID {enrollment_id} não encontrados.")
        return None

    personal_data = enrollment_data.get('personal_data', {})
    if not personal_data:
        print("Dados pessoais não encontrados na matrícula.")
        return None

    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service)

    try:
        with open('login_credentials.json') as f:
            credentials = json.load(f)

        login_sed(driver, credentials['username'], credentials['password'])
        navigate_to_ficha_aluno(driver)

        # 1. Pesquisa por Nome Completo
        nome_completo = personal_data.get('nomeCompleto', '')
        if not nome_completo:
            print("Nome completo não disponível para pesquisa.")
            await update_enrollment_status(enrollment_id, 'error', 'Nome completo ausente nos dados.')
            return None

        print(f"Tentando pesquisar por Nome Completo: {nome_completo}")
        select_search_type(driver, 'Nome Completo')
        # Corrigido para usar o ID do campo, que é mais estável que XPATH
        perform_search(driver, nome_completo, 'txtNomeCompleto')
        results = get_search_results(driver)

        if len(results) == 1:
            ra_encontrado = results[0]['ra']
            print(f"SUCESSO: RA único encontrado por Nome Completo: {ra_encontrado}")
            return ra_encontrado
        
        elif len(results) > 1:
            print(f"Múltiplos resultados ({len(results)}) encontrados para Nome Completo. Tentando refinar...")

            # Lógica de refino:
            # Aqui você pode adicionar as outras tentativas de busca (RG, Nome da Mãe, etc.)
            # como novas chamadas para select_search_type e perform_search.
            # Por simplicidade, vamos apenas registrar a necessidade de revisão manual.

            await update_enrollment_status(enrollment_id, 'manual_review', f"Múltiplos resultados ({len(results)}) para o nome.")
            return None
            
        else: # len(results) == 0
            print("Nenhum aluno encontrado com os dados fornecidos.")
            await update_enrollment_status(enrollment_id, 'not_found', 'Aluno não encontrado no SED.')
            return None

    except Exception as e:
        print(f"Ocorreu um erro crítico durante a busca de RA: {e}")
        await update_enrollment_status(enrollment_id, 'error', f"Erro durante automação: {str(e)}")
        return None
    finally:
        driver.quit()


# --- BLOCO DE EXECUÇÃO PRINCIPAL (PARA TESTES) ---
if __name__ == "__main__":
    
    # Exemplo de ID de matrícula (substitua por um ID real do seu banco de dados para testar)
    test_enrollment_id = "b8b280db-2dfa-4a3e-b0c6-b18b71b42c9f"

    async def main():
        # Verifica se as credenciais foram preenchidas
        if "SUA_" in SUPABASE_URL or "SUA_" in SUPABASE_KEY or "SUA_" in GEMINI_API_KEY:
            print("ERRO: Por favor, substitua os valores de SUPABASE_URL, SUPABASE_KEY e GEMINI_API_KEY no código.")
            return
        if "SUA_" in test_enrollment_id:
             print("ERRO: Por favor, substitua o valor de 'test_enrollment_id' para rodar um teste.")
             return

        found_ra = await search_ra_in_sed(test_enrollment_id)
        if found_ra:
            print(f"\n--- RESULTADO FINAL ---")
            print(f"RA encontrado: {found_ra}")
            await update_enrollment_status(test_enrollment_id, 'found', 'RA encontrado com sucesso pela automação.', ra=found_ra)
        else:
            print("\n--- RESULTADO FINAL ---")
            print("RA não pôde ser determinado automaticamente. Verifique o log para detalhes.")
            # O status já é atualizado dentro de search_ra_in_sed em caso de falha/revisão.

    # Executa a função principal assíncrona
    asyncio.run(main())