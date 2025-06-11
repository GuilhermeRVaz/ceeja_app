class SchoolingModel {
  String? userId;
  // Nível de Ensino
  String? nivelEnsino;
  String? itinerarioFormativo;
  String? ultimaSerieConcluida;

  // Histórico CEEJA
  bool? estudouNoCeeja;

  // Dependências
  bool? temProgressaoParcial;
  Map<String, List<String>>? progressaoParcialDisciplinas;

  // Eliminações
  bool? eliminouDisciplina;
  String? eliminouDisciplinaNivel;
  List<String>? eliminouDisciplinas; // Alterado para Lista

  // Opcionais
  bool? optouEnsinoReligioso;
  bool? optouEducacaoFisica;

  // Termos
  bool? aceitouTermos;
  DateTime? dataAceite;

  SchoolingModel({
    this.userId,
    this.nivelEnsino,
    this.itinerarioFormativo,
    this.ultimaSerieConcluida,
    this.estudouNoCeeja,
    this.temProgressaoParcial,
    this.progressaoParcialDisciplinas,
    this.eliminouDisciplina,
    this.eliminouDisciplinaNivel,
    this.eliminouDisciplinas,
    this.optouEnsinoReligioso,
    this.optouEducacaoFisica,
    this.aceitouTermos,
    this.dataAceite,
  });

  SchoolingModel copyWith({
    String? userId,
    String? nivelEnsino,
    String? itinerarioFormativo,
    String? ultimaSerieConcluida,
    bool? estudouNoCeeja,
    bool? temProgressaoParcial,
    Map<String, List<String>>? progressaoParcialDisciplinas,
    bool? eliminouDisciplina,
    String? eliminouDisciplinaNivel,
    List<String>? eliminouDisciplinas, // Alterado para Lista
    bool? optouEnsinoReligioso,
    bool? optouEducacaoFisica,
    bool? aceitouTermos,
    DateTime? dataAceite,
  }) {
    return SchoolingModel(
      userId: userId ?? this.userId,
      nivelEnsino: nivelEnsino ?? this.nivelEnsino,
      itinerarioFormativo: itinerarioFormativo ?? this.itinerarioFormativo,
      ultimaSerieConcluida: ultimaSerieConcluida ?? this.ultimaSerieConcluida,
      estudouNoCeeja: estudouNoCeeja ?? this.estudouNoCeeja,
      temProgressaoParcial: temProgressaoParcial ?? this.temProgressaoParcial,
      progressaoParcialDisciplinas:
          progressaoParcialDisciplinas ?? this.progressaoParcialDisciplinas,
      eliminouDisciplina: eliminouDisciplina ?? this.eliminouDisciplina,
      eliminouDisciplinaNivel:
          eliminouDisciplinaNivel ?? this.eliminouDisciplinaNivel,
      eliminouDisciplinas: eliminouDisciplinas ?? this.eliminouDisciplinas,
      optouEnsinoReligioso: optouEnsinoReligioso ?? this.optouEnsinoReligioso,
      optouEducacaoFisica: optouEducacaoFisica ?? this.optouEducacaoFisica,
      aceitouTermos: aceitouTermos ?? this.aceitouTermos,
      dataAceite: dataAceite ?? this.dataAceite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nivelEnsino': nivelEnsino,
      'itinerarioFormativo': itinerarioFormativo,
      'ultimaSerieConcluida': ultimaSerieConcluida,
      'estudouNoCeeja': estudouNoCeeja,
      'temProgressaoParcial': temProgressaoParcial,
      'progressaoParcialDisciplinas': progressaoParcialDisciplinas,
      'eliminouDisciplina': eliminouDisciplina,
      'eliminouDisciplinaNivel': eliminouDisciplinaNivel,
      'eliminouDisciplinas': eliminouDisciplinas,
      'optouEnsinoReligioso': optouEnsinoReligioso,
      'optouEducacaoFisica': optouEducacaoFisica,
      'aceitouTermos': aceitouTermos,
      'dataAceite': dataAceite?.toIso8601String(),
    };
  }

  factory SchoolingModel.fromJson(Map<String, dynamic> json) {
    return SchoolingModel(
      userId: json['userId'],
      nivelEnsino: json['nivelEnsino'],
      itinerarioFormativo: json['itinerarioFormativo'],
      ultimaSerieConcluida: json['ultimaSerieConcluida'],
      estudouNoCeeja: json['estudouNoCeeja'],
      temProgressaoParcial: json['temProgressaoParcial'],
      progressaoParcialDisciplinas:
          (json['progressaoParcialDisciplinas'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          ),
      eliminouDisciplina: json['eliminouDisciplina'],
      eliminouDisciplinaNivel: json['eliminouDisciplinaNivel'],
      eliminouDisciplinas:
          (json['eliminouDisciplinas'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      optouEnsinoReligioso: json['optouEnsinoReligioso'],
      optouEducacaoFisica: json['optouEducacaoFisica'],
      aceitouTermos: json['aceitouTermos'],
      dataAceite:
          json['dataAceite'] != null
              ? DateTime.parse(json['dataAceite'])
              : null,
    );
  }
}
