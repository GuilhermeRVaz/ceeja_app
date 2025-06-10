import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
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
    final provider = context.read<EnrollmentProvider>();
    final data = provider.addressData;
    _cepController.text = data.cep ?? '';
    _numeroController.text = data.numero ?? '';
    _complementoController.text = data.complemento ?? '';
  }

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  void _onCepChanged(String cep) {
    final provider = context.read<EnrollmentProvider>();
    provider.updateAddressData(provider.addressData.copyWith(cep: cep));

    final cleanedCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedCep.length == 8) {
      provider.fetchAddressByCep(cleanedCep);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnrollmentProvider>();
    final data = provider.addressData;

    _logradouroController.text = data.logradouro ?? '';
    _bairroController.text = data.bairro ?? '';
    _cidadeController.text = data.nomeCidade ?? '';
    _ufController.text = data.ufCidade ?? '';

    void updateProvider(AddressModel updatedData) {
      context.read<EnrollmentProvider>().updateAddressData(updatedData);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: 'Endereço Principal',
            children: [
              CustomTextField(
                controller: _cepController,
                labelText: 'CEP',
                keyboardType: TextInputType.number,
                onChanged: _onCepChanged,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _logradouroController,
                labelText: 'Rua / Logradouro',
                enabled: false,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _numeroController,
                      labelText: 'Número',
                      keyboardType: TextInputType.number,
                      onChanged:
                          (value) =>
                              updateProvider(data.copyWith(numero: value)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _complementoController,
                      labelText: 'Complemento',
                      onChanged:
                          (value) =>
                              updateProvider(data.copyWith(complemento: value)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bairroController,
                labelText: 'Bairro',
                enabled: false,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cidadeController,
                      labelText: 'Cidade',
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _ufController,
                      labelText: 'Estado',
                      enabled: false,
                    ),
                  ),
                ],
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
                groupValue: data.zona,
                onChanged:
                    (value) => updateProvider(data.copyWith(zona: value)),
              ),
              RadioListTile<String>(
                title: const Text('Rural'),
                value: 'Rural',
                groupValue: data.zona,
                onChanged:
                    (value) => updateProvider(data.copyWith(zona: value)),
              ),
              const Divider(height: 32),
              SwitchListTile(
                title: const Text('Localização Diferenciada?'),
                value: data.temLocalizacaoDiferenciada,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(
                        temLocalizacaoDiferenciada: value,
                        localizacaoDiferenciada: null,
                      ),
                    ),
              ),
              if (data.temLocalizacaoDiferenciada)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: data.localizacaoDiferenciada,
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
                        (String? newValue) => updateProvider(
                          data.copyWith(localizacaoDiferenciada: newValue),
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
