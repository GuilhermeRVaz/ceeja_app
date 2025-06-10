import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsForm extends StatefulWidget {
  const DocumentsForm({super.key});

  @override
  State<DocumentsForm> createState() => _DocumentsFormState();
}

class _DocumentsFormState extends State<DocumentsForm> {
  String? _rgPath;
  String? _cpfDocPath;
  String? _foto3x4Path;
  String? _historicoEscolarFundamentalPath;
  String? _historicoEscolarMedioPath;
  String? _comprovanteResidenciaPath;
  String? _certidaoNascimentoCasamentoPath;
  String? _reservistaPath;
  String? _tituloEleitorPath;
  String? _carteiraVacinacaoPath;
  String? _atestadoEliminacaoDisciplinaPath;
  String? _declaracaoTransferenciaEscolaridadePath;

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

  Future<void> _pickFile(String documentType) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final path = result.files.single.path;
      setState(() {
        switch (documentType) {
          case 'rg':
            _rgPath = path;
            break;
          case 'cpfDoc':
            _cpfDocPath = path;
            break;
          case 'foto3x4':
            _foto3x4Path = path;
            break;
          case 'historicoEscolarFundamental':
            _historicoEscolarFundamentalPath = path;
            break;
          case 'historicoEscolarMedio':
            _historicoEscolarMedioPath = path;
            break;
          case 'comprovanteResidencia':
            _comprovanteResidenciaPath = path;
            break;
          case 'certidaoNascimentoCasamento':
            _certidaoNascimentoCasamentoPath = path;
            break;
          case 'reservista':
            _reservistaPath = path;
            break;
          case 'tituloEleitor':
            _tituloEleitorPath = path;
            break;
          case 'carteiraVacinacao':
            _carteiraVacinacaoPath = path;
            break;
          case 'atestadoEliminacaoDisciplina':
            _atestadoEliminacaoDisciplinaPath = path;
            break;
          case 'declaracaoTransferenciaEscolaridade':
            _declaracaoTransferenciaEscolaridadePath = path;
            break;
        }
      });
      final provider = context.read<EnrollmentProvider>();
      provider.updateDocumentsData(
        provider.documentsData,
        rg: _rgPath,
        cpfDoc: _cpfDocPath,
        foto3x4: _foto3x4Path,
        historicoEscolarFundamental: _historicoEscolarFundamentalPath,
        historicoEscolarMedio: _historicoEscolarMedioPath,
        comprovanteResidencia: _comprovanteResidenciaPath,
        certidaoNascimentoCasamento: _certidaoNascimentoCasamentoPath,
        reservista: _reservistaPath,
        tituloEleitor: _tituloEleitorPath,
        carteiraVacinacao: _carteiraVacinacaoPath,
        atestadoEliminacaoDisciplina: _atestadoEliminacaoDisciplinaPath,
        declaracaoTransferenciaEscolaridade:
            _declaracaoTransferenciaEscolaridadePath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text('RG: ${_rgPath ?? 'Nenhum arquivo selecionado'}'),
        ElevatedButton(
          onPressed: () => _pickFile('rg'),
          child: const Text('Selecionar RG'),
        ),
        const SizedBox(height: 16),
        Text('CPF: ${_cpfDocPath ?? 'Nenhum arquivo selecionado'}'),
        ElevatedButton(
          onPressed: () => _pickFile('cpfDoc'),
          child: const Text('Selecionar CPF'),
        ),
        const SizedBox(height: 16),
        Text('Foto 3x4: ${_foto3x4Path ?? 'Nenhum arquivo selecionado'}'),
        ElevatedButton(
          onPressed: () => _pickFile('foto3x4'),
          child: const Text('Selecionar Foto 3x4'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Fundamental: ${_historicoEscolarFundamentalPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarFundamental'),
          child: const Text('Selecionar Histórico Escolar Ensino Fundamental'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Médio: ${_historicoEscolarMedioPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarMedio'),
          child: const Text('Selecionar Histórico Escolar Ensino Médio'),
        ),
        const SizedBox(height: 16),
        Text(
          'Comprovante de residência: ${_comprovanteResidenciaPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('comprovanteResidencia'),
          child: const Text('Selecionar Comprovante de residência'),
        ),
        const SizedBox(height: 16),
        Text(
          'Certidão de nascimento ou de casamento: ${_certidaoNascimentoCasamentoPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('certidaoNascimentoCasamento'),
          child: const Text(
            'Selecionar Certidão de nascimento ou de casamento',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Reservista (se masculino): ${_reservistaPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('reservista'),
          child: const Text('Selecionar Reservista (se masculino)'),
        ),
        const SizedBox(height: 16),
        Text(
          'Título de eleitor: ${_tituloEleitorPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('tituloEleitor'),
          child: const Text('Selecionar Título de eleitor'),
        ),
        const SizedBox(height: 16),
        Text(
          'Carteira de vacinação: ${_carteiraVacinacaoPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('carteiraVacinacao'),
          child: const Text('Selecionar Carteira de vacinação'),
        ),
        const SizedBox(height: 16),
        Text(
          'Atestado de eliminação de disciplina: ${_atestadoEliminacaoDisciplinaPath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('atestadoEliminacaoDisciplina'),
          child: const Text('Selecionar Atestado de eliminação de disciplina'),
        ),
        const SizedBox(height: 16),
        Text(
          'Declaração de Transferência ou de escolaridade: ${_declaracaoTransferenciaEscolaridadePath ?? 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('declaracaoTransferenciaEscolaridade'),
          child: const Text(
            'Selecionar Declaração de Transferência ou de escolaridade',
          ),
        ),
        const SizedBox(height: 16),
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
