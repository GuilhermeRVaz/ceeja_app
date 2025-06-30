import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/discipline_selection_panel.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceeja_app/core/widgets/custom_text_field.dart';

// MUDANÇA: Converte para ConsumerStatefulWidget
class SchoolingForm extends ConsumerStatefulWidget {
  const SchoolingForm({super.key});

  @override
  ConsumerState<SchoolingForm> createState() => _SchoolingFormState();
}

class _SchoolingFormState extends ConsumerState<SchoolingForm> {
  final _raController = TextEditingController();
  final _nomeEscolaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche o controller com os dados iniciais do provider.
    final initialData = ref.read(enrollmentProvider).schoolingData;
    _updateControllers(initialData, forceUpdate: true);
  }

  @override
  void dispose() {
    _raController.dispose();
    _nomeEscolaController.dispose();
    super.dispose();
  }

  // Função helper para atualizar todos os controllers.
  void _updateControllers(SchoolingModel data, {bool forceUpdate = false}) {
    if (forceUpdate || _raController.text != (data.ra ?? '')) {
      _raController.text = data.ra ?? '';
    }
    if (forceUpdate || _nomeEscolaController.text != (data.nomeEscola ?? '')) {
      _nomeEscolaController.text = data.nomeEscola ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // MUDANÇA: Ouve as mudanças no provider para manter o controller sincronizado.
    ref.listen<EnrollmentState>(enrollmentProvider, (previous, next) {
      if (previous?.schoolingData != next.schoolingData) {
        _updateControllers(next.schoolingData, forceUpdate: false);
      }
    });

    // MUDANÇA: Acessa os dados e o notifier do provider.
    final schoolingData = ref.watch(enrollmentProvider).schoolingData;
    final notifier = ref.read(enrollmentProvider.notifier);

    // --- Listas de Opções (movidas para dentro do build para clareza) ---
    const itinerarios = [
      'Linguagens e Ciências Humanas',
      'Matemática e Ciências da Natureza',
    ];
    const seriesFundamental = [
      '4ª Série Ensino Fundamental',
      '5ª Série Ensino Fundamental',
      '6ª Série Ensino Fundamental',
      '7ª Série Ensino Fundamental',
    ];
    const seriesMedio = [
      '8ª Série Ensino Fundamental',
      '1ª Série do Ensino Médio',
      '2ª Série do Ensino Médio',
      '3ª Série do Ensino Médio',
    ];
    const disciplinasFundamental = [
      'Língua Portuguesa',
      'Arte',
      'Língua Inglesa',
      'Matemática',
      'Ciências',
      'História',
      'Geografia',
      'Educação Física',
    ];
    const disciplinasMedio = [
      'Língua Portuguesa',
      'Arte',
      'Língua Inglesa',
      'Matemática',
      'Biologia',
      'Química',
      'Física',
      'História',
      'Geografia',
      'Sociologia',
      'Filosofia',
      'Educação Física',
    ];
    final disciplineOptionsMap = {
      '8ª Série Ensino Fundamental': disciplinasFundamental,
      '1ª Série do Ensino Médio': disciplinasMedio,
      '2ª Série do Ensino Médio': disciplinasMedio,
      '3ª Série do Ensino Médio': disciplinasMedio,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: '4. Escolaridade',
            children: [
              RadioListTile<String>(
                title: const Text('Ensino Fundamental'),
                value: 'Ensino Fundamental',
                groupValue: schoolingData.nivelEnsino,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(
                        nivelEnsino: value,
                        itinerarioFormativo: null,
                        ultimaSerieConcluida: null,
                      ),
                    ),
              ),
              RadioListTile<String>(
                title: const Text('Ensino Médio'),
                value: 'Ensino Médio',
                groupValue: schoolingData.nivelEnsino,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(
                        nivelEnsino: value,
                        itinerarioFormativo: null,
                        ultimaSerieConcluida: null,
                      ),
                    ),
              ),
              if (schoolingData.nivelEnsino == 'Ensino Médio') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: schoolingData.itinerarioFormativo,
                  decoration: const InputDecoration(
                    labelText: 'Área do Itinerário Formativo',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      itinerarios
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (value) => notifier.updateSchoolingData(
                        schoolingData.copyWith(itinerarioFormativo: value),
                      ),
                ),
              ],
              if (schoolingData.nivelEnsino != null) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: schoolingData.ultimaSerieConcluida,
                  decoration: const InputDecoration(
                    labelText: 'Última série concluída',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      (schoolingData.nivelEnsino == 'Ensino Fundamental'
                              ? seriesFundamental
                              : seriesMedio)
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (value) => notifier.updateSchoolingData(
                        schoolingData.copyWith(ultimaSerieConcluida: value),
                      ),
                ),
              ],
            ],
          ),
          FormSection(
            title: 'Dados de Registro',
            children: [
              CustomTextField(
                controller: _raController,
                labelText: 'RA (Registro do Aluno)',
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(ra: value),
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: schoolingData.tipoEscola,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Escola',
                  border: OutlineInputBorder(),
                ),
                items:
                    <String>[
                      'Pública',
                      'Privada',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  notifier.updateSchoolingData(
                    schoolingData.copyWith(tipoEscola: newValue),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nomeEscolaController,
                labelText: 'Nome da Escola',
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(nomeEscola: value),
                    ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          FormSection(
            title: 'Histórico Acadêmico',
            children: [
              SwitchListTile(
                title: const Text('Já estudou no CEEJA de Lins antes?'),
                value: schoolingData.estudouNoCeeja ?? false,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(estudouNoCeeja: value),
                    ),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Tem Progressão Parcial (dependência)?'),
                value: schoolingData.temProgressaoParcial ?? false,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(
                        temProgressaoParcial: value,
                        progressaoParcialDisciplinas: {},
                      ),
                    ),
              ),
              if (schoolingData.temProgressaoParcial == true)
                _buildDisciplinePanel(
                  context: context,
                  seriesOptions: seriesMedio,
                  disciplineOptions: disciplineOptionsMap,
                  selectedDisciplines:
                      schoolingData.progressaoParcialDisciplinas ?? {},
                  onChanged:
                      (newSelection) => notifier.updateSchoolingData(
                        schoolingData.copyWith(
                          progressaoParcialDisciplinas: newSelection,
                        ),
                      ),
                ),
              const Divider(),
              SwitchListTile(
                title: const Text(
                  'Eliminou Disciplina por ENCCEJA, ENEM, etc.?',
                ),
                value: schoolingData.eliminouDisciplina ?? false,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(
                        eliminouDisciplina: value,
                        eliminouDisciplinaNivel: null,
                        eliminouDisciplinas: [],
                      ),
                    ),
              ),
              if (schoolingData.eliminouDisciplina == true) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nível da Eliminação:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RadioListTile<String>(
                        title: const Text('Ensino Fundamental'),
                        value: 'Ensino Fundamental',
                        groupValue: schoolingData.eliminouDisciplinaNivel,
                        onChanged:
                            (value) => notifier.updateSchoolingData(
                              schoolingData.copyWith(
                                eliminouDisciplinaNivel: value,
                                eliminouDisciplinas: [],
                              ),
                            ),
                      ),
                      RadioListTile<String>(
                        title: const Text('Ensino Médio'),
                        value: 'Ensino Médio',
                        groupValue: schoolingData.eliminouDisciplinaNivel,
                        onChanged:
                            (value) => notifier.updateSchoolingData(
                              schoolingData.copyWith(
                                eliminouDisciplinaNivel: value,
                                eliminouDisciplinas: [],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                if (schoolingData.eliminouDisciplinaNivel != null)
                  _buildEliminatedDisciplineCheckboxes(
                    context: context,
                    disciplineOptions:
                        schoolingData.eliminouDisciplinaNivel ==
                                'Ensino Fundamental'
                            ? disciplinasFundamental
                            : disciplinasMedio,
                    selectedDisciplines:
                        schoolingData.eliminouDisciplinas ?? [],
                    onChanged:
                        (newSelection) => notifier.updateSchoolingData(
                          schoolingData.copyWith(
                            eliminouDisciplinas: newSelection,
                          ),
                        ),
                  ),
              ],
            ],
          ),
          FormSection(
            title: 'Disciplinas Opcionais',
            children: [
              CheckboxListTile(
                title: const Text('Ensino Religioso'),
                value: schoolingData.optouEnsinoReligioso ?? false,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(optouEnsinoReligioso: value),
                    ),
              ),
              CheckboxListTile(
                title: const Text('Educação Física'),
                value: schoolingData.optouEducacaoFisica ?? false,
                onChanged: (value) {
                  if (value == true) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Atenção'),
                            content: const Text(
                              "A opção de Educação Física é facultativa, mas condicionada a escolha de pelo menos 30 alunos ativos de forma, ainda, dependendo da disponibilidade de professor habilitado e serão ministradas aulas ministradas sempre aos sábado, caso não concorde, desmarque a seleção.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  }
                  notifier.updateSchoolingData(
                    schoolingData.copyWith(optouEducacaoFisica: value),
                  );
                },
              ),
            ],
          ),
          FormSection(
            title: 'Termos de Matrícula',
            children: [
              const Text(
                'Declaro que todas informações são verdadeiras. Declaro que tenho condições de comparecer às orientações e avaliações. Declaro ciência de que terei minha matrícula cancelada caso não tenha pelo menos 1 (um) comparecimento por mês e que devo efetuar minha rematricula a cada ano.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Li e aceito os termos'),
                value: schoolingData.aceitouTermos ?? false,
                onChanged:
                    (value) => notifier.updateSchoolingData(
                      schoolingData.copyWith(
                        aceitouTermos: value,
                        dataAceite: value == true ? DateTime.now() : null,
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await notifier.submitEnrollment();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Dados de escolaridade salvos com sucesso!'),
                  ),
                );
              },
              child: const Text('Salvar Dados de Escolaridade'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisciplinePanel({
    required BuildContext context,
    required List<String> seriesOptions,
    required Map<String, List<String>> disciplineOptions,
    required Map<String, List<String>> selectedDisciplines,
    required Function(Map<String, List<String>>) onChanged,
  }) {
    return DisciplineSelectionPanel(
      seriesOptions: seriesOptions,
      disciplineOptions: disciplineOptions,
      initialSelection: selectedDisciplines,
      onChanged: onChanged,
    );
  }

  Widget _buildEliminatedDisciplineCheckboxes({
    required BuildContext context,
    required List<String> disciplineOptions,
    required List<String> selectedDisciplines,
    required Function(List<String>) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children:
            disciplineOptions.map((discipline) {
              final isSelected = selectedDisciplines.contains(discipline);
              return ChoiceChip(
                label: Text(discipline),
                selected: isSelected,
                onSelected: (selected) {
                  final newSelection = List<String>.from(selectedDisciplines);
                  if (selected) {
                    newSelection.add(discipline);
                  } else {
                    newSelection.remove(discipline);
                  }
                  onChanged(newSelection);
                },
              );
            }).toList(),
      ),
    );
  }
}
