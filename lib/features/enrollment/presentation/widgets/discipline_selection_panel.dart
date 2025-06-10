import 'package:flutter/material.dart';

class DisciplineSelectionPanel extends StatefulWidget {
  final List<String> seriesOptions;
  final Map<String, List<String>> disciplineOptions;
  final Map<String, List<String>> initialSelection;
  final Function(Map<String, List<String>>) onChanged;

  const DisciplineSelectionPanel({
    super.key,
    required this.seriesOptions,
    required this.disciplineOptions,
    required this.initialSelection,
    required this.onChanged,
  });

  @override
  State<DisciplineSelectionPanel> createState() =>
      _DisciplineSelectionPanelState();
}

class _DisciplineSelectionPanelState extends State<DisciplineSelectionPanel> {
  late Map<String, List<String>> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Map.from(widget.initialSelection);
  }

  void _handleDisciplineChange(bool? value, String serie, String discipline) {
    final newSelection = Map<String, List<String>>.from(_selection);
    final disciplinesForSerie = newSelection[serie] ?? [];

    if (value == true) {
      if (!disciplinesForSerie.contains(discipline)) {
        disciplinesForSerie.add(discipline);
      }
    } else {
      disciplinesForSerie.remove(discipline);
    }

    newSelection[serie] = disciplinesForSerie;

    // Remove a série se não houver disciplinas selecionadas
    if (newSelection[serie]!.isEmpty) {
      newSelection.remove(serie);
    }

    setState(() {
      _selection = newSelection;
    });
    widget.onChanged(_selection);
  }

  void _addSerie() {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelectedSerie;
        return AlertDialog(
          title: const Text('Adicionar Série com DP'),
          content: DropdownButton<String>(
            hint: const Text('Selecione a série'),
            value: tempSelectedSerie,
            isExpanded: true,
            items:
                widget.seriesOptions
                    .where(
                      (serie) => !_selection.containsKey(serie),
                    ) // Mostra apenas séries não adicionadas
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selection[value] = [];
                });
                widget.onChanged(_selection);
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._selection.keys.map((serie) {
          final disciplinesForSerie = widget.disciplineOptions[serie] ?? [];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        serie,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selection.remove(serie);
                          });
                          widget.onChanged(_selection);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ...disciplinesForSerie.map((discipline) {
                    return CheckboxListTile(
                      title: Text(discipline),
                      value: _selection[serie]?.contains(discipline) ?? false,
                      onChanged:
                          (value) =>
                              _handleDisciplineChange(value, serie, discipline),
                    );
                  }),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Série com DP'),
          onPressed: _addSerie,
        ),
      ],
    );
  }
}
