import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/enrollment/data/repositories/enrollment_repository.dart';
import 'package:ceeja_app/features/enrollment/data/services/cep_service.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';

class EnrollmentState {
  final PersonalDataModel personalData;
  final AddressModel addressData;
  final SchoolingModel schoolingData;
  final DocumentsModel documentsData;
  final bool isLoading;
  final String? errorMessage;
  const EnrollmentState({
    this.personalData = const PersonalDataModel(),
    this.addressData = const AddressModel(),
    this.schoolingData = const SchoolingModel(),
    this.documentsData = const DocumentsModel(),
    this.isLoading = false,
    this.errorMessage,
  });
  EnrollmentState copyWith({
    PersonalDataModel? personalData,
    AddressModel? addressData,
    SchoolingModel? schoolingData,
    DocumentsModel? documentsData,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EnrollmentState(
      personalData: personalData ?? this.personalData,
      addressData: addressData ?? this.addressData,
      schoolingData: schoolingData ?? this.schoolingData,
      documentsData: documentsData ?? this.documentsData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class EnrollmentNotifier extends StateNotifier<EnrollmentState> {
  final EnrollmentRepository _repository;
  final CepService _cepService;
  final Ref _ref;
  EnrollmentNotifier(this._repository, this._cepService, this._ref)
    : super(const EnrollmentState());

  void updatePersonalData(PersonalDataModel data) =>
      state = state.copyWith(personalData: data);
  void updateAddressData(AddressModel data) =>
      state = state.copyWith(addressData: data);
  void updateSchoolingData(SchoolingModel data) =>
      state = state.copyWith(schoolingData: data);
  void updateRgFrente({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          rgFrenteBytes: bytes,
          rgFrenteFileName: fileName,
        ),
      );
  void updateRgVerso({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          rgVersoBytes: bytes,
          rgVersoFileName: fileName,
        ),
      );
  void updateCpfDoc({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          cpfDocBytes: bytes,
          cpfDocFileName: fileName,
        ),
      );
  void updateFoto3x4({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          foto3x4Bytes: bytes,
          foto3x4FileName: fileName,
        ),
      );
  void updateHistoricoEscolarFundamental({
    Uint8List? bytes,
    String? fileName,
  }) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          historicoEscolarFundamentalBytes: bytes,
          historicoEscolarFundamentalFileName: fileName,
        ),
      );
  void updateHistoricoEscolarMedio({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          historicoEscolarMedioBytes: bytes,
          historicoEscolarMedioFileName: fileName,
        ),
      );
  void updateComprovanteResidencia({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          comprovanteResidenciaBytes: bytes,
          comprovanteResidenciaFileName: fileName,
        ),
      );
  void updateCertidaoNascimentoCasamento({
    Uint8List? bytes,
    String? fileName,
  }) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          certidaoNascimentoCasamentoBytes: bytes,
          certidaoNascimentoCasamentoFileName: fileName,
        ),
      );
  void updateReservista({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          reservistaBytes: bytes,
          reservistaFileName: fileName,
        ),
      );
  void updateTituloEleitor({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          tituloEleitorBytes: bytes,
          tituloEleitorFileName: fileName,
        ),
      );
  void updateCarteiraVacinacao({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          carteiraVacinacaoBytes: bytes,
          carteiraVacinacaoFileName: fileName,
        ),
      );
  void updateAtestadoEliminacaoDisciplina({
    Uint8List? bytes,
    String? fileName,
  }) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          atestadoEliminacaoDisciplinaBytes: bytes,
          atestadoEliminacaoDisciplinaFileName: fileName,
        ),
      );
  void updateDeclaracaoTransferenciaEscolaridade({
    Uint8List? bytes,
    String? fileName,
  }) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          declaracaoTransferenciaEscolaridadeBytes: bytes,
          declaracaoTransferenciaEscolaridadeFileName: fileName,
        ),
      );

  Future<void> fetchAddressByCep(String cep) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final address = await _cepService.fetchAddressByCep(cep);
      state = state.copyWith(
        addressData: state.addressData.copyWith(
          logradouro: address?.logradouro,
          bairro: address?.bairro,
          nomeCidade: address?.nomeCidade,
          ufCidade: address?.ufCidade,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> uploadAndExtractData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final documents = state.documentsData;
    final userId = _ref.read(authProvider).user?.id;
    if (userId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Usuário não logado",
      );
      return;
    }

    try {
      // Cria uma lista de tarefas de upload
      final List<Future> uploadTasks = [];

      // Função helper para adicionar tarefas à lista
      void addUploadTask(String docType, Uint8List? bytes, String? name) {
        if (bytes != null && name != null) {
          uploadTasks.add(
            _repository
                .uploadDocument(
                  userId: userId,
                  documentType: docType,
                  fileBytes: bytes,
                  fileName: name,
                )
                .then(
                  (storagePath) => _repository.createExtractionEntry(
                    userId: userId,
                    documentType: docType,
                    fileName: name,
                    storagePath: storagePath,
                  ),
                ),
          );
        }
      }

      addUploadTask(
        'rg_frente',
        documents.rgFrenteBytes,
        documents.rgFrenteFileName,
      );
      // ... Adicione chamadas para todos os outros documentos
      // addUploadTask('rg_verso', documents.rgVersoBytes, documents.rgVersoFileName);
      // addUploadTask('cpf_doc', documents.cpfDocBytes, documents.cpfDocFileName);

      // Executa todas as tarefas de upload em paralelo
      await Future.wait(uploadTasks);
      print("Todos os documentos foram enviados com sucesso.");

      // AQUI VOCÊ CHAMARIA A EDGE FUNCTION PARA INICIAR A IA
      // final response = await Supabase.instance.client.functions.invoke('extract-document-data', body: {'userId': userId});

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> submitEnrollment({String? targetUserId}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userId = targetUserId ?? _ref.read(authProvider).user?.id;
      if (userId == null) throw Exception('Usuário não autenticado.');
      // Chama os métodos separados do repositório
      await _repository.savePersonalData(state.personalData, userId);
      await _repository.saveAddressData(state.addressData, userId);
      await _repository.saveSchoolingData(state.schoolingData, userId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }
}

final enrollmentProvider =
    StateNotifierProvider<EnrollmentNotifier, EnrollmentState>((ref) {
      final repository = EnrollmentRepository(Supabase.instance.client);
      final cepService = CepService();
      return EnrollmentNotifier(repository, cepService, ref);
    });
