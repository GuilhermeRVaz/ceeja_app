class SchoolingModel {
  // Nível de Ensino
  final String? nivelEnsino;
  final String? requerMatriculaEm; // Novo campo
  final String? itinerarioFormativo;
  final String? ultimaSerieConcluida;
  final String? ra;
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
  final List<String>? eliminouDisciplinas;

  // Opcionais
  final bool? optouEnsinoReligioso;
  final bool? optouEducacaoFisica;

  // Termos
  final bool? aceitouTermos;
  final DateTime? dataAceite;

  const SchoolingModel({
    this.nivelEnsino,
    this.requerMatriculaEm, // Novo campo
    this.itinerarioFormativo,
    this.ultimaSerieConcluida,
    this.ra,
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
    String? nivelEnsino,
    String? requerMatriculaEm, // Novo campo
    String? itinerarioFormativo,
    String? ultimaSerieConcluida,
    String? ra,
    String? tipoEscola,
    String? nomeEscola,
    bool? estudouNoCeeja,
    bool? temProgressaoParcial,
    Map<String, List<String>>? progressaoParcialDisciplinas,
    bool? eliminouDisciplina,
    String? eliminouDisciplinaNivel,
    List<String>? eliminouDisciplinas,
    bool? optouEnsinoReligioso,
    bool? optouEducacaoFisica,
    bool? aceitouTermos,
    DateTime? dataAceite,
  }) {
    return SchoolingModel(
      nivelEnsino: nivelEnsino ?? this.nivelEnsino,
      requerMatriculaEm:
          requerMatriculaEm ?? this.requerMatriculaEm, // Novo campo
      itinerarioFormativo: itinerarioFormativo ?? this.itinerarioFormativo,
      ultimaSerieConcluida: ultimaSerieConcluida ?? this.ultimaSerieConcluida,
      ra: ra ?? this.ra,
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
      'nivel_ensino': nivelEnsino,
      'requer_matricula_em': requerMatriculaEm, // Novo campo
      'itinerario_formativo': itinerarioFormativo,
      'ultima_serie_concluida': ultimaSerieConcluida,
      'ra': ra,
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
    String? nivelEnsinoRaw = json['nivel_ensino'];
    String? nivelEnsinoFormatted;
    if (nivelEnsinoRaw != null) {
      if (nivelEnsinoRaw.toLowerCase().contains('fundamental')) {
        nivelEnsinoFormatted = 'Ensino Fundamental';
      } else if (nivelEnsinoRaw.toLowerCase().contains('médio') ||
          nivelEnsinoRaw.toLowerCase().contains('medio')) {
        nivelEnsinoFormatted = 'Ensino Médio';
      } else {
        nivelEnsinoFormatted = nivelEnsinoRaw; // Fallback para outros valores
      }
    }

    return SchoolingModel(
      nivelEnsino: nivelEnsinoFormatted,
      requerMatriculaEm: json['requer_matricula_em'], // Novo campo
      itinerarioFormativo: json['itinerario_formativo'],
      ultimaSerieConcluida: json['ultima_serie_concluida'],
      ra: json['ra'],
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
