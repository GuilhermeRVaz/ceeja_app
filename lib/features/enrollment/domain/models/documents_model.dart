class DocumentsModel {
  String? rgFrentePath;
  String? rgVersoPath;
  String? cpfDocPath;
  String? foto3x4Path;
  String? historicoEscolarFundamentalPath;
  String? historicoEscolarMedioPath;
  String? comprovanteResidenciaPath;
  String? certidaoNascimentoCasamentoPath;
  String? reservistaPath;
  String? tituloEleitorPath;
  String? carteiraVacinacaoPath;
  String? atestadoEliminacaoDisciplinaPath;
  String? declaracaoTransferenciaEscolaridadePath;

  DocumentsModel({
    this.rgFrentePath,
    this.rgVersoPath,
    this.cpfDocPath,
    this.foto3x4Path,
    this.historicoEscolarFundamentalPath,
    this.historicoEscolarMedioPath,
    this.comprovanteResidenciaPath,
    this.certidaoNascimentoCasamentoPath,
    this.reservistaPath,
    this.tituloEleitorPath,
    this.carteiraVacinacaoPath,
    this.atestadoEliminacaoDisciplinaPath,
    this.declaracaoTransferenciaEscolaridadePath,
  });

  DocumentsModel copyWith({
    String? rgFrentePath,
    String? rgVersoPath,
    String? cpfDocPath,
    String? foto3x4Path,
    String? historicoEscolarFundamentalPath,
    String? historicoEscolarMedioPath,
    String? comprovanteResidenciaPath,
    String? certidaoNascimentoCasamentoPath,
    String? reservistaPath,
    String? tituloEleitorPath,
    String? carteiraVacinacaoPath,
    String? atestadoEliminacaoDisciplinaPath,
    String? declaracaoTransferenciaEscolaridadePath,
  }) {
    return DocumentsModel(
      rgFrentePath: rgFrentePath ?? this.rgFrentePath,
      rgVersoPath: rgVersoPath ?? this.rgVersoPath,
      cpfDocPath: cpfDocPath ?? this.cpfDocPath,
      foto3x4Path: foto3x4Path ?? this.foto3x4Path,
      historicoEscolarFundamentalPath:
          historicoEscolarFundamentalPath ??
          this.historicoEscolarFundamentalPath,
      historicoEscolarMedioPath:
          historicoEscolarMedioPath ?? this.historicoEscolarMedioPath,
      comprovanteResidenciaPath:
          comprovanteResidenciaPath ?? this.comprovanteResidenciaPath,
      certidaoNascimentoCasamentoPath:
          certidaoNascimentoCasamentoPath ??
          this.certidaoNascimentoCasamentoPath,
      reservistaPath: reservistaPath ?? this.reservistaPath,
      tituloEleitorPath: tituloEleitorPath ?? this.tituloEleitorPath,
      carteiraVacinacaoPath:
          carteiraVacinacaoPath ?? this.carteiraVacinacaoPath,
      atestadoEliminacaoDisciplinaPath:
          atestadoEliminacaoDisciplinaPath ??
          this.atestadoEliminacaoDisciplinaPath,
      declaracaoTransferenciaEscolaridadePath:
          declaracaoTransferenciaEscolaridadePath ??
          this.declaracaoTransferenciaEscolaridadePath,
    );
  }
}
