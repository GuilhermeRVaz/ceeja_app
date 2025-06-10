class DocumentsModel {
  String? cpf;
  String? numDocumentoCivil;
  String? digitoDocumentoCivil;
  String? ufDocumentoCivil;
  String? dataEmissaoDocumentoCivil;
  String? numeroNis;
  String? rg;
  String? cpfDoc;
  String? foto3x4;
  String? historicoEscolarFundamental;
  String? historicoEscolarMedio;
  String? comprovanteResidencia;
  String? certidaoNascimentoCasamento;
  String? reservista;
  String? tituloEleitor;
  String? carteiraVacinacao;
  String? atestadoEliminacaoDisciplina;
  String? declaracaoTransferenciaEscolaridade;

  DocumentsModel({
    this.cpf,
    this.numDocumentoCivil,
    this.digitoDocumentoCivil,
    this.ufDocumentoCivil,
    this.dataEmissaoDocumentoCivil,
    this.numeroNis,
    this.rg,
    this.cpfDoc,
    this.foto3x4,
    this.historicoEscolarFundamental,
    this.historicoEscolarMedio,
    this.comprovanteResidencia,
    this.certidaoNascimentoCasamento,
    this.reservista,
    this.tituloEleitor,
    this.carteiraVacinacao,
    this.atestadoEliminacaoDisciplina,
    this.declaracaoTransferenciaEscolaridade,
  });

  DocumentsModel copyWith({
    String? cpf,
    String? numDocumentoCivil,
    String? digitoDocumentoCivil,
    String? ufDocumentoCivil,
    String? dataEmissaoDocumentoCivil,
    String? numeroNis,
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
    return DocumentsModel(
      cpf: cpf ?? this.cpf,
      numDocumentoCivil: numDocumentoCivil ?? this.numDocumentoCivil,
      digitoDocumentoCivil: digitoDocumentoCivil ?? this.digitoDocumentoCivil,
      ufDocumentoCivil: ufDocumentoCivil ?? this.ufDocumentoCivil,
      dataEmissaoDocumentoCivil:
          dataEmissaoDocumentoCivil ?? this.dataEmissaoDocumentoCivil,
      numeroNis: numeroNis ?? this.numeroNis,
      rg: rg ?? this.rg,
      cpfDoc: cpfDoc ?? this.cpfDoc,
      foto3x4: foto3x4 ?? this.foto3x4,
      historicoEscolarFundamental:
          historicoEscolarFundamental ?? this.historicoEscolarFundamental,
      historicoEscolarMedio:
          historicoEscolarMedio ?? this.historicoEscolarMedio,
      comprovanteResidencia:
          comprovanteResidencia ?? this.comprovanteResidencia,
      certidaoNascimentoCasamento:
          certidaoNascimentoCasamento ?? this.certidaoNascimentoCasamento,
      reservista: reservista ?? this.reservista,
      tituloEleitor: tituloEleitor ?? this.tituloEleitor,
      carteiraVacinacao: carteiraVacinacao ?? this.carteiraVacinacao,
      atestadoEliminacaoDisciplina:
          atestadoEliminacaoDisciplina ?? this.atestadoEliminacaoDisciplina,
      declaracaoTransferenciaEscolaridade:
          declaracaoTransferenciaEscolaridade ??
          this.declaracaoTransferenciaEscolaridade,
    );
  }
}
