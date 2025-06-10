import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';

class CepService {
  Future<AddressModel?> fetchAddressByCep(String cep) async {
    // Limpa o CEP para conter apenas dígitos
    final cleanedCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedCep.length != 8) {
      return null;
    }

    final uri = Uri.parse('https://viacep.com.br/ws/$cleanedCep/json/');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) {
          return null; // CEP não encontrado
        }

        return AddressModel(
          cep: data['cep'],
          logradouro: data['logradouro'],
          bairro: data['bairro'],
          nomeCidade: data['localidade'],
          ufCidade: data['uf'],
        );
      }
      return null;
    } catch (e) {
      print('Erro ao buscar CEP: $e');
      return null;
    }
  }
}
