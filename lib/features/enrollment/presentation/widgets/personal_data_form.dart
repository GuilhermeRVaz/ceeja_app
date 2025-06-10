import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalDataForm extends StatefulWidget {
  const PersonalDataForm({super.key});

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final _nomeCompletoController = TextEditingController();
  final _nomeSocialController = TextEditingController();
  final _nomeAfetivoController = TextEditingController();
  final _rgController = TextEditingController();
  final _rgDigitoController = TextEditingController();
  final _rgUfController = TextEditingController();
  final _rgDataEmissaoController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _idadeController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _nomePaiController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _empresaController = TextEditingController();
  final _deficienciaController = TextEditingController();

  final List<String> _racaOptions = [
    'Não declarada',
    'Branca',
    'Preta',
    'Parda',
    'Amarela',
    'Indígena',
    'Quilombola',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<EnrollmentProvider>();
    final data = provider.personalData;
    _nomeCompletoController.text = data.nomeCompleto ?? '';
    // ... inicialização de todos os outros controllers
  }

  @override
  void dispose() {
    // ... dispose de todos os controllers
    super.dispose();
  }

  void _calculateAndSetAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    _idadeController.text = age.toString();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
        onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnrollmentProvider>();
    final data = provider.personalData;

    void updateProvider(PersonalDataModel updatedData) {
      context.read<EnrollmentProvider>().updatePersonalData(updatedData);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: 'Identificação',
            children: [
              CustomTextField(
                controller: _nomeCompletoController,
                labelText: 'Nome Completo',
                onChanged:
                    (value) =>
                        updateProvider(data.copyWith(nomeCompleto: value)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui Nome Social?'),
                value: data.temNomeSocial,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(temNomeSocial: value, nomeSocial: ''),
                    ),
              ),
              if (data.temNomeSocial)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: CustomTextField(
                    controller: _nomeSocialController,
                    labelText: 'Qual o Nome Social?',
                    onChanged:
                        (value) =>
                            updateProvider(data.copyWith(nomeSocial: value)),
                  ),
                ),
              SwitchListTile(
                title: const Text('Possui Nome Afetivo?'),
                value: data.temNomeAfetivo,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(temNomeAfetivo: value, nomeAfetivo: ''),
                    ),
              ),
              if (data.temNomeAfetivo)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: CustomTextField(
                    controller: _nomeAfetivoController,
                    labelText: 'Qual o Nome Afetivo?',
                    onChanged:
                        (value) =>
                            updateProvider(data.copyWith(nomeAfetivo: value)),
                  ),
                ),
            ],
          ),
          FormSection(
            title: 'Documentos e Dados Pessoais',
            children: [
              const Text('Sexo'),
              RadioListTile<String>(
                title: const Text('Masculino'),
                value: 'Masculino',
                groupValue: data.sexo,
                onChanged:
                    (value) => updateProvider(data.copyWith(sexo: value)),
              ),
              RadioListTile<String>(
                title: const Text('Feminino'),
                value: 'Feminino',
                groupValue: data.sexo,
                onChanged:
                    (value) => updateProvider(data.copyWith(sexo: value)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _rgController,
                      labelText: 'RG',
                      onChanged:
                          (value) => updateProvider(data.copyWith(rg: value)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: _rgDigitoController,
                      labelText: 'Dígito',
                      onChanged:
                          (value) =>
                              updateProvider(data.copyWith(rgDigito: value)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: _rgUfController,
                      labelText: 'UF',
                      onChanged:
                          (value) => updateProvider(data.copyWith(rgUf: value)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _rgDataEmissaoController,
                labelText: 'Data de Emissão do RG',
                readOnly: true,
                onTap:
                    () => _selectDate(
                      context,
                      _rgDataEmissaoController,
                      (date) =>
                          updateProvider(data.copyWith(rgDataEmissao: date)),
                    ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _cpfController,
                labelText: 'CPF',
                onChanged: (value) => updateProvider(data.copyWith(cpf: value)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: data.racaCor ?? _racaOptions.first,
                decoration: const InputDecoration(
                  labelText: 'Raça ou Cor',
                  border: OutlineInputBorder(),
                ),
                items:
                    _racaOptions
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged:
                    (String? newValue) =>
                        updateProvider(data.copyWith(racaCor: newValue)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _dataNascimentoController,
                      labelText: 'Data de Nascimento',
                      readOnly: true,
                      onTap:
                          () => _selectDate(
                            context,
                            _dataNascimentoController,
                            (date) {
                              _calculateAndSetAge(date);
                              updateProvider(
                                data.copyWith(dataNascimento: date),
                              );
                            },
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _idadeController,
                      labelText: 'Idade',
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
          FormSection(
            title: 'Filiação',
            children: [
              CustomTextField(
                controller: _nomeMaeController,
                labelText: 'Nome Completo da Mãe',
                onChanged:
                    (value) => updateProvider(data.copyWith(nomeMae: value)),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nomePaiController,
                labelText: 'Nome Completo do Pai',
                onChanged:
                    (value) => updateProvider(data.copyWith(nomePai: value)),
              ),
            ],
          ),
          FormSection(
            title: 'Contato e Conectividade',
            children: [
              CustomTextField(
                controller: _telefoneController,
                labelText: 'Telefone',
                onChanged:
                    (value) => updateProvider(data.copyWith(telefone: value)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                onChanged:
                    (value) => updateProvider(data.copyWith(email: value)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui internet em casa?'),
                value: data.possuiInternet ?? false,
                onChanged:
                    (bool value) =>
                        updateProvider(data.copyWith(possuiInternet: value)),
              ),
              SwitchListTile(
                title: const Text('Possui Smartphone, tablet ou notebook?'),
                value: data.possuiDevice ?? false,
                onChanged:
                    (bool value) =>
                        updateProvider(data.copyWith(possuiDevice: value)),
              ),
            ],
          ),
          FormSection(
            title: 'Informações Adicionais',
            children: [
              SwitchListTile(
                title: const Text('Trabalha?'),
                value: data.trabalha ?? false,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(
                        trabalha: value,
                        profissao: '',
                        empresa: '',
                      ),
                    ),
              ),
              if (data.trabalha == true)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _profissaoController,
                        labelText: 'Profissão',
                        onChanged:
                            (value) =>
                                updateProvider(data.copyWith(profissao: value)),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _empresaController,
                        labelText: 'Local ou Nome da Empresa',
                        onChanged:
                            (value) =>
                                updateProvider(data.copyWith(empresa: value)),
                      ),
                    ],
                  ),
                ),
              SwitchListTile(
                title: const Text('Portador de Deficiência?'),
                value: data.isPCD ?? false,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(isPCD: value, deficiencia: ''),
                    ),
              ),
              if (data.isPCD == true)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: CustomTextField(
                    controller: _deficienciaController,
                    labelText: 'Qual?',
                    onChanged:
                        (value) =>
                            updateProvider(data.copyWith(deficiencia: value)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
