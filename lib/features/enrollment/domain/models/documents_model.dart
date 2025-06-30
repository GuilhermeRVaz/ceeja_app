import 'dart:typed_data';

class DocumentsModel {
  final String? userId;
  final String? rgFrentePath;
  final Uint8List? rgFrenteBytes;
  final String? rgFrenteFileName;
  final String? rgVersoPath;
  final Uint8List? rgVersoBytes;
  final String? rgVersoFileName;
  final String? cpfDocPath;
  final Uint8List? cpfDocBytes;
  final String? cpfDocFileName;
  final String? foto3x4Path;
  final Uint8List? foto3x4Bytes;
  final String? foto3x4FileName;
  final String? historicoEscolarFundamentalPath;
  final Uint8List? historicoEscolarFundamentalBytes;
  final String? historicoEscolarFundamentalFileName;
  final Uint8List? historicoEscolarFundamentalVersoBytes;
  final String? historicoEscolarFundamentalVersoFileName;

  final String? historicoEscolarMedioPath;
  final Uint8List? historicoEscolarMedioBytes;
  final String? historicoEscolarMedioFileName;
  final Uint8List? historicoEscolarMedioVersoBytes;
  final String? historicoEscolarMedioVersoFileName;
  final String? comprovanteResidenciaPath;
  final Uint8List? comprovanteResidenciaBytes;
  final String? comprovanteResidenciaFileName;
  final String? certidaoNascimentoCasamentoPath;
  final Uint8List? certidaoNascimentoCasamentoBytes;
  final String? certidaoNascimentoCasamentoFileName;
  final String? reservistaPath;
  final Uint8List? reservistaBytes;
  final String? reservistaFileName;
  final String? tituloEleitorPath;
  final Uint8List? tituloEleitorBytes;
  final String? tituloEleitorFileName;
  final String? carteiraVacinacaoPath;
  final Uint8List? carteiraVacinacaoBytes;
  final String? carteiraVacinacaoFileName;
  final String? atestadoEliminacaoDisciplinaPath;
  final Uint8List? atestadoEliminacaoDisciplinaBytes;
  final String? atestadoEliminacaoDisciplinaFileName;
  final String? declaracaoTransferenciaEscolaridadePath;
  final Uint8List? declaracaoTransferenciaEscolaridadeBytes;
  final String? declaracaoTransferenciaEscolaridadeFileName;

  const DocumentsModel({
    this.userId,
    this.rgFrentePath,
    this.rgFrenteBytes,
    this.rgFrenteFileName,
    this.rgVersoPath,
    this.rgVersoBytes,
    this.rgVersoFileName,
    this.cpfDocPath,
    this.cpfDocBytes,
    this.cpfDocFileName,
    this.foto3x4Path,
    this.foto3x4Bytes,
    this.foto3x4FileName,
    this.historicoEscolarFundamentalPath,
    this.historicoEscolarFundamentalBytes,
    this.historicoEscolarFundamentalFileName,
    this.historicoEscolarFundamentalVersoBytes,
    this.historicoEscolarFundamentalVersoFileName,
    this.historicoEscolarMedioPath,
    this.historicoEscolarMedioBytes,
    this.historicoEscolarMedioFileName,
    this.historicoEscolarMedioVersoBytes,
    this.historicoEscolarMedioVersoFileName,
    this.comprovanteResidenciaPath,
    this.comprovanteResidenciaBytes,
    this.comprovanteResidenciaFileName,
    this.certidaoNascimentoCasamentoPath,
    this.certidaoNascimentoCasamentoBytes,
    this.certidaoNascimentoCasamentoFileName,
    this.reservistaPath,
    this.reservistaBytes,
    this.reservistaFileName,
    this.tituloEleitorPath,
    this.tituloEleitorBytes,
    this.tituloEleitorFileName,
    this.carteiraVacinacaoPath,
    this.carteiraVacinacaoBytes,
    this.carteiraVacinacaoFileName,
    this.atestadoEliminacaoDisciplinaPath,
    this.atestadoEliminacaoDisciplinaBytes,
    this.atestadoEliminacaoDisciplinaFileName,
    this.declaracaoTransferenciaEscolaridadePath,
    this.declaracaoTransferenciaEscolaridadeBytes,
    this.declaracaoTransferenciaEscolaridadeFileName,
  });

