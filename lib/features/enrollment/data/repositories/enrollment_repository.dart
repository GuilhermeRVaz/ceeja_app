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
    String userId,
  ) async {
    try {
      // Sanitize the file name to remove problematic characters
      final sanitizedFileName = _sanitizeFileName(fileName);
      final String path = '$userId/$sanitizedFileName';
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

  String _sanitizeFileName(String fileName) {
    // Remove special characters and replace spaces with underscores
    // Keeps only alphanumeric characters, dots, and hyphens
    return fileName.replaceAll(RegExp(r'[^\w\s\.-]'), '').replaceAll(' ', '_');
  }

  Future<void> addEnrollment({
    required PersonalDataModel personalData,
    required AddressModel addressData,
    required SchoolingModel schoolingData,
    required DocumentsModel documentsData,
    required String userId, // Adicionado userId
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
          userId, // Passa o userId
        );
      }

      String? rgVersoUrl;
      if (documentsData.rgVersoBytes != null &&
          documentsData.rgVersoFileName != null) {
        rgVersoUrl = await _uploadFile(
          documentsData.rgVersoBytes!,
          documentsData.rgVersoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? cpfDocUrl;
      if (documentsData.cpfDocBytes != null &&
          documentsData.cpfDocFileName != null) {
        cpfDocUrl = await _uploadFile(
          documentsData.cpfDocBytes!,
          documentsData.cpfDocFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? foto3x4Url;
      if (documentsData.foto3x4Bytes != null &&
          documentsData.foto3x4FileName != null) {
        foto3x4Url = await _uploadFile(
          documentsData.foto3x4Bytes!,
          documentsData.foto3x4FileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? historicoEscolarFundamentalUrl;
      if (documentsData.historicoEscolarFundamentalBytes != null &&
          documentsData.historicoEscolarFundamentalFileName != null) {
        historicoEscolarFundamentalUrl = await _uploadFile(
          documentsData.historicoEscolarFundamentalBytes!,
          documentsData.historicoEscolarFundamentalFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? historicoEscolarMedioUrl;
      if (documentsData.historicoEscolarMedioBytes != null &&
          documentsData.historicoEscolarMedioFileName != null) {
        historicoEscolarMedioUrl = await _uploadFile(
          documentsData.historicoEscolarMedioBytes!,
          documentsData.historicoEscolarMedioFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? comprovanteResidenciaUrl;
      if (documentsData.comprovanteResidenciaBytes != null &&
          documentsData.comprovanteResidenciaFileName != null) {
        comprovanteResidenciaUrl = await _uploadFile(
          documentsData.comprovanteResidenciaBytes!,
          documentsData.comprovanteResidenciaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? certidaoNascimentoCasamentoUrl;
      if (documentsData.certidaoNascimentoCasamentoBytes != null &&
          documentsData.certidaoNascimentoCasamentoFileName != null) {
        certidaoNascimentoCasamentoUrl = await _uploadFile(
          documentsData.certidaoNascimentoCasamentoBytes!,
          documentsData.certidaoNascimentoCasamentoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? reservistaUrl;
      if (documentsData.reservistaBytes != null &&
          documentsData.reservistaFileName != null) {
        reservistaUrl = await _uploadFile(
          documentsData.reservistaBytes!,
          documentsData.reservistaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? tituloEleitorUrl;
      if (documentsData.tituloEleitorBytes != null &&
          documentsData.tituloEleitorFileName != null) {
        tituloEleitorUrl = await _uploadFile(
          documentsData.tituloEleitorBytes!,
          documentsData.tituloEleitorFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? carteiraVacinacaoUrl;
      if (documentsData.carteiraVacinacaoBytes != null &&
          documentsData.carteiraVacinacaoFileName != null) {
        carteiraVacinacaoUrl = await _uploadFile(
          documentsData.carteiraVacinacaoBytes!,
          documentsData.carteiraVacinacaoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? atestadoEliminacaoDisciplinaUrl;
      if (documentsData.atestadoEliminacaoDisciplinaBytes != null &&
          documentsData.atestadoEliminacaoDisciplinaFileName != null) {
        atestadoEliminacaoDisciplinaUrl = await _uploadFile(
          documentsData.atestadoEliminacaoDisciplinaBytes!,
          documentsData.atestadoEliminacaoDisciplinaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? declaracaoTransferenciaEscolaridadeUrl;
      if (documentsData.declaracaoTransferenciaEscolaridadeBytes != null &&
          documentsData.declaracaoTransferenciaEscolaridadeFileName != null) {
        declaracaoTransferenciaEscolaridadeUrl = await _uploadFile(
          documentsData.declaracaoTransferenciaEscolaridadeBytes!,
          documentsData.declaracaoTransferenciaEscolaridadeFileName!,
          'documents',
          userId, // Passa o userId
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
        'user_id': userId, // Usa o userId passado como parâmetro
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
      print('User ID atual: $userId'); // Loga o userId passado
      rethrow;
    }
  }

  Future<void> savePersonalData(
    PersonalDataModel personalData,
    String userId, // Adicionado userId
  ) async {
    try {
      // Garante que o userId no modelo corresponde ao userId para o qual estamos salvando
      final dataToSave = personalData.copyWith(userId: userId).toJson();
      await _supabaseClient.from('personal_data').upsert(dataToSave);
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

  Future<void> saveAddressData(
    AddressModel addressData,
    String userId, // Adicionado userId
  ) async {
    try {
      // Garante que o userId no modelo corresponde ao userId para o qual estamos salvando
      final dataToSave = addressData.copyWith(userId: userId).toJson();
      await _supabaseClient.from('addresses').upsert(dataToSave);
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
              .from('addresses')
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

  Future<void> saveSchoolingData(
    SchoolingModel schoolingData,
    String userId, // Adicionado userId
  ) async {
    try {
      // Garante que o userId no modelo corresponde ao userId para o qual estamos salvando
      final dataToSave = schoolingData.copyWith(userId: userId).toJson();
      await _supabaseClient.from('schooling_data').upsert(dataToSave);
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

  Future<void> saveDocumentsData(
    DocumentsModel documentsData,
    String userId, // Adicionado userId
  ) async {
    try {
      // Upload de documentos e atualização dos caminhos
      String? rgFrenteUrl;
      if (documentsData.rgFrenteBytes != null &&
          documentsData.rgFrenteFileName != null) {
        rgFrenteUrl = await _uploadFile(
          documentsData.rgFrenteBytes!,
          documentsData.rgFrenteFileName!,
          'documents', // Nome do bucket no Supabase Storage
          userId, // Passa o userId
        );
      }

      String? rgVersoUrl;
      if (documentsData.rgVersoBytes != null &&
          documentsData.rgVersoFileName != null) {
        rgVersoUrl = await _uploadFile(
          documentsData.rgVersoBytes!,
          documentsData.rgVersoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? cpfDocUrl;
      if (documentsData.cpfDocBytes != null &&
          documentsData.cpfDocFileName != null) {
        cpfDocUrl = await _uploadFile(
          documentsData.cpfDocBytes!,
          documentsData.cpfDocFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? foto3x4Url;
      if (documentsData.foto3x4Bytes != null &&
          documentsData.foto3x4FileName != null) {
        foto3x4Url = await _uploadFile(
          documentsData.foto3x4Bytes!,
          documentsData.foto3x4FileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? historicoEscolarFundamentalUrl;
      if (documentsData.historicoEscolarFundamentalBytes != null &&
          documentsData.historicoEscolarFundamentalFileName != null) {
        historicoEscolarFundamentalUrl = await _uploadFile(
          documentsData.historicoEscolarFundamentalBytes!,
          documentsData.historicoEscolarFundamentalFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? historicoEscolarMedioUrl;
      if (documentsData.historicoEscolarMedioBytes != null &&
          documentsData.historicoEscolarMedioFileName != null) {
        historicoEscolarMedioUrl = await _uploadFile(
          documentsData.historicoEscolarMedioBytes!,
          documentsData.historicoEscolarMedioFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? comprovanteResidenciaUrl;
      if (documentsData.comprovanteResidenciaBytes != null &&
          documentsData.comprovanteResidenciaFileName != null) {
        comprovanteResidenciaUrl = await _uploadFile(
          documentsData.comprovanteResidenciaBytes!,
          documentsData.comprovanteResidenciaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? certidaoNascimentoCasamentoUrl;
      if (documentsData.certidaoNascimentoCasamentoBytes != null &&
          documentsData.certidaoNascimentoCasamentoFileName != null) {
        certidaoNascimentoCasamentoUrl = await _uploadFile(
          documentsData.certidaoNascimentoCasamentoBytes!,
          documentsData.certidaoNascimentoCasamentoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? reservistaUrl;
      if (documentsData.reservistaBytes != null &&
          documentsData.reservistaFileName != null) {
        reservistaUrl = await _uploadFile(
          documentsData.reservistaBytes!,
          documentsData.reservistaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? tituloEleitorUrl;
      if (documentsData.tituloEleitorBytes != null &&
          documentsData.tituloEleitorFileName != null) {
        tituloEleitorUrl = await _uploadFile(
          documentsData.tituloEleitorBytes!,
          documentsData.tituloEleitorFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? carteiraVacinacaoUrl;
      if (documentsData.carteiraVacinacaoBytes != null &&
          documentsData.carteiraVacinacaoFileName != null) {
        carteiraVacinacaoUrl = await _uploadFile(
          documentsData.carteiraVacinacaoBytes!,
          documentsData.carteiraVacinacaoFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? atestadoEliminacaoDisciplinaUrl;
      if (documentsData.atestadoEliminacaoDisciplinaBytes != null &&
          documentsData.atestadoEliminacaoDisciplinaFileName != null) {
        atestadoEliminacaoDisciplinaUrl = await _uploadFile(
          documentsData.atestadoEliminacaoDisciplinaBytes!,
          documentsData.atestadoEliminacaoDisciplinaFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      String? declaracaoTransferenciaEscolaridadeUrl;
      if (documentsData.declaracaoTransferenciaEscolaridadeBytes != null &&
          documentsData.declaracaoTransferenciaEscolaridadeFileName != null) {
        declaracaoTransferenciaEscolaridadeUrl = await _uploadFile(
          documentsData.declaracaoTransferenciaEscolaridadeBytes!,
          documentsData.declaracaoTransferenciaEscolaridadeFileName!,
          'documents',
          userId, // Passa o userId
        );
      }

      await _supabaseClient
          .from('documents')
          .upsert(
            documentsData
                .copyWith(
                  userId: userId, // Garante que o userId no modelo corresponde
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
          );
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao salvar dados de documentos:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao salvar dados de documentos: $e');
      }
      rethrow;
    }
  }

  Future<DocumentsModel?> getDocumentsData(String userId) async {
    try {
      final response =
          await _supabaseClient
              .from('documents')
              .select()
              .eq('user_id', userId)
              .maybeSingle();

      if (response != null) {
        return DocumentsModel.fromJson(response);
      }
      return null;
    } catch (e) {
      if (e is PostgrestException) {
        print('Erro Postgrest ao buscar dados de documentos:');
        print('  Mensagem: ${e.message}');
        print('  Código: ${e.code}');
        print('  Detalhes: ${e.details}');
        print('  Hint: ${e.hint}');
      } else {
        print('Erro desconhecido ao buscar dados de documentos: $e');
      }
      return null;
    }
  }
}
