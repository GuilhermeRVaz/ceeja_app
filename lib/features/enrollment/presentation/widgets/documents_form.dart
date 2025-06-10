import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsForm extends StatefulWidget {
  const DocumentsForm({super.key});

  @override
  State<DocumentsForm> createState() => _DocumentsFormState();
}

class _DocumentsFormState extends State<DocumentsForm> {
  late final TextEditingController _cpfController;
  late final TextEditingController _numDocumentoCivilController;
  late final TextEditingController _digitoDocumentoCivilController;
  late final TextEditingController _ufDocumentoCivilController;
  late final TextEditingController _dataEmissaoDocumentoCivilController;
  late final TextEditingController _numeroNisController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<EnrollmentProvider>();
    _cpfController = TextEditingController(text: provider.documentsData.cpf);
    _numDocumentoCivilController = TextEditingController(
      text: provider.documentsData.numDocumentoCivil,
    );
    _digitoDocumentoCivilController = TextEditingController(
      text: provider.documentsData.digitoDocumentoCivil,
    );
    _ufDocumentoCivilController = TextEditingController(
      text: provider.documentsData.ufDocumentoCivil,
    );
    _dataEmissaoDocumentoCivilController = TextEditingController(
      text: provider.documentsData.dataEmissaoDocumentoCivil,
    );
    _numeroNisController = TextEditingController(
      text: provider.documentsData.numeroNis,
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _numDocumentoCivilController.dispose();
    _digitoDocumentoCivilController.dispose();
    _ufDocumentoCivilController.dispose();
    _dataEmissaoDocumentoCivilController.dispose();
    _numeroNisController.dispose();
    super.dispose();
  }

  void _updateProvider() {
    final provider = context.read<EnrollmentProvider>();
    final updatedData = provider.documentsData.copyWith(
      cpf: _cpfController.text,
      numDocumentoCivil: _numDocumentoCivilController.text,
      digitoDocumentoCivil: _digitoDocumentoCivilController.text,
      ufDocumentoCivil: _ufDocumentoCivilController.text,
      dataEmissaoDocumentoCivil: _dataEmissaoDocumentoCivilController.text,
      numeroNis: _numeroNisController.text,
    );
    provider.updateDocumentsData(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _cpfController,
          labelText: 'CPF',
          onChanged: (_) => _updateProvider(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _numDocumentoCivilController,
          labelText: 'Nº do Documento Civil (RG)',
          onChanged: (_) => _updateProvider(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _digitoDocumentoCivilController,
          labelText: 'Dígito do Documento',
          onChanged: (_) => _updateProvider(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _ufDocumentoCivilController,
          labelText: 'UF do Documento',
          onChanged: (_) => _updateProvider(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _dataEmissaoDocumentoCivilController,
          labelText: 'Data de Emissão',
          onChanged: (_) => _updateProvider(),
          keyboardType: TextInputType.datetime,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _numeroNisController,
          labelText: 'NIS (Opcional)',
          onChanged: (_) => _updateProvider(),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
