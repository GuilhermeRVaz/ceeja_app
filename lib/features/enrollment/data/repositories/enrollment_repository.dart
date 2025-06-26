import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';

class EnrollmentRepository {
  final SupabaseClient _client;
  EnrollmentRepository(this._client);

  // Função para limpar nomes de arquivos
  String _sanitizeFileName(String fileName) {
    String sanitized = fileName.replaceAll(RegExp(r'[áàâãä]'), 'a');
    sanitized = sanitized.replaceAll(RegExp(r'[éèêë]'), 'e');
    sanitized = sanitized.replaceAll(RegExp(r'[íìîï]'), 'i');
    sanitized = sanitized.replaceAll(RegExp(r'[óòôõö]'), 'o');
    sanitized = sanitized.replaceAll(RegExp(r'[úùûü]'), 'u');
    sanitized = sanitized.replaceAll(RegExp(r'[ç]'), 'c');
    sanitized = sanitized.replaceAll(' ', '_');
    sanitized = sanitized.replaceAll(RegExp(r'[^a-zA-Z0-9.\-_]'), '');
    return sanitized.toLowerCase();
  }

  Future<String> uploadDocument({
    required String enrollmentId,
    required String documentType,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    // APLICA A LIMPEZA AQUI
    final sanitizedName = _sanitizeFileName(fileName);
    final filePath = '$enrollmentId/$documentType/$sanitizedName';

    await _client.storage
        .from('documents')
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

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

  // === NOVO MÉTODO: Inicia uma nova matrícula e retorna seu ID ===
  Future<String> startNewEnrollment(String userId) async {
    final response =
        await _client
            .from('enrollments')
            .insert({'user_id': userId})
            .select('id') // Pede para o Supabase retornar o ID da linha criada
            .single(); // Espera um único resultado

    return response['id'];
  }

  // === NOVO MÉTODO: Atualiza uma matrícula existente com todos os dados confirmados ===
  Future<void> updateEnrollment({
    required String enrollmentId,
    required PersonalDataModel personalData,
    required AddressModel addressData,
    required SchoolingModel schoolingData,
  }) async {
    await _client
        .from('enrollments')
        .update({
          'confirmed_personal_data': personalData.toJson(),
          'confirmed_address_data': addressData.toJson(),
          'confirmed_schooling_data': schoolingData.toJson(),
          'status': 'concluida', // Atualiza o status da matrícula
        })
        .eq('id', enrollmentId);
  }

  // === MÉTODO MODIFICADO: createExtractionEntry agora usa enrollment_id ===
  Future<void> createExtractionEntry({
    required String enrollmentId, // MUDANÇA: Recebe enrollmentId
    required String documentType,
    required String fileName,
    required String storagePath,
  }) async {
    await _client.from('document_extractions').insert({
      'enrollment_id': enrollmentId, // MUDANÇA: Salva o ID da matrícula
      'document_type': documentType,
      'file_name': fileName,
      'storage_path': storagePath,
      'status': 'pendente',
    });
  }
}
