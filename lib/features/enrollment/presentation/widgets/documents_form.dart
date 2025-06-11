import 'dart:typed_data';

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
  String? _rgFrentePath;
  Uint8List? _rgFrenteBytes;
  String? _rgFrenteFileName;
  String? _rgVersoPath;
  Uint8List? _rgVersoBytes;
  String? _rgVersoFileName;
  String? _cpfDocPath;
  Uint8List? _cpfDocBytes;
  String? _cpfDocFileName;
  String? _foto3x4Path;
  Uint8List? _foto3x4Bytes;
  String? _foto3x4FileName;
  String? _historicoEscolarFundamentalPath;
  Uint8List? _historicoEscolarFundamentalBytes;
  String? _historicoEscolarFundamentalFileName;
  String? _historicoEscolarMedioPath;
  Uint8List? _historicoEscolarMedioBytes;
  String? _historicoEscolarMedioFileName;
  String? _comprovanteResidenciaPath;
  Uint8List? _comprovanteResidenciaBytes;
  String? _comprovanteResidenciaFileName;
  String? _certidaoNascimentoCasamentoPath;
  Uint8List? _certidaoNascimentoCasamentoBytes;
  String? _certidaoNascimentoCasamentoFileName;
  String? _reservistaPath;
  Uint8List? _reservistaBytes;
  String? _reservistaFileName;
  String? _tituloEleitorPath;
  Uint8List? _tituloEleitorBytes;
  String? _tituloEleitorFileName;
  String? _carteiraVacinacaoPath;
  Uint8List? _carteiraVacinacaoBytes;
  String? _carteiraVacinacaoFileName;
  String? _atestadoEliminacaoDisciplinaPath;
  Uint8List? _atestadoEliminacaoDisciplinaBytes;
  String? _atestadoEliminacaoDisciplinaFileName;
  String? _declaracaoTransferenciaEscolaridadePath;
  Uint8List? _declaracaoTransferenciaEscolaridadeBytes;
  String? _declaracaoTransferenciaEscolaridadeFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'RG Frente: ${_rgFrenteFileName != null ? _rgFrenteFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('rgFrente'),
          child: const Text('Selecionar RG Frente'),
        ),
        const SizedBox(height: 16),
        Text(
          'RG Verso: ${_rgVersoFileName != null ? _rgVersoFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('rgVerso'),
          child: const Text('Selecionar RG Verso'),
        ),
        const SizedBox(height: 16),
        Text(
          'CPF: ${_cpfDocFileName != null ? _cpfDocFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('cpfDoc'),
          child: const Text('Selecionar CPF'),
        ),
        const SizedBox(height: 16),
        Text(
          'Foto 3x4: ${_foto3x4FileName != null ? _foto3x4FileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('foto3x4'),
          child: const Text('Selecionar Foto 3x4'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Fundamental: ${_historicoEscolarFundamentalFileName != null ? _historicoEscolarFundamentalFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarFundamental'),
          child: const Text('Selecionar Histórico Escolar Ensino Fundamental'),
        ),
        const SizedBox(height: 16),
        Text(
          'Histórico Escolar Ensino Médio: ${_historicoEscolarMedioFileName != null ? _historicoEscolarMedioFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('historicoEscolarMedio'),
          child: const Text('Selecionar Histórico Escolar Ensino Médio'),
        ),
        const SizedBox(height: 16),
        Text(
          'Comprovante de residência: ${_comprovanteResidenciaFileName != null ? _comprovanteResidenciaFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('comprovanteResidencia'),
          child: const Text('Selecionar Comprovante de residência'),
        ),
        const SizedBox(height: 16),
        Text(
          'Certidão de nascimento ou de casamento: ${_certidaoNascimentoCasamentoFileName != null ? _certidaoNascimentoCasamentoFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('certidaoNascimentoCasamento'),
          child: const Text(
            'Selecionar Certidão de nascimento ou de casamento',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Reservista (se masculino): ${_reservistaFileName != null ? _reservistaFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('reservista'),
          child: const Text('Selecionar Reservista (se masculino)'),
        ),
        const SizedBox(height: 16),
        Text(
          'Título de eleitor: ${_tituloEleitorFileName != null ? _tituloEleitorFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('tituloEleitor'),
          child: const Text('Selecionar Título de eleitor'),
        ),
        const SizedBox(height: 16),
        Text(
          'Carteira de vacinação: ${_carteiraVacinacaoFileName != null ? _carteiraVacinacaoFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('carteiraVacinacao'),
          child: const Text('Selecionar Carteira de vacinação'),
        ),
        const SizedBox(height: 16),
        Text(
          'Atestado de eliminação de disciplina: ${_atestadoEliminacaoDisciplinaFileName != null ? _atestadoEliminacaoDisciplinaFileName! : 'Nenhum arquivo selecionado'}',
        ),
        ElevatedButton(
          onPressed: () => _pickFile('atestadoEliminacaoDisciplina'),
          child: const Text('Selecionar Atestado de eliminação de disciplina'),
        ),
        const SizedBox(height: 16),
        Text(
          'Declaração de Transferência ou de escolaridade: ${_declaracaoTransferenciaEscolaridadeFileName != null ? _declaracaoTransferenciaEscolaridadeFileName! : 'Nenhum arquivo selecionado'}',
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
      final PlatformFile pickedFile = result.files.first;
      String fileName = pickedFile.name;
      Uint8List? bytes = pickedFile.bytes;
      String? filePath;

      // Prioriza o uso de bytes para ambientes web e fallback para path em outros
      if (bytes != null) {
        filePath = fileName; // Em web, o "path" é o nome do arquivo
      } else {
        filePath = pickedFile.path;
      }

      setState(() {
        switch (documentType) {
          case 'rgFrente':
            _rgFrentePath = filePath;
            _rgFrenteBytes = bytes;
            _rgFrenteFileName = fileName;
            break;
          case 'rgVerso':
            _rgVersoPath = filePath;
            _rgVersoBytes = bytes;
            _rgVersoFileName = fileName;
            break;
          case 'cpfDoc':
            _cpfDocPath = filePath;
            _cpfDocBytes = bytes;
            _cpfDocFileName = fileName;
            break;
          case 'foto3x4':
            _foto3x4Path = filePath;
            _foto3x4Bytes = bytes;
            _foto3x4FileName = fileName;
            break;
          case 'historicoEscolarFundamental':
            _historicoEscolarFundamentalPath = filePath;
            _historicoEscolarFundamentalBytes = bytes;
            _historicoEscolarFundamentalFileName = fileName;
            break;
          case 'historicoEscolarMedio':
            _historicoEscolarMedioPath = filePath;
            _historicoEscolarMedioBytes = bytes;
            _historicoEscolarMedioFileName = fileName;
            break;
          case 'comprovanteResidencia':
            _comprovanteResidenciaPath = filePath;
            _comprovanteResidenciaBytes = bytes;
            _comprovanteResidenciaFileName = fileName;
            break;
          case 'certidaoNascimentoCasamento':
            _certidaoNascimentoCasamentoPath = filePath;
            _certidaoNascimentoCasamentoBytes = bytes;
            _certidaoNascimentoCasamentoFileName = fileName;
            break;
          case 'reservista':
            _reservistaPath = filePath;
            _reservistaBytes = bytes;
            _reservistaFileName = fileName;
            break;
          case 'tituloEleitor':
            _tituloEleitorPath = filePath;
            _tituloEleitorBytes = bytes;
            _tituloEleitorFileName = fileName;
            break;
          case 'carteiraVacinacao':
            _carteiraVacinacaoPath = filePath;
            _carteiraVacinacaoBytes = bytes;
            _carteiraVacinacaoFileName = fileName;
            break;
          case 'atestadoEliminacaoDisciplina':
            _atestadoEliminacaoDisciplinaPath = filePath;
            _atestadoEliminacaoDisciplinaBytes = bytes;
            _atestadoEliminacaoDisciplinaFileName = fileName;
            break;
          case 'declaracaoTransferenciaEscolaridade':
            _declaracaoTransferenciaEscolaridadePath = filePath;
            _declaracaoTransferenciaEscolaridadeBytes = bytes;
            _declaracaoTransferenciaEscolaridadeFileName = fileName;
            break;
        }
      });
      final provider = context.read<EnrollmentProvider>();
      switch (documentType) {
        case 'rgFrente':
          provider.updateRgFrente(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'rgVerso':
          provider.updateRgVerso(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'cpfDoc':
          provider.updateCpfDoc(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'foto3x4':
          provider.updateFoto3x4(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'historicoEscolarFundamental':
          provider.updateHistoricoEscolarFundamental(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'historicoEscolarMedio':
          provider.updateHistoricoEscolarMedio(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'comprovanteResidencia':
          provider.updateComprovanteResidencia(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'certidaoNascimentoCasamento':
          provider.updateCertidaoNascimentoCasamento(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'reservista':
          provider.updateReservista(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'tituloEleitor':
          provider.updateTituloEleitor(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'carteiraVacinacao':
          provider.updateCarteiraVacinacao(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'atestadoEliminacaoDisciplina':
          provider.updateAtestadoEliminacaoDisciplina(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
        case 'declaracaoTransferenciaEscolaridade':
          provider.updateDeclaracaoTransferenciaEscolaridade(
            path: filePath,
            bytes: bytes,
            fileName: fileName,
          );
          break;
      }
    }
  }
}
