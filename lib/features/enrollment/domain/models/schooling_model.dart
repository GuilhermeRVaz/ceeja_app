class SchoolingModel {
  final String? userId;
  final String? nivelEnsino;
  final String? itinerarioFormativo;
  final String? ultimaSerieConcluida;
  final String? ra;
  final String? tipoEscola;
  final String? nomeEscola;
  final bool? estudouNoCeeja;
  final bool? temProgressaoParcial;
  final Map<String, List<String>>? progressaoParcialDisciplinas;
  final bool? eliminouDisciplina;
  final String? eliminouDisciplinaNivel;
  final List<String>? eliminouDisciplinas;
  final bool? optouEnsinoReligioso;
  final bool? optouEducacaoFisica;
  final bool? aceitouTermos;
  final DateTime? dataAceite;

  const SchoolingModel({
    this.userId,
    this.nivelEnsino,
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
    String? userId,
    String? nivelEnsino,
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
      userId: userId ?? this.userId,
      nivelEnsino: nivelEnsino ?? this.nivelEnsino,
      itinerarioFormativo: itinerarioFormativo ?? this.itinerarioFormativo,
      ultimaSerieConcluida: ultimaSerieConcluida ?? this.ultimaSerieConcluida,
      ra: ra ?? this.ra,
      tipoEscola: tipoEscola ?? this.tipoEscola,
      nomeEscola: nomeEscola ?? this.nomeEscola,
      estudouNoCeeja: estudouNoCeeja ?? this.estudouNoCeeja,
      temProgressaoParcial: temProgressaoParcial ?? this.temProgressaoParcial,
      progressaoParcialDisciplinas: progressaoParcialDisciplinas ?? this.progressaoParcialDisciplinas,
      eliminouDisciplina: eliminouDisciplina ?? this.eliminouDisciplina,
      eliminouDisciplinaNivel: eliminouDisciplinaNivel ?? this.eliminouDisciplinaNivel,
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
    return SchoolingModel(
      userId: json['user_id'],
      nivelEnsino: json['nivel_ensino'],
      itinerarioFormativo: json['itinerario_formativo'],
      ultimaSerieConcluida: json['ultima_serie_concluida'],
      ra: json['ra'],
      tipoEscola: json['tipo_escola'],
      nomeEscola: json['nome_escola'],
      estudouNoCeeja: json['estudou_no_ceeja'],
      temProgressaoParcial: json['tem_progressao_parcial'],
      progressaoParcialDisciplinas: (json['progressao_parcial_disciplinas'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as List).map((e) => e.toString()).toList()),
      ),
      eliminouDisciplina: json['eliminou_disciplina'],
      eliminouDisciplinaNivel: json['eliminou_disciplina_nivel'],
      eliminouDisciplinas: (json['eliminou_disciplinas'] as List?)?.map((e) => e.toString()).toList(),
      optouEnsinoReligioso: json['optou_ensino_religioso'],
      optouEducacaoFisica: json['optou_educacao_fisica'],
      aceitouTermos: json['aceitou_termos'],
      dataAceite: json['data_aceite'] != null ? DateTime.parse(json['data_aceite']) : null,
    );
  }

  // Método utilitário para merge dos dados extraídos pela IA
  SchoolingModel mergeFromExtractedData(Map<String, dynamic> extracted) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return false;
    }
    // Mapear corretamente ultima_serie_concluida para o dropdown
    String? ultimaSerieConcluida = extracted['ultima_serie_concluida'];
    String? nivelEnsino = extracted['nivel_ensino'];
    // Mapeamento para dropdowns do app
    final seriesFundamental = [
      '4ª Série Ensino Fundamental',
      '5ª Série Ensino Fundamental',
      '6ª Série Ensino Fundamental',
      '7ª Série Ensino Fundamental',
      '8ª Série Ensino Fundamental',
    ];
    final seriesMedio = [
      '1ª Série do Ensino Médio',
      '2ª Série do Ensino Médio',
      '3ª Série do Ensino Médio',
    ];
    // Tenta mapear texto livre para o valor do dropdown
    String? mapSerie(String? valor) {
      if (valor == null) return null;
      final v = valor.toLowerCase();
      for (final s in seriesFundamental + seriesMedio) {
        if (v.contains(s.toLowerCase().replaceAll('ª', '').replaceAll('º', ''))) {
          return s;
        }
        // Tenta mapear "3 série" para "3ª Série do Ensino Médio"
        if (s.toLowerCase().contains('ensino médio') && v.contains('3') && v.contains('médio')) return '3ª Série do Ensino Médio';
        if (s.toLowerCase().contains('ensino médio') && v.contains('2') && v.contains('médio')) return '2ª Série do Ensino Médio';
        if (s.toLowerCase().contains('ensino médio') && v.contains('1') && v.contains('médio')) return '1ª Série do Ensino Médio';
      }
      return valor;
    }
    String? serieDropdown = mapSerie(ultimaSerieConcluida);
    // Concatenar nome da escola, cidade e estado
    String? nomeEscola = extracted['nome_escola'];
    String? cidadeEscola = extracted['cidade_escola'] ?? extracted['nome_cidade'];
    String? ufEscola = extracted['uf_escola'] ?? extracted['uf_cidade'];
    if (nomeEscola != null && (cidadeEscola != null || ufEscola != null)) {
      nomeEscola = nomeEscola +
        (cidadeEscola != null ? ', ' + cidadeEscola : '') +
        (ufEscola != null ? ' - ' + ufEscola : '');
    }
    // Garantir tipoEscola e nivelEnsino
    String? tipoEscola = extracted['tipo_escola'];
    if (tipoEscola != null) {
      if (tipoEscola.toLowerCase().contains('pública')) tipoEscola = 'Pública';
      if (tipoEscola.toLowerCase().contains('privada')) tipoEscola = 'Privada';
    }
    if (serieDropdown != null && seriesMedio.contains(serieDropdown)) {
      nivelEnsino = 'Ensino Médio';
    } else if (serieDropdown != null && seriesFundamental.contains(serieDropdown)) {
      nivelEnsino = 'Ensino Fundamental';
    }
    return copyWith(
      userId: extracted['user_id'],
      nivelEnsino: nivelEnsino,
      itinerarioFormativo: extracted['itinerario_formativo'],
      ultimaSerieConcluida: serieDropdown,
      ra: extracted['ra'],
      tipoEscola: tipoEscola,
      nomeEscola: nomeEscola,
      estudouNoCeeja: parseBool(extracted['estudou_no_ceeja']),
      temProgressaoParcial: parseBool(extracted['tem_progressao_parcial']),
      progressaoParcialDisciplinas: extracted['progressao_parcial_disciplinas'] != null ? Map<String, List<String>>.from(extracted['progressao_parcial_disciplinas']) : null,
      eliminouDisciplina: parseBool(extracted['eliminou_disciplina']),
      eliminouDisciplinaNivel: extracted['eliminou_disciplina_nivel'],
      eliminouDisciplinas: (extracted['eliminou_disciplinas'] as List?)?.map((e) => e.toString()).toList(),
      optouEnsinoReligioso: parseBool(extracted['optou_ensino_religioso']),
      optouEducacaoFisica: parseBool(extracted['optou_educacao_fisica']),
      aceitouTermos: parseBool(extracted['aceitou_termos']),
      dataAceite: parseDate(extracted['data_aceite']),
    );
  }
}
