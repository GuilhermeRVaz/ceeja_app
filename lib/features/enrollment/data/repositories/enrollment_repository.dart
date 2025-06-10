import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnrollmentRepository {
  final SupabaseClient _supabaseClient;

  EnrollmentRepository(this._supabaseClient);

  Future<void> addEnrollment({
    required PersonalDataModel personalData,
    required AddressModel addressData,
    required SchoolingModel schoolingData,
    required DocumentsModel documentsData,
  }) async {
    try {
      await _supabaseClient.from('enrollment_requests').insert({
        'personal_data': personalData, // Supabase irá serializar para JSONB
        'address_data': addressData,
        'schooling_data': schoolingData,
        'documents_data': documentsData,
        // Adicionar o user_id se o usuário estiver logado
        'user_id': _supabaseClient.auth.currentUser?.id,
      });
    } catch (e) {
      // TODO: Tratar erro de forma mais robusta
      print('Erro ao salvar requerimento: $e');
      rethrow;
    }
  }
}
