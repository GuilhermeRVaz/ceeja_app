import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  final String? enrollmentId; // Novo campo
  final String? requerMatriculaEm; // Novo campo para a refatoração
  const EnrollmentState({
    this.personalData = const PersonalDataModel(),
    this.addressData = const AddressModel(),
    this.schoolingData = const SchoolingModel(),
    this.documentsData = const DocumentsModel(),
    this.isLoading = false,
    this.errorMessage,
    this.enrollmentId, // Novo campo
    this.requerMatriculaEm, // Inicializar o novo campo
  });
  EnrollmentState copyWith({
    PersonalDataModel? personalData,
    AddressModel? addressData,
    SchoolingModel? schoolingData,
    DocumentsModel? documentsData,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? enrollmentId, // Novo campo
    String? requerMatriculaEm, // Novo campo para a refatoração
  }) {
    return EnrollmentState(
      personalData: personalData ?? this.personalData,
      addressData: addressData ?? this.addressData,
      schoolingData: schoolingData ?? this.schoolingData,
      documentsData: documentsData ?? this.documentsData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      enrollmentId: enrollmentId ?? this.enrollmentId, // Novo campo
      requerMatriculaEm:
          requerMatriculaEm ??
          this.requerMatriculaEm, // Novo campo para a refatoração
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
  void updateHistoricoFundamentalVerso({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          historicoEscolarFundamentalVersoBytes: bytes,
          historicoEscolarFundamentalVersoFileName: fileName,
        ),
      );
  void updateHistoricoMedioVerso({Uint8List? bytes, String? fileName}) =>
      state = state.copyWith(
        documentsData: state.documentsData.copyWith(
          historicoEscolarMedioVersoBytes: bytes,
          historicoEscolarMedioVersoFileName: fileName,
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

  // === NOVO MÉTODO: Deve ser chamado ao entrar na tela do stepper ===
  Future<void> startNewEnrollment() async {
    // Evita criar uma nova matrícula se já houver uma em andamento
    if (state.enrollmentId != null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userId = _ref.read(authProvider).user?.id;
      if (userId == null) throw Exception("Usuário não logado");

      final newEnrollmentId = await _repository.startNewEnrollment(userId);

      state = state.copyWith(enrollmentId: newEnrollmentId, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // === MÉTODO MODIFICADO: uploadAndExtractData agora usa o enrollmentId do estado ===
  Future<void> uploadAndExtractData() async {
    // Pega o ID da matrícula que já deve ter sido criado
    final enrollmentId = state.enrollmentId;
    if (enrollmentId == null) {
      state = state.copyWith(
        errorMessage: "A matrícula não foi iniciada. Volte e tente novamente.",
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    final documents = state.documentsData;

    try {
      // 1. Criamos uma lista vazia para guardar todas as "promessas" de upload.
      final List<Future> uploadTasks = [];

      // 2. Criamos uma função helper para adicionar tarefas à lista.
      // Isso evita repetição de código e torna tudo mais limpo.
      void addUploadTask(String docType, Uint8List? bytes, String? name) {
        if (bytes != null && name != null) {
          print("Adicionando tarefa de upload para: $name");
          // Adicionamos a PROMESSA (Future) à lista. O código ainda não foi executado.
          uploadTasks.add(
            _repository
                .uploadDocument(
                  enrollmentId: enrollmentId,
                  documentType: docType,
                  fileBytes: bytes,
                  fileName: name,
                )
                .then((storagePath) {
                  // Após CADA upload bem-sucedido, criamos a entrada no banco de dados.
                  // print("Sucesso no upload de $name. Criando entrada na DB...");
                  return _repository.createExtractionEntry(
                    enrollmentId: enrollmentId,
                    documentType: docType,
                    fileName: name,
                    storagePath: storagePath,
                  );
                }),
          );
        }
      }

      // 3. Populamos a lista com TODAS as tarefas de upload.
      addUploadTask(
        'rg_frente',
        documents.rgFrenteBytes,
        documents.rgFrenteFileName,
      );
      addUploadTask(
        'rg_verso',
        documents.rgVersoBytes,
        documents.rgVersoFileName,
      );
      addUploadTask('cpf_doc', documents.cpfDocBytes, documents.cpfDocFileName);
      addUploadTask(
        'foto_3x4',
        documents.foto3x4Bytes,
        documents.foto3x4FileName,
      );
      addUploadTask(
        'historico_fundamental',
        documents.historicoEscolarFundamentalBytes,
        documents.historicoEscolarFundamentalFileName,
      );
      addUploadTask(
        'historico_fundamental_verso',
        documents.historicoEscolarFundamentalVersoBytes,
        documents.historicoEscolarFundamentalVersoFileName,
      );
      addUploadTask(
        'historico_medio',
        documents.historicoEscolarMedioBytes,
        documents.historicoEscolarMedioFileName,
      );
      addUploadTask(
        'historico_medio_verso',
        documents.historicoEscolarMedioVersoBytes,
        documents.historicoEscolarMedioVersoFileName,
      );
      addUploadTask(
        'comprovante_residencia',
        documents.comprovanteResidenciaBytes,
        documents.comprovanteResidenciaFileName,
      );
      addUploadTask(
        'certidao_nascimento_casamento',
        documents.certidaoNascimentoCasamentoBytes,
        documents.certidaoNascimentoCasamentoFileName,
      );
      addUploadTask(
        'reservista',
        documents.reservistaBytes,
        documents.reservistaFileName,
      );
      addUploadTask(
        'titulo_eleitor',
        documents.tituloEleitorBytes,
        documents.tituloEleitorFileName,
      );
      addUploadTask(
        'carteira_vacinacao',
        documents.carteiraVacinacaoBytes,
        documents.carteiraVacinacaoFileName,
      );
      addUploadTask(
        'atestado_eliminacao_disciplina',
        documents.atestadoEliminacaoDisciplinaBytes,
        documents.atestadoEliminacaoDisciplinaFileName,
      );
      addUploadTask(
        'declaracao_transferencia_escolaridade',
        documents.declaracaoTransferenciaEscolaridadeBytes,
        documents.declaracaoTransferenciaEscolaridadeFileName,
      );

      // 4. Se houver tarefas na lista, executamos todas em paralelo!
      if (uploadTasks.isNotEmpty) {
        print("Iniciando ${uploadTasks.length} uploads em paralelo...");
        // Future.wait só completa quando TODAS as promessas na lista terminarem com sucesso.
        // Se UMA falhar, ele lança uma exceção imediatamente.
        await Future.wait(uploadTasks);
        print(
          "Todos os ${uploadTasks.length} documentos foram processados com sucesso.",
        );
      } else {
        print("Nenhum documento foi selecionado para upload.");
        // Se não houver documentos, talvez não queira chamar a IA.
        state = state.copyWith(isLoading: false);
        return; // Sai da função mais cedo.
      }

      // ======================================================================
      // == O LOCAL PERFEITO É AQUI!                                         ==
      // ======================================================================
      // Após garantir que todos os uploads terminaram com sucesso.
      print("Chamando a API Python local para iniciar a extração...");

      final response = await http.post(
        Uri.parse(
          'http://127.0.0.1:5000/extract-data',
        ), // URL do seu servidor Python local
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enrollmentId': state.enrollmentId}),
      );

      // Opcional, mas recomendado: verificar se a chamada para a API foi bem-sucedida.
      if (response.statusCode != 200) {
        // Se a API Python retornar um erro, nós o capturamos aqui.
        throw Exception(
          'Falha ao acionar o serviço de extração de IA. Status: ${response.statusCode}',
        );
      }

      print("API Python acionada com sucesso: ${response.body}");

      // ======================================================================

      state = state.copyWith(isLoading: false);
    } catch (e) {
      print("Ocorreu um erro durante o upload ou chamada da API: $e");
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  // === MÉTODO CORRIGIDO: submitEnrollment agora aciona o backend para finalizar a matrícula ===
  Future<void> submitEnrollment() async {
    final enrollmentId = state.enrollmentId;
    if (enrollmentId == null) {
      state = state.copyWith(
        errorMessage: "Matrícula não iniciada. Não é possível enviar.",
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // O endereço do seu backend Python
      final url = Uri.parse('http://127.0.0.1:5000/finalize-enrollment');

      print('--- CHAMANDO ROTA DE FINALIZAÇÃO NO BACKEND ---');
      print('URL: $url');
      print('Enviando enrollmentId: $enrollmentId');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'enrollmentId': enrollmentId,
          'personalData': state.personalData.toJson(),
          'addressData': state.addressData.toJson(),
          'schoolingData': state.schoolingData.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        print('--- SUCESSO: Matrícula finalizada e enviada ao backend! ---');
        print('Resposta do Backend: ${response.body}');
        // Limpa o estado para uma próxima matrícula
        state = const EnrollmentState();
      } else {
        print('--- ERRO ao finalizar matrícula ---');
        print('Status Code: ${response.statusCode}');
        print('Resposta do Backend: ${response.body}');
        // Tenta decodificar o erro do backend para dar uma mensagem mais clara
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['error'] ?? 'Erro desconhecido do servidor.';
        throw Exception('Falha ao finalizar matrícula. Motivo: $errorMessage');
      }
    } catch (e) {
      print('--- EXCEÇÃO no submitEnrollment: $e ---');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow; // Propaga o erro para a UI poder reagir (ex: mostrar um SnackBar)
    }
  }

  // === NOVO MÉTODO: Buscar dados extraídos e popular o formulário ===
  Future<void> fetchAndFillExtractedData() async {
    final enrollmentId = state.enrollmentId;
    if (enrollmentId == null) {
      state = state.copyWith(errorMessage: "Matrícula não iniciada.");
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.fetchExtractedDataByEnrollmentId(
        enrollmentId,
      );
      print('DEBUG: JSON recebido do Supabase:');
      print(data);
      if (data == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Dados extraídos não encontrados.",
        );
        return;
      }
      // Mapeia os dados extraídos para os models
      final personalData =
          data['extracted_personal_data'] != null
              ? PersonalDataModel.fromJson(
                Map<String, dynamic>.from(data['extracted_personal_data']),
              ).copyWith(
                nacionalidade: data['extracted_personal_data']['nacionalidade'],
                paisOrigem: data['extracted_personal_data']['pais_origem'],
                nascimentoUf: data['extracted_personal_data']['nascimento_uf'],
                nascimentoCidade:
                    data['extracted_personal_data']['nascimento_cidade'],
              )
              : const PersonalDataModel();
      var addressData =
          data['extracted_address_data'] != null
              ? AddressModel.fromJson(
                Map<String, dynamic>.from(data['extracted_address_data']),
              )
              : const AddressModel();

      // SUA LÓGICA ENTRA AQUI!
      // Se a IA retornou um CEP, mas não a cidade, nós assumimos o controle.
      if (addressData.cep != null &&
          addressData.cep!.isNotEmpty &&
          (addressData.nomeCidade == null ||
              addressData.nomeCidade!.isEmpty ||
              addressData.ufCidade == null ||
              addressData.ufCidade!.isEmpty)) {
        print(
          "IA retornou CEP, mas não a cidade/UF. Buscando via CepService...",
        );
        try {
          final addressFromCep = await _cepService.fetchAddressByCep(
            addressData.cep!,
          );
          if (addressFromCep != null) {
            // Atualiza o objeto com os dados do serviço de CEP
            addressData = addressData.copyWith(
              logradouro: addressFromCep.logradouro,
              bairro: addressFromCep.bairro,
              nomeCidade: addressFromCep.nomeCidade,
              ufCidade: addressFromCep.ufCidade,
            );
          }
        } catch (e) {
          print("Erro ao buscar endereço pelo CEP da IA: $e");
        }
      }
      final schoolingData =
          data['extracted_schooling_data'] != null
              ? SchoolingModel.fromJson(
                Map<String, dynamic>.from(data['extracted_schooling_data']),
              )
              : const SchoolingModel();

      print('DEBUG: SchoolingData após fromJson:');
      print('  nivelEnsino: ${schoolingData.nivelEnsino}');
      print('  ultimaSerieConcluida: ${schoolingData.ultimaSerieConcluida}');
      print(
        '  requerMatriculaEm: ${schoolingData.requerMatriculaEm}',
      ); // Novo log

      state = state.copyWith(
        personalData: personalData,
        addressData: addressData,
        schoolingData: schoolingData,
        requerMatriculaEm:
            schoolingData.requerMatriculaEm, // Popular o novo campo
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final enrollmentProvider =
    StateNotifierProvider<EnrollmentNotifier, EnrollmentState>((ref) {
      final repository = EnrollmentRepository(Supabase.instance.client);
      final cepService = CepService();
      return EnrollmentNotifier(repository, cepService, ref);
    });
