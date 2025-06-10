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

  void updateAddressData(AddressModel data) {
    _addressData = data;
    notifyListeners();
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

  void updateDocumentsData(
    DocumentsModel data, {
    String? rg,
    String? cpfDoc,
    String? foto3x4,
    String? historicoEscolarFundamental,
    String? historicoEscolarMedio,
    String? comprovanteResidencia,
    String? certidaoNascimentoCasamento,
    String? reservista,
    String? tituloEleitor,
    String? carteiraVacinacao,
    String? atestadoEliminacaoDisciplina,
    String? declaracaoTransferenciaEscolaridade,
  }) {
    _documentsData = data.copyWith(
      rg: rg,
      cpfDoc: cpfDoc,
      foto3x4: foto3x4,
      historicoEscolarFundamental: historicoEscolarFundamental,
      historicoEscolarMedio: historicoEscolarMedio,
      comprovanteResidencia: comprovanteResidencia,
      certidaoNascimentoCasamento: certidaoNascimentoCasamento,
      reservista: reservista,
      tituloEleitor: tituloEleitor,
      carteiraVacinacao: carteiraVacinacao,
      atestadoEliminacaoDisciplina: atestadoEliminacaoDisciplina,
      declaracaoTransferenciaEscolaridade: declaracaoTransferenciaEscolaridade,
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
