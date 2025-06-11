import 'dart:typed_data';

import 'package:ceeja_app/features/enrollment/data/repositories/enrollment_repository.dart';
import 'package:ceeja_app/features/enrollment/data/services/cep_service.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnrollmentProvider with ChangeNotifier {
  final EnrollmentRepository _repository = EnrollmentRepository(
    Supabase.instance.client,
  );
  final CepService _cepService = CepService();

  PersonalDataModel _personalData = PersonalDataModel();
  PersonalDataModel get personalData => _personalData;

  AddressModel _addressData = AddressModel();
  AddressModel get addressData => _addressData;

  SchoolingModel _schoolingData = SchoolingModel();
  SchoolingModel get schoolingData => _schoolingData;

  DocumentsModel _documentsData = DocumentsModel();
  DocumentsModel get documentsData => _documentsData;

  void updatePersonalData(PersonalDataModel data) {
    _personalData = data;
    notifyListeners();
  }

  Future<void> savePersonalData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      _personalData = _personalData.copyWith(userId: userId);
      await _repository.savePersonalData(_personalData);
      // TODO: Adicionar feedback de sucesso para o usuário
    } catch (e) {
      // TODO: Adicionar feedback de erro para o usuário
      print('Erro no provider ao salvar dados pessoais: $e');
      rethrow;
    }
  }

  Future<void> loadPersonalData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      final data = await _repository.getPersonalData(userId);
      if (data != null) {
        _personalData = data;
        notifyListeners();
      }
    } catch (e) {
      print('Erro no provider ao carregar dados pessoais: $e');
      // Não rethrow aqui, pois pode ser que o usuário ainda não tenha dados
    }
  }

  void updateAddressData(AddressModel data) {
    _addressData = data;
    notifyListeners();
  }

  Future<void> saveAddressData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      _addressData = _addressData.copyWith(userId: userId);
      await _repository.saveAddressData(_addressData);
      // TODO: Adicionar feedback de sucesso para o usuário
    } catch (e) {
      // TODO: Adicionar feedback de erro para o usuário
      print('Erro no provider ao salvar dados de endereço: $e');
      rethrow;
    }
  }

  Future<void> loadAddressData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      final data = await _repository.getAddressData(userId);
      if (data != null) {
        _addressData = data;
        notifyListeners();
      }
    } catch (e) {
      print('Erro no provider ao carregar dados de endereço: $e');
      // Não rethrow aqui, pois pode ser que o usuário ainda não tenha dados
    }
  }

  Future<void> fetchAddressByCep(String cep) async {
    final fetchedAddress = await _cepService.fetchAddressByCep(cep);
    if (fetchedAddress != null) {
      _addressData = _addressData.copyWith(
        cep: fetchedAddress.cep,
        logradouro: fetchedAddress.logradouro,
        bairro: fetchedAddress.bairro,
        nomeCidade: fetchedAddress.nomeCidade,
        ufCidade: fetchedAddress.ufCidade,
      );
      notifyListeners();
    }
    // TODO: Adicionar feedback para o usuário caso o CEP não seja encontrado
  }

  void updateSchoolingData(SchoolingModel data) {
    _schoolingData = data;
    notifyListeners();
  }

  Future<void> saveSchoolingData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      _schoolingData = _schoolingData.copyWith(userId: userId);
      await _repository.saveSchoolingData(_schoolingData);
      // TODO: Adicionar feedback de sucesso para o usuário
    } catch (e) {
      // TODO: Adicionar feedback de erro para o usuário
      print('Erro no provider ao salvar dados acadêmicos: $e');
      rethrow;
    }
  }

  Future<void> loadSchoolingData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }
      final data = await _repository.getSchoolingData(userId);
      if (data != null) {
        _schoolingData = data;
        notifyListeners();
      }
    } catch (e) {
      print('Erro no provider ao carregar dados acadêmicos: $e');
      // Não rethrow aqui, pois pode ser que o usuário ainda não tenha dados
    }
  }

  void updateDocumentsData(DocumentsModel data) {
    _documentsData = data;
    notifyListeners();
  }

  void updateRgFrente({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      rgFrentePath: path,
      rgFrenteBytes: bytes,
      rgFrenteFileName: fileName,
    );
    notifyListeners();
  }

  void updateRgVerso({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      rgVersoPath: path,
      rgVersoBytes: bytes,
      rgVersoFileName: fileName,
    );
    notifyListeners();
  }

  void updateCpfDoc({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      cpfDocPath: path,
      cpfDocBytes: bytes,
      cpfDocFileName: fileName,
    );
    notifyListeners();
  }

  void updateFoto3x4({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      foto3x4Path: path,
      foto3x4Bytes: bytes,
      foto3x4FileName: fileName,
    );
    notifyListeners();
  }

  void updateHistoricoEscolarFundamental({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      historicoEscolarFundamentalPath: path,
      historicoEscolarFundamentalBytes: bytes,
      historicoEscolarFundamentalFileName: fileName,
    );
    notifyListeners();
  }

  void updateHistoricoEscolarMedio({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      historicoEscolarMedioPath: path,
      historicoEscolarMedioBytes: bytes,
      historicoEscolarMedioFileName: fileName,
    );
    notifyListeners();
  }

  void updateComprovanteResidencia({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      comprovanteResidenciaPath: path,
      comprovanteResidenciaBytes: bytes,
      comprovanteResidenciaFileName: fileName,
    );
    notifyListeners();
  }

  void updateCertidaoNascimentoCasamento({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      certidaoNascimentoCasamentoPath: path,
      certidaoNascimentoCasamentoBytes: bytes,
      certidaoNascimentoCasamentoFileName: fileName,
    );
    notifyListeners();
  }

  void updateReservista({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      reservistaPath: path,
      reservistaBytes: bytes,
      reservistaFileName: fileName,
    );
    notifyListeners();
  }

  void updateTituloEleitor({String? path, Uint8List? bytes, String? fileName}) {
    _documentsData = _documentsData.copyWith(
      tituloEleitorPath: path,
      tituloEleitorBytes: bytes,
      tituloEleitorFileName: fileName,
    );
    notifyListeners();
  }

  void updateCarteiraVacinacao({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      carteiraVacinacaoPath: path,
      carteiraVacinacaoBytes: bytes,
      carteiraVacinacaoFileName: fileName,
    );
    notifyListeners();
  }

  void updateAtestadoEliminacaoDisciplina({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      atestadoEliminacaoDisciplinaPath: path,
      atestadoEliminacaoDisciplinaBytes: bytes,
      atestadoEliminacaoDisciplinaFileName: fileName,
    );
    notifyListeners();
  }

  void updateDeclaracaoTransferenciaEscolaridade({
    String? path,
    Uint8List? bytes,
    String? fileName,
  }) {
    _documentsData = _documentsData.copyWith(
      declaracaoTransferenciaEscolaridadePath: path,
      declaracaoTransferenciaEscolaridadeBytes: bytes,
      declaracaoTransferenciaEscolaridadeFileName: fileName,
    );
    notifyListeners();
  }

  Future<void> submitEnrollment() async {
    try {
      await _repository.addEnrollment(
        personalData: _personalData,
        addressData: _addressData,
        schoolingData: _schoolingData,
        documentsData: _documentsData,
      );
      // TODO: Adicionar feedback de sucesso para o usuário
    } catch (e) {
      // TODO: Adicionar feedback de erro para o usuário
      print('Erro no provider ao enviar: $e');
    }
  }
}
