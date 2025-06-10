import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/discipline_selection_panel.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/form_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolingForm extends StatelessWidget {
  const SchoolingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnrollmentProvider>();
    final data = provider.schoolingData;

    void updateProvider(SchoolingModel updatedData) {
      context.read<EnrollmentProvider>().updateSchoolingData(updatedData);
    }

    // --- Listas de Opções ---
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
            title: 'Nível de Ensino',
            children: [
              RadioListTile<String>(
                title: const Text('Ensino Fundamental'),
                value: 'Ensino Fundamental',
                groupValue: data.nivelEnsino,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(
                        nivelEnsino: value,
                        itinerarioFormativo: null,
                        ultimaSerieConcluida: null,
                      ),
                    ),
              ),
              RadioListTile<String>(
                title: const Text('Ensino Médio'),
                value: 'Ensino Médio',
                groupValue: data.nivelEnsino,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(
                        nivelEnsino: value,
                        itinerarioFormativo: null,
                        ultimaSerieConcluida: null,
                      ),
                    ),
              ),
              if (data.nivelEnsino == 'Ensino Médio') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: data.itinerarioFormativo,
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
                      (value) => updateProvider(
                        data.copyWith(itinerarioFormativo: value),
                      ),
                ),
              ],
              if (data.nivelEnsino != null) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: data.ultimaSerieConcluida,
                  decoration: const InputDecoration(
                    labelText: 'Última série concluída',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      (data.nivelEnsino == 'Ensino Fundamental'
                              ? seriesFundamental
                              : seriesMedio)
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (value) => updateProvider(
                        data.copyWith(ultimaSerieConcluida: value),
                      ),
                ),
              ],
            ],
          ),
          FormSection(
            title: 'Histórico Acadêmico',
            children: [
              SwitchListTile(
                title: const Text('Já estudou no CEEJA de Lins antes?'),
                value: data.estudouNoCeeja ?? false,
                onChanged:
                    (value) =>
                        updateProvider(data.copyWith(estudouNoCeeja: value)),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Tem Progressão Parcial (dependência)?'),
                value: data.temProgressaoParcial ?? false,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(
                        temProgressaoParcial: value,
                        progressaoParcialDisciplinas: {},
                      ),
                    ),
              ),
              if (data.temProgressaoParcial == true)
                _buildDisciplinePanel(
                  context: context,
                  seriesOptions: seriesMedio,
                  disciplineOptions: disciplineOptionsMap,
                  selectedDisciplines: data.progressaoParcialDisciplinas ?? {},
                  onChanged:
                      (newSelection) => updateProvider(
                        data.copyWith(
                          progressaoParcialDisciplinas: newSelection,
                        ),
                      ),
                ),
              const Divider(),
              SwitchListTile(
                title: const Text(
                  'Eliminou Disciplina por ENCCEJA, ENEM, etc.?',
                ),
                value: data.eliminouDisciplina ?? false,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(
                        eliminouDisciplina: value,
                        eliminouDisciplinaNivel: null,
                        eliminouDisciplinas: [],
                      ),
                    ),
              ),
              if (data.eliminouDisciplina == true) ...[
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
                        groupValue: data.eliminouDisciplinaNivel,
                        onChanged:
                            (value) => updateProvider(
                              data.copyWith(
                                eliminouDisciplinaNivel: value,
                                eliminouDisciplinas: [],
                              ),
                            ),
                      ),
                      RadioListTile<String>(
                        title: const Text('Ensino Médio'),
                        value: 'Ensino Médio',
                        groupValue: data.eliminouDisciplinaNivel,
                        onChanged:
                            (value) => updateProvider(
                              data.copyWith(
                                eliminouDisciplinaNivel: value,
                                eliminouDisciplinas: [],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                if (data.eliminouDisciplinaNivel != null)
                  _buildEliminatedDisciplineCheckboxes(
                    context: context,
                    disciplineOptions:
                        data.eliminouDisciplinaNivel == 'Ensino Fundamental'
                            ? disciplinasFundamental
                            : disciplinasMedio,
                    selectedDisciplines: data.eliminouDisciplinas ?? [],
                    onChanged:
                        (newSelection) => updateProvider(
                          data.copyWith(eliminouDisciplinas: newSelection),
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
                value: data.optouEnsinoReligioso ?? false,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(optouEnsinoReligioso: value),
                    ),
              ),
              CheckboxListTile(
                title: const Text('Educação Física'),
                value: data.optouEducacaoFisica ?? false,
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
                  updateProvider(data.copyWith(optouEducacaoFisica: value));
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
                value: data.aceitouTermos ?? false,
                onChanged:
                    (value) => updateProvider(
                      data.copyWith(
                        aceitouTermos: value,
                        dataAceite: value == true ? DateTime.now() : null,
                      ),
                    ),
              ),
            ],
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