  DocumentsModel copyWith({
    String? userId,
    String? rgFrentePath,
    Uint8List? rgFrenteBytes,
    String? rgFrenteFileName,
    String? rgVersoPath,
    Uint8List? rgVersoBytes,
    String? rgVersoFileName,
    String? cpfDocPath,
    Uint8List? cpfDocBytes,
    String? cpfDocFileName,
    String? foto3x4Path,
    Uint8List? foto3x4Bytes,
    String? foto3x4FileName,
    String? historicoEscolarFundamentalPath,
    Uint8List? historicoEscolarFundamentalBytes,
    String? historicoEscolarFundamentalFileName,
    Uint8List? historicoEscolarFundamentalVersoBytes,
    String? historicoEscolarFundamentalVersoFileName,
    String? historicoEscolarMedioPath,
    Uint8List? historicoEscolarMedioBytes,
    String? historicoEscolarMedioFileName,
    Uint8List? historicoEscolarMedioVersoBytes,
    String? historicoEscolarMedioVersoFileName,
    String? comprovanteResidenciaPath,
    Uint8List? comprovanteResidenciaBytes,
    String? comprovanteResidenciaFileName,
    String? certidaoNascimentoCasamentoPath,
    Uint8List? certidaoNascimentoCasamentoBytes,
    String? certidaoNascimentoCasamentoFileName,
    String? reservistaPath,
    Uint8List? reservistaBytes,
    String? reservistaFileName,
    String? tituloEleitorPath,
    Uint8List? tituloEleitorBytes,
    String? tituloEleitorFileName,
    String? carteiraVacinacaoPath,
    Uint8List? carteiraVacinacaoBytes,
    String? carteiraVacinacaoFileName,
    String? atestadoEliminacaoDisciplinaPath,
    Uint8List? atestadoEliminacaoDisciplinaBytes,
    String? atestadoEliminacaoDisciplinaFileName,
    String? declaracaoTransferenciaEscolaridadePath,
    Uint8List? declaracaoTransferenciaEscolaridadeBytes,
    String? declaracaoTransferenciaEscolaridadeFileName,
  }) {
    return DocumentsModel(
      userId: userId ?? this.userId,
      rgFrentePath: rgFrentePath ?? this.rgFrentePath,
      rgFrenteBytes: rgFrenteBytes ?? this.rgFrenteBytes,
      rgFrenteFileName: rgFrenteFileName ?? this.rgFrenteFileName,
      rgVersoPath: rgVersoPath ?? this.rgVersoPath,
      rgVersoBytes: rgVersoBytes ?? this.rgVersoBytes,
      rgVersoFileName: rgVersoFileName ?? this.rgVersoFileName,
      cpfDocPath: cpfDocPath ?? this.cpfDocPath,
      cpfDocBytes: cpfDocBytes ?? this.cpfDocBytes,
      cpfDocFileName: cpfDocFileName ?? this.cpfDocFileName,
      foto3x4Path: foto3x4Path ?? this.foto3x4Path,
      foto3x4Bytes: foto3x4Bytes ?? this.foto3x4Bytes,
      foto3x4FileName: foto3x4FileName ?? this.foto3x4FileName,
      historicoEscolarFundamentalPath:
          historicoEscolarFundamentalPath ??
          this.historicoEscolarFundamentalPath,
      historicoEscolarFundamentalBytes:
          historicoEscolarFundamentalBytes ??
          this.historicoEscolarFundamentalBytes,
      historicoEscolarFundamentalFileName:
          historicoEscolarFundamentalFileName ??
          this.historicoEscolarFundamentalFileName,
      historicoEscolarFundamentalVersoBytes:
          historicoEscolarFundamentalVersoBytes ??
          this.historicoEscolarFundamentalVersoBytes,
      historicoEscolarFundamentalVersoFileName:
          historicoEscolarFundamentalVersoFileName ??
          this.historicoEscolarFundamentalVersoFileName,
      historicoEscolarMedioPath:
          historicoEscolarMedioPath ?? this.historicoEscolarMedioPath,
      historicoEscolarMedioBytes:
          historicoEscolarMedioBytes ?? this.historicoEscolarMedioBytes,
      historicoEscolarMedioFileName:
          historicoEscolarMedioFileName ?? this.historicoEscolarMedioFileName,
      historicoEscolarMedioVersoBytes:
          historicoEscolarMedioVersoBytes ??
          this.historicoEscolarMedioVersoBytes,
      historicoEscolarMedioVersoFileName:
          historicoEscolarMedioVersoFileName ??
          this.historicoEscolarMedioVersoFileName,
      comprovanteResidenciaPath:
          comprovanteResidenciaPath ?? this.comprovanteResidenciaPath,
      comprovanteResidenciaBytes:
          comprovanteResidenciaBytes ?? this.comprovanteResidenciaBytes,
      comprovanteResidenciaFileName:
          comprovanteResidenciaFileName ?? this.comprovanteResidenciaFileName,
      certidaoNascimentoCasamentoPath:
          certidaoNascimentoCasamentoPath ??
          this.certidaoNascimentoCasamentoPath,
      certidaoNascimentoCasamentoBytes:
          certidaoNascimentoCasamentoBytes ??
          this.certidaoNascimentoCasamentoBytes,
      certidaoNascimentoCasamentoFileName:
          certidaoNascimentoCasamentoFileName ??
          this.certidaoNascimentoCasamentoFileName,
      reservistaPath: reservistaPath ?? this.reservistaPath,
      reservistaBytes: reservistaBytes ?? this.reservistaBytes,
      reservistaFileName: reservistaFileName ?? this.reservistaFileName,
      tituloEleitorPath: tituloEleitorPath ?? this.tituloEleitorPath,
      tituloEleitorBytes: tituloEleitorBytes ?? this.tituloEleitorBytes,
      tituloEleitorFileName:
          tituloEleitorFileName ?? this.tituloEleitorFileName,
      carteiraVacinacaoPath:
          carteiraVacinacaoPath ?? this.carteiraVacinacaoPath,
      carteiraVacinacaoBytes:
          carteiraVacinacaoBytes ?? this.carteiraVacinacaoBytes,
      carteiraVacinacaoFileName:
          carteiraVacinacaoFileName ?? this.carteiraVacinacaoFileName,
      atestadoEliminacaoDisciplinaPath:
          atestadoEliminacaoDisciplinaPath ??
          this.atestadoEliminacaoDisciplinaPath,
      atestadoEliminacaoDisciplinaBytes:
          atestadoEliminacaoDisciplinaBytes ??
          this.atestadoEliminacaoDisciplinaBytes,
      atestadoEliminacaoDisciplinaFileName:
          atestadoEliminacaoDisciplinaFileName ??
          this.atestadoEliminacaoDisciplinaFileName,
      declaracaoTransferenciaEscolaridadePath:
          declaracaoTransferenciaEscolaridadePath ??
          this.declaracaoTransferenciaEscolaridadePath,
      declaracaoTransferenciaEscolaridadeBytes:
          declaracaoTransferenciaEscolaridadeBytes ??
          this.declaracaoTransferenciaEscolaridadeBytes,
      declaracaoTransferenciaEscolaridadeFileName:
          declaracaoTransferenciaEscolaridadeFileName ??
          this.declaracaoTransferenciaEscolaridadeFileName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'rgFrentePath': rgFrentePath,
      'rgFrenteFileName': rgFrenteFileName,
      'rgVersoPath': rgVersoPath,
      'rgVersoFileName': rgVersoFileName,
      'cpfDocPath': cpfDocPath,
      'cpfDocFileName': cpfDocFileName,
      'foto3x4Path': foto3x4Path,
      'foto3x4FileName': foto3x4FileName,
      'historicoEscolarFundamentalPath': historicoEscolarFundamentalPath,
      'historicoEscolarFundamentalFileName':
          historicoEscolarFundamentalFileName,
      'historicoEscolarFundamentalVersoBytes':
          historicoEscolarFundamentalVersoBytes,
      'historicoEscolarFundamentalVersoFileName':
          historicoEscolarFundamentalVersoFileName,
      'historicoEscolarMedioPath': historicoEscolarMedioPath,
      'historicoEscolarMedioFileName': historicoEscolarMedioFileName,
      'historicoEscolarMedioVersoBytes': historicoEscolarMedioVersoBytes,
      'historicoEscolarMedioVersoFileName': historicoEscolarMedioVersoFileName,
      'comprovanteResidenciaPath': comprovanteResidenciaPath,
      'comprovanteResidenciaFileName': comprovanteResidenciaFileName,
      'certidaoNascimentoCasamentoPath': certidaoNascimentoCasamentoPath,
      'certidaoNascimentoCasamentoFileName':
          certidaoNascimentoCasamentoFileName,
      'reservistaPath': reservistaPath,
      'reservistaFileName': reservistaFileName,
      'tituloEleitorPath': tituloEleitorPath,
      'tituloEleitorFileName': tituloEleitorFileName,
      'carteiraVacinacaoPath': carteiraVacinacaoPath,
      'carteiraVacinacaoFileName': carteiraVacinacaoFileName,
      'atestadoEliminacaoDisciplinaPath': atestadoEliminacaoDisciplinaPath,
      'atestadoEliminacaoDisciplinaFileName':
          atestadoEliminacaoDisciplinaFileName,
      'declaracaoTransferenciaEscolaridadePath':
          declaracaoTransferenciaEscolaridadePath,
      'declaracaoTransferenciaEscolaridadeFileName':
          declaracaoTransferenciaEscolaridadeFileName,
    };
  }

