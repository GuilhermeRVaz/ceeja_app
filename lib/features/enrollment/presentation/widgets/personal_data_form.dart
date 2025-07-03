// COPIE E COLE TUDO ABAIXO NO ARQUIVO:
// lib/features/enrollment/presentation/widgets/personal_data_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';

// MUDANÇA: Converte para ConsumerStatefulWidget
class PersonalDataForm extends ConsumerStatefulWidget {
  const PersonalDataForm({super.key});

  @override
  ConsumerState<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends ConsumerState<PersonalDataForm> {
  // Os controllers continuam aqui para gerenciar os campos de texto.
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
  final _nomeGemeoController = TextEditingController();
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

  bool _alreadyListened = false;

  @override
  void initState() {
    super.initState();
    final initialData = ref.read(enrollmentProvider).personalData;
    _updateControllers(initialData, forceUpdate: true);
  }

  // Função helper para atualizar todos os controllers com base no modelo de dados.
  void _updateControllers(PersonalDataModel data, {bool forceUpdate = false}) {
    if (forceUpdate ||
        _nomeCompletoController.text != (data.nomeCompleto ?? '')) {
      _nomeCompletoController.text = data.nomeCompleto ?? '';
    }
    if (forceUpdate || _nomeSocialController.text != (data.nomeSocial ?? '')) {
      _nomeSocialController.text = data.nomeSocial ?? '';
    }
    if (forceUpdate || _rgController.text != (data.rg ?? '')) {
      _rgController.text = data.rg ?? '';
    }
    if (forceUpdate || _cpfController.text != (data.cpf ?? '')) {
      _cpfController.text = data.cpf ?? '';
    }
    if (data.dataNascimento != null) {
      final formattedDate = DateFormat(
        'dd/MM/yyyy',
      ).format(data.dataNascimento!);
      if (forceUpdate || _dataNascimentoController.text != formattedDate) {
        _dataNascimentoController.text = formattedDate;
      }
      final calculatedAge = _calculateAge(data.dataNascimento!).toString();
      if (forceUpdate || _idadeController.text != calculatedAge) {
        _idadeController.text = calculatedAge;
      }
    } else {
      if (forceUpdate || _dataNascimentoController.text.isNotEmpty) {
        _dataNascimentoController.clear();
      }
      if (forceUpdate || _idadeController.text.isNotEmpty) {
        _idadeController.clear();
      }
    }
    if (forceUpdate || _nomeMaeController.text != (data.nomeMae ?? '')) {
      _nomeMaeController.text = data.nomeMae ?? '';
    }
    if (forceUpdate || _nomePaiController.text != (data.nomePai ?? '')) {
      _nomePaiController.text = data.nomePai ?? '';
    }
    if (forceUpdate ||
        _nomeAfetivoController.text != (data.nomeAfetivo ?? '')) {
      _nomeAfetivoController.text = data.nomeAfetivo ?? '';
    }
    if (forceUpdate || _rgDigitoController.text != (data.rgDigito ?? '')) {
      _rgDigitoController.text = data.rgDigito ?? '';
    }
    if (forceUpdate || _rgUfController.text != (data.rgUf ?? '')) {
      _rgUfController.text = data.rgUf ?? '';
    }
    if (data.rgDataEmissao != null) {
      final formattedDate = DateFormat(
        'dd/MM/yyyy',
      ).format(data.rgDataEmissao!);
      if (forceUpdate || _rgDataEmissaoController.text != formattedDate) {
        _rgDataEmissaoController.text = formattedDate;
      }
    } else {
      if (forceUpdate || _rgDataEmissaoController.text.isNotEmpty) {
        _rgDataEmissaoController.clear();
      }
    }
    if (forceUpdate || _telefoneController.text != (data.telefone ?? '')) {
      _telefoneController.text = data.telefone ?? '';
    }
    if (forceUpdate || _emailController.text != (data.email ?? '')) {
      _emailController.text = data.email ?? '';
    }
    if (forceUpdate || _nomeGemeoController.text != (data.nomeGemeo ?? '')) {
      _nomeGemeoController.text = data.nomeGemeo ?? '';
    }
    if (forceUpdate || _profissaoController.text != (data.profissao ?? '')) {
      _profissaoController.text = data.profissao ?? '';
    }
    if (forceUpdate || _empresaController.text != (data.empresa ?? '')) {
      _empresaController.text = data.empresa ?? '';
    }
    if (forceUpdate ||
        _deficienciaController.text != (data.deficiencia ?? '')) {
      _deficienciaController.text = data.deficiencia ?? '';
    }
  }

  // Função helper para calcular a idade.
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Função para abrir o seletor de data.
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
      onDateSelected(picked);
    }
  }

  @override
  void dispose() {
    // Lembre-se de fazer o dispose de todos os controllers.
    _nomeCompletoController.dispose();
    _nomeSocialController.dispose();
    _rgController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _idadeController.dispose();
    _nomeMaeController.dispose();
    _nomePaiController.dispose();
    _nomeAfetivoController.dispose();
    _rgDigitoController.dispose();
    _rgUfController.dispose();
    _rgDataEmissaoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _nomeGemeoController.dispose();
    _profissaoController.dispose();
    _empresaController.dispose();
    _deficienciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adiciona o listener apenas uma vez
    if (!_alreadyListened) {
      ref.listen<EnrollmentState>(enrollmentProvider, (previous, next) {
        if (previous?.personalData != next.personalData) {
          _updateControllers(next.personalData, forceUpdate: true);
        }
      });
      _alreadyListened = true;
    }
    // MUDANÇA: Acessa os dados e o notifier de forma mais limpa.
    final personalData = ref.watch(enrollmentProvider).personalData;
    final notifier = ref.read(enrollmentProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: '2. Dados Pessoais', // Atualizado para refletir a nova ordem
            children: [
              CustomTextField(
                controller: _nomeCompletoController,
                labelText: 'Nome Completo',
                // MUDANÇA: O onChanged agora atualiza o provider.
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(nomeCompleto: value),
                    ),
              ),
              const SizedBox(height: 16),
              // Exemplo de como um SwitchListTile deve ser adaptado:
              SwitchListTile(
                title: const Text('Possui Nome Social?'),
                value: personalData.temNomeSocial,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(
                        temNomeSocial: value,
                        nomeSocial: '',
                      ),
                    ),
              ),
              if (personalData.temNomeSocial)
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
                        (value) => notifier.updatePersonalData(
                          personalData.copyWith(nomeSocial: value),
                        ),
                  ),
                ),
              //
              // Continue adaptando todos os outros campos da mesma forma...
              //
              const SizedBox(height: 16),
              CustomTextField(
                controller: _cpfController,
                labelText: 'CPF',
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(cpf: value),
                    ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _dataNascimentoController,
                labelText: 'Data de Nascimento',
                readOnly: true,
                onTap:
                    () =>
                        _selectDate(context, _dataNascimentoController, (date) {
                          final calculatedAge = _calculateAge(date);
                          notifier.updatePersonalData(
                            personalData.copyWith(
                              dataNascimento: date,
                              idade: calculatedAge,
                            ),
                          );
                        }),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _idadeController,
                labelText: 'Idade',
                enabled: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nomeMaeController,
                labelText: 'Nome da Mãe',
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(nomeMae: value),
                    ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nomePaiController,
                labelText: 'Nome do Pai',
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(nomePai: value),
                    ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui Nome Afetivo?'),
                value: personalData.temNomeAfetivo,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(
                        temNomeAfetivo: value,
                        nomeAfetivo: '',
                      ),
                    ),
              ),
              if (personalData.temNomeAfetivo)
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
                        (value) => notifier.updatePersonalData(
                          personalData.copyWith(nomeAfetivo: value),
                        ),
                  ),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: personalData.sexo,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                items:
                    <String>[
                      'Masculino',
                      'Feminino',
                      'Não Binário',
                      'Outro',
                      'Prefiro não informar',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  notifier.updatePersonalData(
                    personalData.copyWith(sexo: newValue),
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: personalData.racaCor,
                decoration: const InputDecoration(
                  labelText: 'Raça/Cor',
                  border: OutlineInputBorder(),
                ),
                items:
                    _racaOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  notifier.updatePersonalData(
                    personalData.copyWith(racaCor: newValue),
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: personalData.nacionalidade,
                decoration: const InputDecoration(
                  labelText: 'Nacionalidade',
                  border: OutlineInputBorder(),
                ),
                items:
                    <String>[
                      'Brasileira',
                      'Estrangeira',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  notifier.updatePersonalData(
                    personalData.copyWith(nacionalidade: newValue),
                  );
                },
              ),
              if (personalData.nacionalidade == 'Estrangeira') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _telefoneController,
                  labelText: 'Telefone',
                  keyboardType: TextInputType.phone,
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(telefone: value),
                      ),
                ),
              ] else if (personalData.nacionalidade == 'Brasileira') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _rgController,
                  labelText: 'RG',
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(rg: value),
                      ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _rgDigitoController,
                  labelText: 'Dígito RG',
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(rgDigito: value),
                      ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _rgUfController,
                  labelText: 'UF do RG',
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(rgUf: value),
                      ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _rgDataEmissaoController,
                  labelText: 'Data de Emissão do RG',
                  readOnly: true,
                  onTap:
                      () => _selectDate(context, _rgDataEmissaoController, (
                        date,
                      ) {
                        notifier.updatePersonalData(
                          personalData.copyWith(rgDataEmissao: date),
                        );
                      }),
                ),
              ],
              const SizedBox(height: 16),
              CustomTextField(
                controller: _telefoneController,
                labelText: 'Telefone',
                keyboardType: TextInputType.phone,
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(telefone: value),
                    ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                onChanged:
                    (value) => notifier.updatePersonalData(
                      personalData.copyWith(email: value),
                    ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui Internet?'),
                value: personalData.possuiInternet ?? false,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(possuiInternet: value),
                    ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui Dispositivo (Celular/Computador)?'),
                value: personalData.possuiDevice ?? false,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(possuiDevice: value),
                    ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('É Gêmeo(a)?'),
                value: personalData.isGemeo ?? false,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(isGemeo: value, nomeGemeo: ''),
                    ),
              ),
              if (personalData.isGemeo ?? false)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: CustomTextField(
                    controller: _nomeGemeoController,
                    labelText: 'Nome do Gêmeo(a)',
                    onChanged:
                        (value) => notifier.updatePersonalData(
                          personalData.copyWith(nomeGemeo: value),
                        ),
                  ),
                ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Trabalha Atualmente?'),
                value: personalData.trabalha ?? false,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(
                        trabalha: value,
                        profissao: '',
                        empresa: '',
                      ),
                    ),
              ),
              if (personalData.trabalha ?? false) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _profissaoController,
                  labelText: 'Profissão',
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(profissao: value),
                      ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _empresaController,
                  labelText: 'Empresa',
                  onChanged:
                      (value) => notifier.updatePersonalData(
                        personalData.copyWith(empresa: value),
                      ),
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Possui Deficiência (PCD)?'),
                value: personalData.isPCD ?? false,
                onChanged:
                    (bool value) => notifier.updatePersonalData(
                      personalData.copyWith(isPCD: value, deficiencia: ''),
                    ),
              ),
              if (personalData.isPCD ?? false)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: CustomTextField(
                    controller: _deficienciaController,
                    labelText: 'Qual a Deficiência?',
                    onChanged:
                        (value) => notifier.updatePersonalData(
                          personalData.copyWith(deficiencia: value),
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
