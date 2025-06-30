// COPIE E COLE TUDO ABAIXO NO ARQUIVO:
// lib/features/enrollment/presentation/widgets/documents_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';

class DocumentsForm extends ConsumerWidget {
  const DocumentsForm({super.key});

  Future<void> _pickFile(WidgetRef ref, String documentType) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final notifier = ref.read(enrollmentProvider.notifier);
      switch (documentType) {
        case 'rgFrente':
          notifier.updateRgFrente(bytes: file.bytes, fileName: file.name);
          break;
        case 'rgVerso':
          notifier.updateRgVerso(bytes: file.bytes, fileName: file.name);
          break;
        case 'cpfDoc':
          notifier.updateCpfDoc(bytes: file.bytes, fileName: file.name);
          break;
        case 'foto3x4':
          notifier.updateFoto3x4(bytes: file.bytes, fileName: file.name);
          break;
        case 'historicoEscolarFundamental':
          notifier.updateHistoricoEscolarFundamental(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'historicoEscolarFundamentalVerso':
          notifier.updateHistoricoFundamentalVerso(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'historicoEscolarMedio':
          notifier.updateHistoricoEscolarMedio(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'historicoEscolarMedioVerso':
          notifier.updateHistoricoMedioVerso(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'comprovanteResidencia':
          notifier.updateComprovanteResidencia(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'certidaoNascimentoCasamento':
          notifier.updateCertidaoNascimentoCasamento(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'reservista':
          notifier.updateReservista(bytes: file.bytes, fileName: file.name);
          break;
        case 'tituloEleitor':
          notifier.updateTituloEleitor(bytes: file.bytes, fileName: file.name);
          break;
        case 'carteiraVacinacao':
          notifier.updateCarteiraVacinacao(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'atestadoEliminacaoDisciplina':
          notifier.updateAtestadoEliminacaoDisciplina(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
        case 'declaracaoTransferenciaEscolaridade':
          notifier.updateDeclaracaoTransferenciaEscolaridade(
            bytes: file.bytes,
            fileName: file.name,
          );
          break;
      }
    }
  }

  Widget _buildFileInput(
    String label,
    String? fileName,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: Icon(
              fileName != null ? Icons.check_circle : Icons.upload_file,
              color: fileName != null ? Colors.green : Colors.grey.shade700,
            ),
            label: Text(
              fileName ?? 'Selecionar arquivo...',
              style: TextStyle(color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              side: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsState = ref.watch(enrollmentProvider).documentsData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Envio de Documentos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Envie seus documentos para análise. A etapa seguinte será pré-preenchida com os dados extraídos.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildFileInput(
          'RG (Frente)',
          documentsState.rgFrenteFileName,
          () => _pickFile(ref, 'rgFrente'),
        ),
        _buildFileInput(
          'RG (Verso)',
          documentsState.rgVersoFileName,
          () => _pickFile(ref, 'rgVerso'),
        ),
        _buildFileInput(
          'CPF',
          documentsState.cpfDocFileName,
          () => _pickFile(ref, 'cpfDoc'),
        ),
        _buildFileInput(
          'Foto 3x4',
          documentsState.foto3x4FileName,
          () => _pickFile(ref, 'foto3x4'),
        ),
        _buildFileInput(
          'Histórico Escolar (Fundamental - Frente)',
          documentsState.historicoEscolarFundamentalFileName,
          () => _pickFile(ref, 'historicoEscolarFundamental'),
        ),
        _buildFileInput(
          'Histórico Escolar (Fundamental - Verso)',
          documentsState.historicoEscolarFundamentalVersoFileName,
          () => _pickFile(ref, 'historicoEscolarFundamentalVerso'),
        ),
        _buildFileInput(
          'Histórico Escolar (Médio - Frente)',
          documentsState.historicoEscolarMedioFileName,
          () => _pickFile(ref, 'historicoEscolarMedio'),
        ),
        _buildFileInput(
          'Histórico Escolar (Médio - Verso)',
          documentsState.historicoEscolarMedioVersoFileName,
          () => _pickFile(ref, 'historicoEscolarMedioVerso'),
        ),
        _buildFileInput(
          'Comprovante de Residência',
          documentsState.comprovanteResidenciaFileName,
          () => _pickFile(ref, 'comprovanteResidencia'),
        ),
        _buildFileInput(
          'Certidão de Nascimento/Casamento',
          documentsState.certidaoNascimentoCasamentoFileName,
          () => _pickFile(ref, 'certidaoNascimentoCasamento'),
        ),
        _buildFileInput(
          'Certificado de Reservista (para homens)',
          documentsState.reservistaFileName,
          () => _pickFile(ref, 'reservista'),
        ),
        _buildFileInput(
          'Título de Eleitor',
          documentsState.tituloEleitorFileName,
          () => _pickFile(ref, 'tituloEleitor'),
        ),
        _buildFileInput(
          'Carteira de Vacinação',
          documentsState.carteiraVacinacaoFileName,
          () => _pickFile(ref, 'carteiraVacinacao'),
        ),
        _buildFileInput(
          'Atestado de Eliminação de Disciplina',
          documentsState.atestadoEliminacaoDisciplinaFileName,
          () => _pickFile(ref, 'atestadoEliminacaoDisciplina'),
        ),
        _buildFileInput(
          'Declaração de Transferência de Escolaridade',
          documentsState.declaracaoTransferenciaEscolaridadeFileName,
          () => _pickFile(ref, 'declaracaoTransferenciaEscolaridade'),
        ),
      ],
    );
  }
}
