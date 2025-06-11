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
  final _nomeGemeoController = TextEditingController();
  final _nascimentoUfController = TextEditingController(); // Novo controller
  final _nascimentoCidadeController =
      TextEditingController(); // Novo controller
  final _paisOrigemController = TextEditingController(); // Novo controller

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
    provider.loadPersonalData().then((_) {
      final data = provider.personalData;
      _nomeCompletoController.text = data.nomeCompleto ?? '';
      _nomeSocialController.text = data.nomeSocial ?? '';
      _nomeAfetivoController.text = data.nomeAfetivo ?? '';
      _rgController.text = data.rg ?? '';
      _rgDigitoController.text = data.rgDigito ?? '';
      _rgUfController.text = data.rgUf ?? '';
      if (data.rgDataEmissao != null) {
        _rgDataEmissaoController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(data.rgDataEmissao!);
      }
      _cpfController.text = data.cpf ?? '';
      if (data.dataNascimento != null) {
        _dataNascimentoController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(data.dataNascimento!);
        _calculateAndSetAge(data.dataNascimento!); // Remover o provider
      }
      _idadeController.text = data.idade?.toString() ?? ''; // Carregar idade
      _nomeMaeController.text = data.nomeMae ?? '';
      _nomePaiController.text = data.nomePai ?? '';
      _telefoneController.text = data.telefone ?? '';
      _emailController.text = data.email ?? '';
      _profissaoController.text = data.profissao ?? '';
      _empresaController.text = data.empresa ?? '';
      _deficienciaController.text = data.deficiencia ?? '';
      _nomeGemeoController.text = data.nomeGemeo ?? '';
      _nascimentoUfController.text =
          data.nascimentoUf ?? ''; // Carregar UF de nascimento
      _nascimentoCidadeController.text =
          data.nascimentoCidade ?? ''; // Carregar cidade de nascimento
      _paisOrigemController.text =
          data.paisOrigem ?? ''; // Carregar país de origem
    });
  }

  int _calculateAndSetAge(DateTime birthDate) {
    // Retornar a idade
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    _idadeController.text = age.toString();
    return age; // Retornar a idade calculada
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
                          () => _selectDate(context, _dataNascimentoController, (
                            date,
                          ) {
                            final calculatedAge = _calculateAndSetAge(
                              date,
                            ); // Obter a idade calculada
                            updateProvider(
                              data.copyWith(
                                dataNascimento: date,
                                idade:
                                    calculatedAge, // Incluir a idade na atualização
                              ),
                            );
                          }),
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
            title: 'Nacionalidade e Naturalidade', // Nova seção
            children: [
              DropdownButtonFormField<String>(
                value: data.nacionalidade,
                decoration: const InputDecoration(
                  labelText: 'Nacionalidade',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Brasileira',
                    child: Text('Brasileira'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Estrangeira',
                    child: Text('Estrangeira'),
                  ),
                ],
                onChanged: (String? newValue) {
                  updateProvider(
                    data.copyWith(
                      nacionalidade: newValue,
                      nascimentoUf: '',
                      nascimentoCidade: '',
                      paisOrigem: '',
                    ),
                  );
                },
              ),
              if (data.nacionalidade == 'Brasileira') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nascimentoUfController,
                  labelText: 'Qual Estado/UF nasceu?',
                  onChanged:
                      (value) =>
                          updateProvider(data.copyWith(nascimentoUf: value)),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nascimentoCidadeController,
                  labelText: 'Qual Cidade de Nascimento?',
                  onChanged:
                      (value) => updateProvider(
                        data.copyWith(nascimentoCidade: value),
                      ),
                ),
              ],
              if (data.nacionalidade == 'Estrangeira') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _paisOrigemController,
                  labelText: 'Qual País nasceu?',
                  onChanged:
                      (value) =>
                          updateProvider(data.copyWith(paisOrigem: value)),
                ),
              ],
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
                title: const Text('Possui irmão gêmeo?'), // Novo campo
                value: data.isGemeo ?? false,
                onChanged:
                    (bool value) => updateProvider(
                      data.copyWith(isGemeo: value, nomeGemeo: ''),
                    ),
              ),
              if (data.isGemeo == true)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: CustomTextField(
                    controller: _nomeGemeoController,
                    labelText: 'Nome do Irmão Gêmeo',
                    onChanged:
                        (value) =>
                            updateProvider(data.copyWith(nomeGemeo: value)),
                  ),
                ),
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
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await provider.savePersonalData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dados pessoais salvos com sucesso!'),
                  ),
                );
              },
              child: const Text('Salvar Dados Pessoais'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _nomeSocialController.dispose();
    _nomeAfetivoController.dispose();
    _rgController.dispose();
    _rgDigitoController.dispose();
    _rgUfController.dispose();
    _rgDataEmissaoController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _idadeController.dispose();
    _nomeMaeController.dispose();
    _nomePaiController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _profissaoController.dispose();
    _empresaController.dispose();
    _deficienciaController.dispose();
    _nomeGemeoController.dispose();
    _nascimentoUfController.dispose(); // Dispose do novo controller
    _nascimentoCidadeController.dispose(); // Dispose do novo controller
    _paisOrigemController.dispose(); // Dispose do novo controller
    super.dispose();
  }
}
