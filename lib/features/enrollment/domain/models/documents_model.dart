class DocumentsModel {
  String? cpf;
  String? numDocumentoCivil;
  String? digitoDocumentoCivil;
  String? ufDocumentoCivil;
  String? dataEmissaoDocumentoCivil;
  String? numeroNis;

  DocumentsModel({
    this.cpf,
    this.numDocumentoCivil,
    this.digitoDocumentoCivil,
    this.ufDocumentoCivil,
    this.dataEmissaoDocumentoCivil,
    this.numeroNis,
  });

  DocumentsModel copyWith({
    String? cpf,
    String? numDocumentoCivil,
    String? digitoDocumentoCivil,
    String? ufDocumentoCivil,
    String? dataEmissaoDocumentoCivil,
    String? numeroNis,
  }) {
    return DocumentsModel(
      cpf: cpf ?? this.cpf,
      numDocumentoCivil: numDocumentoCivil ?? this.numDocumentoCivil,
      digitoDocumentoCivil: digitoDocumentoCivil ?? this.digitoDocumentoCivil,
      ufDocumentoCivil: ufDocumentoCivil ?? this.ufDocumentoCivil,
      dataEmissaoDocumentoCivil:
          dataEmissaoDocumentoCivil ?? this.dataEmissaoDocumentoCivil,
      numeroNis: numeroNis ?? this.numeroNis,
    );
  }
}
