# backend/app.py

from flask import Flask, request, jsonify

# Cria a aplicação Flask
app = Flask(__name__)

# Define a rota principal que apenas diz "oi"
@app.route('/', methods=['GET'])
def index():
    return "Servidor Python para CEEJA está no ar!"

# Define a rota que nosso app Flutter vai chamar
@app.route('/extract-data', methods=['POST'])
def extract_data_route():
    # Por enquanto, apenas recebemos a requisição e respondemos com sucesso
    
    data = request.get_json()
    if not data or 'enrollmentId' not in data:
        return jsonify({"error": "enrollmentId não foi fornecido"}), 400
        
    enrollment_id = data['enrollmentId']
    
    print(f"Recebi um pedido de extração para a matrícula ID: {enrollment_id}")
    
    # SIMULAÇÃO: No futuro, aqui chamaremos o OCR e a IA.
    # Por agora, apenas retornamos uma mensagem de sucesso.
    
    response_data = {
        "status": "success",
        "message": f"Processo de extração para a matrícula {enrollment_id} iniciado. (Esta é uma simulação)"
    }
    
    return jsonify(response_data), 200

# Linha para rodar o servidor quando executamos o arquivo
if __name__ == '__main__':
    app.run(debug=True, port=5000)