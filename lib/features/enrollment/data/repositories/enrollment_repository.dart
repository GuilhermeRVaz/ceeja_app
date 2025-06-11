import 'dart:typed_data';

import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnrollmentRepository {
  final SupabaseClient _supabaseClient;

  EnrollmentRepository(this._supabaseClient);

  Future<String?> _uploadFile(
    Uint8List bytes,
    String fileName,
    String bucketName,
  ) async {
    try {
      final String path = '${_supabaseClient.auth.currentUser?.id}/$fileName';
      await _supabaseClient.storage
          .from(bucketName)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
      return path;
    } catch (e) {
      print('Erro ao fazer upload do arquivo: $e');
      return null;
    }
  }

  Future<void> addEnrollment({
    required PersonalDataModel personalData,
    required AddressModel addressData,
    required SchoolingModel schoolingData,
    required DocumentsModel documentsData,
  }) async {
    try {
      // Upload de documentos e atualização dos caminhos
      String? rgFrenteUrl;
      if (documentsData.rgFrenteBytes != null &&
          documentsData.rgFrenteFileName != null) {
        rgFrenteUrl = await _uploadFile(
          documentsData.rgFrenteBytes!,
          documentsData.rgFrenteFileName!,
          'documents', // Nome do bucket no Supabase Storage
        );
      }

      String? rgVersoUrl;
      if (documentsData.rgVersoBytes != null &&
          documentsData.rgVersoFileName != null) {
        rgVersoUrl = await _uploadFile(
          documentsData.rgVersoBytes!,
          documentsData.rgVersoFileName!,
          'documents',
        );
      }

      String? cpfDocUrl;
      if (documentsData.cpfDocBytes != null &&
          documentsData.cpfDocFileName != null) {
        cpfDocUrl = await _uploadFile(
          documentsData.cpfDocBytes!,
          documentsData.cpfDocFileName!,
          'documents',
        );
      }

      String? foto3x4Url;
      if (documentsData.foto3x4Bytes != null &&
          documentsData.foto3x4FileName != null) {
        foto3x4Url = await _uploadFile(
          documentsData.foto3x4Bytes!,
          documentsData.foto3x4FileName!,
          'documents',
        );
      }

      String? historicoEscolarFundamentalUrl;
      if (documentsData.historicoEscolarFundamentalBytes != null &&
          documentsData.historicoEscolarFundamentalFileName != null) {
        historicoEscolarFundamentalUrl = await _uploadFile(
          documentsData.historicoEscolarFundamentalBytes!,
          documentsData.historicoEscolarFundamentalFileName!,
          'documents',
        );
      }

      String? historicoEscolarMedioUrl;
      if (documentsData.historicoEscolarMedioBytes != null &&
          documentsData.historicoEscolarMedioFileName != null) {
        historicoEscolarMedioUrl = await _uploadFile(
          documentsData.historicoEscolarMedioBytes!,
          documentsData.historicoEscolarMedioFileName!,
          'documents',
        );
      }

      String? comprovanteResidenciaUrl;
      if (documentsData.comprovanteResidenciaBytes != null &&
          documentsData.comprovanteResidenciaFileName != null) {
        comprovanteResidenciaUrl = await _uploadFile(
          documentsData.comprovanteResidenciaBytes!,
          documentsData.comprovanteResidenciaFileName!,
          'documents',
        );
      }

      String? certidaoNascimentoCasamentoUrl;
      if (documentsData.certidaoNascimentoCasamentoBytes != null &&
          documentsData.certidaoNascimentoCasamentoFileName != null) {
        certidaoNascimentoCasamentoUrl = await _uploadFile(
          documentsData.certidaoNascimentoCasamentoBytes!,
          documentsData.certidaoNascimentoCasamentoFileName!,
          'documents',
        );
      }

      String? reservistaUrl;
      if (documentsData.reservistaBytes != null &&
          documentsData.reservistaFileName != null) {
        reservistaUrl = await _uploadFile(
          documentsData.reservistaBytes!,
          documentsData.reservistaFileName!,
          'documents',
        );
      }

      String? tituloEleitorUrl;
      if (documentsData.tituloEleitorBytes != null &&
          documentsData.tituloEleitorFileName != null) {
        tituloEleitorUrl = await _uploadFile(
          documentsData.tituloEleitorBytes!,
          documentsData.tituloEleitorFileName!,
          'documents',
        );
      }

      String? carteiraVacinacaoUrl;
      if (documentsData.carteiraVacinacaoBytes != null &&
          documentsData.carteiraVacinacaoFileName != null) {
        carteiraVacinacaoUrl = await _uploadFile(
          documentsData.carteiraVacinacaoBytes!,
          documentsData.carteiraVacinacaoFileName!,
          'documents',
        );
      }

      String? atestadoEliminacaoDisciplinaUrl;
      if (documentsData.atestadoEliminacaoDisciplinaBytes != null &&
          documentsData.atestadoEliminacaoDisciplinaFileName != null) {
        atestadoEliminacaoDisciplinaUrl = await _uploadFile(
          documentsData.atestadoEliminacaoDisciplinaBytes!,
          documentsData.atestadoEliminacaoDisciplinaFileName!,
          'documents',
        );
      }

      String? declaracaoTransferenciaEscolaridadeUrl;
      if (documentsData.declaracaoTransferenciaEscolaridadeBytes != null &&
          documentsData.declaracaoTransferenciaEscolaridadeFileName != null) {
        declaracaoTransferenciaEscolaridadeUrl = await _uploadFile(
          documentsData.declaracaoTransferenciaEscolaridadeBytes!,
          documentsData.declaracaoTransferenciaEscolaridadeFileName!,
          'documents',
        );
      }

      await _supabaseClient.from('enrollment_requests').insert({
        'personal_data': personalData.toJson(),
        'address_data': addressData.toJson(),
        'schooling_data': schoolingData.toJson(),
        'documents_data':
            documentsData
                .copyWith(
                  rgFrentePath: rgFrenteUrl,
                  rgVersoPath: rgVersoUrl,
                  cpfDocPath: cpfDocUrl,
                  foto3x4Path: foto3x4Url,
                  historicoEscolarFundamentalPath:
                      historicoEscolarFundamentalUrl,
                  historicoEscolarMedioPath: historicoEscolarMedioUrl,
                  comprovanteResidenciaPath: comprovanteResidenciaUrl,
                  certidaoNascimentoCasamentoPath:
                      certidaoNascimentoCasamentoUrl,
                  reservistaPath: reservistaUrl,
                  tituloEleitorPath: tituloEleitorUrl,
                  carteiraVacinacaoPath: carteiraVacinacaoUrl,
                  atestadoEliminacaoDisciplinaPath:
                      atestadoEliminacaoDisciplinaUrl,
                  declaracaoTransferenciaEscolaridadePath:
                      declaracaoTransferenciaEscolaridadeUrl,
                )
                .toJson(),
        'user_id': _supabaseClient.auth.currentUser?.id,
      });
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao salvar requerimento:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao salvar requerimento: $e');
      }
      print('User ID atual: ${_supabaseClient.auth.currentUser?.id}');
      rethrow;
    }
  }

  Future<void> savePersonalData(PersonalDataModel personalData) async {
    try {
      await _supabaseClient.from('personal_data').upsert(personalData.toJson());
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao salvar dados pessoais:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao salvar dados pessoais: $e');
      }
      rethrow;
    }
  }

  Future<PersonalDataModel?> getPersonalData(String userId) async {
    try {
      final response =
          await _supabaseClient
              .from('personal_data')
              .select()
              .eq('user_id', userId)
              .maybeSingle(); // Usar maybeSingle para lidar com 0 ou 1 resultado

      if (response != null) {
        return PersonalDataModel.fromJson(response);
      }
      return null;
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao buscar dados pessoais:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao buscar dados pessoais: $e');
      }
      return null;
    }
  }

  Future<void> saveAddressData(AddressModel addressData) async {
    try {
      await _supabaseClient.from('address_data').upsert(addressData.toJson());
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao salvar dados de endereço:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao salvar dados de endereço: $e');
      }
      rethrow;
    }
  }

  Future<AddressModel?> getAddressData(String userId) async {
    try {
      final response =
          await _supabaseClient
              .from('address_data')
              .select()
              .eq('user_id', userId)
              .maybeSingle();

      if (response != null) {
        return AddressModel.fromJson(response);
      }
      return null;
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao buscar dados de endereço:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao buscar dados de endereço: $e');
      }
      return null;
    }
  }

  Future<void> saveSchoolingData(SchoolingModel schoolingData) async {
    try {
      await _supabaseClient
          .from('schooling_data')
          .upsert(schoolingData.toJson());
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao salvar dados acadêmicos:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao salvar dados acadêmicos: $e');
      }
      rethrow;
    }
  }

  Future<SchoolingModel?> getSchoolingData(String userId) async {
    try {
      final response =
          await _supabaseClient
              .from('schooling_data')
              .select()
              .eq('user_id', userId)
              .maybeSingle();

      if (response != null) {
        return SchoolingModel.fromJson(response);
      }
      return null;
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao buscar dados acadêmicos:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao buscar dados acadêmicos: $e');
      }
      return null;
    }
  }
}
