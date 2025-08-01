// COPIE E COLE TUDO ABAIXO NO ARQUIVO:
// lib/features/enrollment/presentation/widgets/address_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// MUDANÇA: Converte para ConsumerStatefulWidget
class AddressForm extends ConsumerStatefulWidget {
  const AddressForm({super.key});

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  // Controllers para os campos que o usuário digita.
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  // Controllers para os campos preenchidos automaticamente.
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();

  final List<String> _localizacaoOptions = [
    'Área de assentamento',
    'Terra indígena',
    'Área quilombola',
  ];

  @override
  void initState() {
    super.initState();
    // Preenche os controllers com os dados iniciais do provider.
    final initialData = ref.read(enrollmentProvider).addressData;
    _updateControllers(initialData, forceUpdate: true);
  }

  // Função helper para atualizar todos os controllers.
  void _updateControllers(AddressModel data, {bool forceUpdate = false}) {
    if (forceUpdate || _cepController.text != (data.cep ?? '')) {
      _cepController.text = data.cep ?? '';
    }
    if (forceUpdate || _numeroController.text != (data.numero ?? '')) {
      _numeroController.text = data.numero ?? '';
    }
    if (forceUpdate ||
        _complementoController.text != (data.complemento ?? '')) {
      _complementoController.text = data.complemento ?? '';
    }
    if (forceUpdate || _logradouroController.text != (data.logradouro ?? '')) {
      _logradouroController.text = data.logradouro ?? '';
    }
    if (forceUpdate || _bairroController.text != (data.bairro ?? '')) {
      _bairroController.text = data.bairro ?? '';
    }
    if (forceUpdate || _cidadeController.text != (data.nomeCidade ?? '')) {
      _cidadeController.text = data.nomeCidade ?? '';
    }
    if (forceUpdate || _ufController.text != (data.ufCidade ?? '')) {
      _ufController.text = data.ufCidade ?? '';
    }
  }

  @override
  void dispose() {
    // Lembre-se de fazer o dispose de todos os controllers.
    _cepController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  Future<String?> buscarCepPorEndereco({required String rua, required String cidade, required String uf}) async {
    final url = Uri.parse('https://viacep.com.br/ws/$uf/$cidade/$rua/json/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['cep'];
      }
    }
    return null;
  }

  void _onCepChanged(String cep) async {
    final notifier = ref.read(enrollmentProvider.notifier);
    if (cep.replaceAll(RegExp(r'[^0-9]'), '').length == 8) {
      // Mostra loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Buscando endereço pelo CEP...')),
      );
      final address = await notifier.fetchAddressByCep(cep);
      if (address != null) {
        notifier.updateAddressData(address.copyWith(cep: cep));
        _updateControllers(address.copyWith(cep: cep), forceUpdate: true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Endereço preenchido automaticamente!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP não encontrado. Preencha manualmente.')),
        );
      }
    }
    notifier.updateAddressData(ref.read(enrollmentProvider).addressData.copyWith(cep: cep));
  }

  // Exemplo de função de ajuda contextual
  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EnrollmentState>(enrollmentProvider, (previous, next) {
      if (previous?.addressData != next.addressData) {
        _updateControllers(next.addressData, forceUpdate: false);
      }
    });
    final addressData = ref.watch(enrollmentProvider).addressData;
    final notifier = ref.read(enrollmentProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: 'Endereço',
            children: [
              CustomTextField(
                controller: _cepController,
                labelText: 'CEP',
                keyboardType: TextInputType.number,
                onChanged: _onCepChanged,
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _logradouroController,
                labelText: 'Logradouro',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(logradouro: value)),
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _numeroController,
                labelText: 'Número',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(numero: value)),
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _complementoController,
                labelText: 'Complemento',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(complemento: value)),
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _bairroController,
                labelText: 'Bairro',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(bairro: value)),
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _cidadeController,
                labelText: 'Cidade',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(nomeCidade: value)),
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _ufController,
                labelText: 'UF',
                onChanged: (value) => notifier.updateAddressData(addressData.copyWith(ufCidade: value)),
              ),
            ],
          ),
          FormSection(
            title: 'Detalhes do Endereço',
            children: [
              const Text('Zona', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Urbana'),
                value: 'Urbana',
                groupValue: addressData.zona,
                onChanged:
                    (value) => notifier.updateAddressData(
                      addressData.copyWith(zona: value),
                    ),
              ),
              RadioListTile<String>(
                title: const Text('Rural'),
                value: 'Rural',
                groupValue: addressData.zona,
                onChanged:
                    (value) => notifier.updateAddressData(
                      addressData.copyWith(zona: value),
                    ),
              ),
              const Divider(height: 32),
              SwitchListTile(
                title: const Text('Localização Diferenciada?'),
                subtitle: Text(
                  addressData.temLocalizacaoDiferenciada ? 'Sim' : 'Não',
                  style: TextStyle(
                    color: addressData.temLocalizacaoDiferenciada ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: addressData.temLocalizacaoDiferenciada,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                onChanged: (bool value) => notifier.updateAddressData(
                  addressData.copyWith(
                    temLocalizacaoDiferenciada: value,
                    localizacaoDiferenciada: null,
                  ),
                ),
                secondary: IconButton(
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'O que é localização diferenciada?',
                  onPressed: () {
                    _showHelpDialog(
                      context,
                      'Ajuda',
                      'Localização diferenciada refere-se a áreas de assentamento, terras indígenas ou quilombolas, conforme classificação do INEP. Se o endereço se enquadra em alguma dessas categorias, selecione e especifique.',
                    );
                  },
                ),
              ),
              if (addressData.temLocalizacaoDiferenciada)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: addressData.localizacaoDiferenciada,
                    decoration: const InputDecoration(
                      labelText: 'Qual?',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _localizacaoOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged:
                        (String? newValue) => notifier.updateAddressData(
                          addressData.copyWith(
                            localizacaoDiferenciada: newValue,
                          ),
                        ),
                  ),
                ),
            ],
          ),
          // Botão de salvar foi removido para ser centralizado na tela principal do stepper.
        ],
      ),
    );
  }
}
