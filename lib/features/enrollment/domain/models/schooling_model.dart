class SchoolingModel {
  final String? userId;
  // Nível de Ensino
  final String? nivelEnsino;
  final String? itinerarioFormativo;
  final String? ultimaSerieConcluida;
  final String? ra; // Adicionado o campo RA
  final String? tipoEscola;
  final String? nomeEscola;

  // Histórico CEEJA
  final bool? estudouNoCeeja;

  // Dependências
  final bool? temProgressaoParcial;
  final Map<String, List<String>>? progressaoParcialDisciplinas;

  // Eliminações
  final bool? eliminouDisciplina;
  final String? eliminouDisciplinaNivel;
  final List<String>? eliminouDisciplinas; // Alterado para Lista

  // Opcionais
  final bool? optouEnsinoReligioso;
  final bool? optouEducacaoFisica;

  // Termos
  final bool? aceitouTermos;
  final DateTime? dataAceite;

  const SchoolingModel({
    this.userId,
    this.nivelEnsino,
    this.itinerarioFormativo,
    this.ultimaSerieConcluida,
    this.ra, // Adicionado o campo RA
    this.tipoEscola,
    this.nomeEscola,
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
    String? ra, // Adicionado o campo RA
    String? tipoEscola,
    String? nomeEscola,
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
      ra: ra ?? this.ra, // Adicionado o campo RA
      tipoEscola: tipoEscola ?? this.tipoEscola,
      nomeEscola: nomeEscola ?? this.nomeEscola,
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
      'user_id': userId,
      'nivel_ensino': nivelEnsino,
      'itinerario_formativo': itinerarioFormativo,
      'ultima_serie_concluida': ultimaSerieConcluida,
      'ra': ra, // Adicionado o campo RA
      'tipo_escola': tipoEscola,
      'nome_escola': nomeEscola,
      'estudou_no_ceeja': estudouNoCeeja,
      'tem_progressao_parcial': temProgressaoParcial,
      'progressao_parcial_disciplinas': progressaoParcialDisciplinas,
      'eliminou_disciplina': eliminouDisciplina,
      'eliminou_disciplina_nivel': eliminouDisciplinaNivel,
      'eliminou_disciplinas': eliminouDisciplinas,
      'optou_ensino_religioso': optouEnsinoReligioso,
      'optou_educacao_fisica': optouEducacaoFisica,
      'aceitou_termos': aceitouTermos,
      'data_aceite': dataAceite?.toIso8601String(),
    };
  }

  factory SchoolingModel.fromJson(Map<String, dynamic> json) {
    return SchoolingModel(
      userId: json['user_id'],
      nivelEnsino: json['nivel_ensino'],
      itinerarioFormativo: json['itinerario_formativo'],
      ultimaSerieConcluida: json['ultima_serie_concluida'],
      ra: json['ra'], // Adicionado o campo RA
      tipoEscola: json['tipo_escola'],
      nomeEscola: json['nome_escola'],
      estudouNoCeeja: json['estudou_no_ceeja'],
      temProgressaoParcial: json['tem_progressao_parcial'],
      progressaoParcialDisciplinas: (json['progressao_parcial_disciplinas']
              as Map<String, dynamic>?)
          ?.map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          ),
      eliminouDisciplina: json['eliminou_disciplina'],
      eliminouDisciplinaNivel: json['eliminou_disciplina_nivel'],
      eliminouDisciplinas:
          (json['eliminou_disciplinas'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      optouEnsinoReligioso: json['optou_ensino_religioso'],
      optouEducacaoFisica: json['optou_educacao_fisica'],
      aceitouTermos: json['aceitou_termos'],
      dataAceite:
          json['data_aceite'] != null
              ? DateTime.parse(json['data_aceite'])
              : null,
    );
  }
}
