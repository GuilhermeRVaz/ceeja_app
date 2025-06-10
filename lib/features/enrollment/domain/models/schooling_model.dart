class SchoolingModel {
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
}