  factory DocumentsModel.fromJson(Map<String, dynamic> json) {
    return DocumentsModel(
      userId: json['user_id'],
      rgFrentePath: json['rgFrentePath'],
      rgFrenteFileName: json['rgFrenteFileName'],
      rgVersoPath: json['rgVersoPath'],
      rgVersoFileName: json['rgVersoFileName'],
      cpfDocPath: json['cpfDocPath'],
      cpfDocFileName: json['cpfDocFileName'],
      foto3x4Path: json['foto3x4Path'],
      foto3x4FileName: json['foto3x4FileName'],
      historicoEscolarFundamentalPath: json['historicoEscolarFundamentalPath'],
      historicoEscolarFundamentalFileName:
          json['historicoEscolarFundamentalFileName'],
      historicoEscolarFundamentalVersoBytes:
          json['historicoEscolarFundamentalVersoBytes'],
      historicoEscolarFundamentalVersoFileName:
          json['historicoEscolarFundamentalVersoFileName'],
      historicoEscolarMedioPath: json['historicoEscolarMedioPath'],
      historicoEscolarMedioFileName: json['historicoEscolarMedioFileName'],
      historicoEscolarMedioVersoBytes: json['historicoEscolarMedioVersoBytes'],
      historicoEscolarMedioVersoFileName:
          json['historicoEscolarMedioVersoFileName'],
      comprovanteResidenciaPath: json['comprovanteResidenciaPath'],
      comprovanteResidenciaFileName: json['comprovanteResidenciaFileName'],
      certidaoNascimentoCasamentoPath: json['certidaoNascimentoCasamentoPath'],
      certidaoNascimentoCasamentoFileName:
          json['certidaoNascimentoCasamentoFileName'],
      reservistaPath: json['reservistaPath'],
      reservistaFileName: json['reservistaFileName'],
      tituloEleitorPath: json['tituloEleitorPath'],
      tituloEleitorFileName: json['tituloEleitorFileName'],
      carteiraVacinacaoPath: json['carteiraVacinacaoPath'],
      carteiraVacinacaoFileName: json['carteiraVacinacaoFileName'],
      atestadoEliminacaoDisciplinaPath:
          json['atestadoEliminacaoDisciplinaPath'],
      atestadoEliminacaoDisciplinaFileName:
          json['atestadoEliminacaoDisciplinaFileName'],
      declaracaoTransferenciaEscolaridadePath:
          json['declaracaoTransferenciaEscolaridadePath'],
      declaracaoTransferenciaEscolaridadeFileName:
          json['declaracaoTransferenciaEscolaridadeFileName'],
    );
  }
}
