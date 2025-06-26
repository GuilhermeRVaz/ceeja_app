import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';

class EnrollmentRepository {
  final SupabaseClient _client;
  EnrollmentRepository(this._client);

  // === MÉTODO DE UPLOAD DE DOCUMENTOS (O que estava faltando) ===
  Future<String> uploadDocument({
    required String userId,
    required String documentType,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    // Cria um caminho único para o arquivo, ex: 'uuid-do-usuario/rg_frente/rg_frente.pdf'
    final filePath = '$userId/$documentType/$fileName';

    // Faz o upload do arquivo binário para o bucket 'documents'
    await _client.storage
        .from(
          'documents',
        ) // Certifique-se que o nome do seu bucket é 'documents'
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ), // 'upsert: true' permite substituir o arquivo se já existir
        );

    // Retorna o caminho do arquivo no storage para referência futura
    return filePath;
  }

  // === MÉTODOS DE SALVAMENTO DE DADOS (Corrigidos para usar .upsert()) ===

  Future<void> savePersonalData(PersonalDataModel data, String userId) async {
    // Prepara os dados, garantindo que o user_id está presente.
    final dataToSave = data.toJson()..['user_id'] = userId;
    // Usa 'upsert' para criar ou atualizar a linha baseada na coluna 'user_id'.
    await _client
        .from('personal_data')
        .upsert(dataToSave, onConflict: 'user_id');
  }

  Future<void> saveAddressData(AddressModel data, String userId) async {
    final dataToSave = data.toJson()..['user_id'] = userId;
    await _client.from('addresses').upsert(dataToSave, onConflict: 'user_id');
  }

  Future<void> saveSchoolingData(SchoolingModel data, String userId) async {
    final dataToSave = data.toJson()..['user_id'] = userId;

    // IMPORTANTE: Remove o campo 'ano_conclusao' se ele não existir na sua tabela.
    // Se você já adicionou a coluna no Supabase, pode remover a linha abaixo.
    dataToSave.remove('ano_conclusao');

    await _client
        .from('schooling_data')
        .upsert(dataToSave, onConflict: 'user_id');
  }

  // Você pode adicionar métodos para inserir na tabela 'document_extractions' aqui
  Future<void> createExtractionEntry({
    required String userId,
    required String documentType,
    required String fileName,
    required String storagePath,
  }) async {
    await _client.from('document_extractions').insert({
      'user_id': userId,
      'document_type': documentType,
      'file_name': fileName,
      'storage_path': storagePath,
      'status': 'pendente', // Define o status inicial
    });
  }
}
