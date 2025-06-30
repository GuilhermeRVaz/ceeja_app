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
            Analise os seguintes documentos de um aluno brasileiro:
            {' '.join(prompt_files)}

            Sua tarefa é extrair as seguintes informações e retorná-las em um formato JSON estrito, sem nenhum texto adicional.
            
            Para dados pessoais, use as chaves: 'nome_completo', 'rg', 'cpf', 'data_nascimento' (formato AAAA-MM-DD), 'nome_mae', 'nome_pai'.
            Para dados de endereço, use as chaves: 'cep', 'logradouro', 'numero', 'bairro', 'nomeCidade', 'ufCidade'.

            Se uma informação não for encontrada em nenhum dos documentos, retorne o valor como null.
            Combine informações se necessário (ex: o RG está em um arquivo e o CPF em outro).

            Exemplo de saída:
            {{
              "personal_data": {{
                "nome_completo": "Maria da Silva",
                "rg": "12.345.678-9",
                "cpf": "123.456.789-00",
                "data_nascimento": "1990-01-15",
                "nome_mae": "Joana da Silva",
                "nome_pai": "João da Silva"
              }},
              "address_data": {{
                "cep": "12345-678",
                "logradouro": "Rua das Flores",
                "numero": "123",
                "bairro": "Centro",
                "nomeCidade": "São Paulo",
                "ufCidade": "SP"
              }}
            }}
        """
        parts.insert(0, prompt) # Adiciona o prompt como a primeira parte da requisição

        print("Enviando dados para o Gemini...")
        response_gemini = model.generate_content(parts)
        
        # Limpa a resposta para garantir que seja um JSON válido
        cleaned_json_text = response_gemini.text.strip().replace("```json", "").replace("```", "")
        extracted_data = json.loads(cleaned_json_text)

        print("--- DADOS ESTRUTURADOS RECEBIDOS DA IA ---")
        print(json.dumps(extracted_data, indent=2))
        print("------------------------------------------")
        
        # 5. SALVAR OS DADOS EXTRAÍDOS NO SUPABASE
        # --------------------------------
        print("Salvando dados extraídos na tabela 'enrollments'...")
        supabase.table('enrollments').update({
            'extracted_personal_data': extracted_data.get('personal_data'),
            'extracted_address_data': extracted_data.get('address_data'),
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