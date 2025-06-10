import 'dart:typed_data';

import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class DocumentsForm extends StatefulWidget {
  const DocumentsForm({super.key});

  @override
  State<DocumentsForm> createState() => _DocumentsFormState();
}

class _DocumentsFormState extends State<DocumentsForm> {
  String? _rgFrentePath;
  String? _rgVersoPath;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'RG Frente: ${_rgFrentePath != null ? path.basename(_rgFrentePath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('rgFrente'),
          child: const Text('Selecionar RG Frente'),
        ),
        const SizedBox(height: 16),
        Text(
          'RG Verso: ${_rgVersoPath != null ? path.basename(_rgVersoPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('rgVerso'),
          child: const Text('Selecionar RG Verso'),
        ),
        const SizedBox(height: 16),
        Text(
          'CPF: ${_cpfDocPath != null ? path.basename(_cpfDocPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('cpfDoc'),
          child: const Text('Selecionar CPF'),
        ),
        const SizedBox(height: 16),
        Text(
          'Foto 3x4: ${_foto3x4Path != null ? path.basename(_foto3x4Path!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('foto3x4'),
          child: const Text('Selecionar Foto 3x4'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Fundamental: ${_historicoEscolarFundamentalPath != null ? path.basename(_historicoEscolarFundamentalPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarFundamental'),
          child: const Text('Selecionar Histórico Escolar Ensino Fundamental'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Médio: ${_historicoEscolarMedioPath != null ? path.basename(_historicoEscolarMedioPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarMedio'),
          child: const Text('Selecionar Histórico Escolar Ensino Médio'),
        ),
        const SizedBox(height: 16),
        Text(
          'Comprovante de residência: ${_comprovanteResidenciaPath != null ? path.basename(_comprovanteResidenciaPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('comprovanteResidencia'),
          child: const Text('Selecionar Comprovante de residência'),
        ),
        const SizedBox(height: 16),
        Text(
          'Certidão de nascimento ou de casamento: ${_certidaoNascimentoCasamentoPath != null ? path.basename(_certidaoNascimentoCasamentoPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('certidaoNascimentoCasamento'),
          child: const Text(
            'Selecionar Certidão de nascimento ou de casamento',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Reservista (se masculino): ${_reservistaPath != null ? path.basename(_reservistaPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('reservista'),
          child: const Text('Selecionar Reservista (se masculino)'),
        ),
        const SizedBox(height: 16),
        Text(
          'Título de eleitor: ${_tituloEleitorPath != null ? path.basename(_tituloEleitorPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('tituloEleitor'),
          child: const Text('Selecionar Título de eleitor'),
        ),
        const SizedBox(height: 16),
        Text(
          'Carteira de vacinação: ${_carteiraVacinacaoPath != null ? path.basename(_carteiraVacinacaoPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('carteiraVacinacao'),
          child: const Text('Selecionar Carteira de vacinação'),
        ),
        const SizedBox(height: 16),
        Text(
          'Atestado de eliminação de disciplina: ${_atestadoEliminacaoDisciplinaPath != null ? path.basename(_atestadoEliminacaoDisciplinaPath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('atestadoEliminacaoDisciplina'),
          child: const Text('Selecionar Atestado de eliminação de disciplina'),
        ),
        const SizedBox(height: 16),
        Text(
          'Declaração de Transferência ou de escolaridade: ${_declaracaoTransferenciaEscolaridadePath != null ? path.basename(_declaracaoTransferenciaEscolaridadePath!) : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('declaracaoTransferenciaEscolaridade'),
          child: const Text(
            'Selecionar Declaração de Transferência ou de escolaridade',
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile(String documentType) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final PlatformFile file = result.files.first;
      String? filePath = file.path;
      String fileName = file.name;
      Uint8List? bytes = file.bytes;

      if (bytes != null) {
        // Web environment
        // Use bytes instead of path
        // final bytes = file.bytes;
        // final fileName = file.name;

        // Here, you'll need to handle the file upload differently.
        // You can't directly pass a file path to Supabase on the web.
        // Instead, you'll likely want to upload the bytes to Supabase storage.

        // For now, let's just set the file name.
        filePath = fileName;
      } else {
        filePath = file.path;
      }

      final path = filePath;
      setState(() {
        switch (documentType) {
          case 'rgFrente':
            _rgFrentePath = path;
            break;
          case 'rgVerso':
            _rgVersoPath = path;
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
      switch (documentType) {
        case 'rgFrente':
          provider.updateRgFrentePath(path ?? '');
          break;
        case 'rgVerso':
          provider.updateRgVersoPath(path ?? '');
          break;
        case 'cpfDoc':
          provider.updateCpfDocPath(path);
          break;
        case 'foto3x4':
          provider.updateFoto3x4Path(path);
          break;
        case 'historicoEscolarFundamental':
          provider.updateHistoricoEscolarFundamentalPath(path);
          break;
        case 'historicoEscolarMedio':
          provider.updateHistoricoEscolarMedioPath(path);
          break;
        case 'comprovanteResidencia':
          provider.updateComprovanteResidenciaPath(path);
          break;
        case 'certidaoNascimentoCasamento':
          provider.updateCertidaoNascimentoCasamentoPath(path);
          break;
        case 'reservista':
          provider.updateReservistaPath(path);
          break;
        case 'tituloEleitor':
          provider.updateTituloEleitorPath(path);
          break;
        case 'carteiraVacinacao':
          provider.updateCarteiraVacinacaoPath(path);
          break;
        case 'atestadoEliminacaoDisciplina':
          provider.updateAtestadoEliminacaoDisciplinaPath(path);
          break;
        case 'declaracaoTransferenciaEscolaridade':
          provider.updateDeclaracaoTransferenciaEscolaridadePath(path);
          break;
      }
    }
  }
}
