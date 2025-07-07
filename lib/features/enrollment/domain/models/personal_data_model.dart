class PersonalDataModel {
  // Dados de Identificação
  final String? nomeCompleto;
  final bool temNomeSocial;
  final String? nomeSocial;
  final bool temNomeAfetivo;
  final String? nomeAfetivo;
  final String? sexo;
  final String? rg;
  final String? rgDigito;
  final String? rgUf;
  final DateTime? rgDataEmissao;
  final String? cpf;
  final String? racaCor;
  final DateTime? dataNascimento;
  final int? idade;

  // Filiação
  final String? nomeMae;
  final String? nomePai;

  // Contato e Conectividade
  final bool? possuiInternet;
  final bool? possuiDevice;
  final String? telefone;
  final String? email;

  // Outros
  final bool? isGemeo;
  final String? nomeGemeo;
  final bool? trabalha;
  final String? profissao;
  final String? empresa;
  final bool? isPCD;
  final String? deficiencia;
  final String? userId;

  // Nacionalidade
  final String? nacionalidade; // 'Brasileira' ou 'Estrangeira'
  final String? nascimentoUf;
  final String? nascimentoCidade;
  final String? paisOrigem;

  const PersonalDataModel({
    this.nomeCompleto,
    this.temNomeSocial = false,
    this.nomeSocial,
    this.temNomeAfetivo = false,
    this.nomeAfetivo,
    this.sexo,
    this.rg,
    this.rgDigito,
    this.rgUf,
    this.rgDataEmissao,
    this.cpf,
    this.racaCor,
    this.dataNascimento,
    this.idade,
    this.nomeMae,
    this.nomePai,
    this.possuiInternet,
    this.possuiDevice,
    this.telefone,
    this.email,
    this.isGemeo,
    this.nomeGemeo,
    this.trabalha,
    this.profissao,
    this.empresa,
    this.isPCD,
    this.deficiencia,
    this.userId,
    this.nacionalidade,
    this.nascimentoUf,
    this.nascimentoCidade,
    this.paisOrigem,
  });

  PersonalDataModel copyWith({
    String? nomeCompleto,
    bool? temNomeSocial,
    String? nomeSocial,
    bool? temNomeAfetivo,
    String? nomeAfetivo,
    String? sexo,
    String? rg,
    String? rgDigito,
    String? rgUf,
    DateTime? rgDataEmissao,
    String? cpf,
    String? racaCor,
    DateTime? dataNascimento,
    int? idade,
    String? nomeMae,
    String? nomePai,
    bool? possuiInternet,
    bool? possuiDevice,
    String? telefone,
    String? email,
    bool? isGemeo,
    String? nomeGemeo,
    bool? trabalha,
    String? profissao,
    String? empresa,
    bool? isPCD,
    String? deficiencia,
    String? userId,
    String? nacionalidade,
    String? nascimentoUf,
    String? nascimentoCidade,
    String? paisOrigem,
  }) {
    return PersonalDataModel(
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      temNomeSocial: temNomeSocial ?? this.temNomeSocial,
      nomeSocial: nomeSocial ?? this.nomeSocial,
      temNomeAfetivo: temNomeAfetivo ?? this.temNomeAfetivo,
      nomeAfetivo: nomeAfetivo ?? this.nomeAfetivo,
      sexo: sexo ?? this.sexo,
      rg: rg ?? this.rg,
      rgDigito: rgDigito ?? this.rgDigito,
      rgUf: rgUf ?? this.rgUf,
      rgDataEmissao: rgDataEmissao ?? this.rgDataEmissao,
      cpf: cpf ?? this.cpf,
      racaCor: racaCor ?? this.racaCor,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      idade: idade ?? this.idade,
      nomeMae: nomeMae ?? this.nomeMae,
      nomePai: nomePai ?? this.nomePai,
      possuiInternet: possuiInternet ?? this.possuiInternet,
      possuiDevice: possuiDevice ?? this.possuiDevice,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      isGemeo: isGemeo ?? this.isGemeo,
      nomeGemeo: nomeGemeo ?? this.nomeGemeo,
      trabalha: trabalha ?? this.trabalha,
      profissao: profissao ?? this.profissao,
      empresa: empresa ?? this.empresa,
      isPCD: isPCD ?? this.isPCD,
      deficiencia: deficiencia ?? this.deficiencia,
      userId: userId ?? this.userId,
      nacionalidade: nacionalidade ?? this.nacionalidade,
      nascimentoUf: nascimentoUf ?? this.nascimentoUf,
      nascimentoCidade: nascimentoCidade ?? this.nascimentoCidade,
      paisOrigem: paisOrigem ?? this.paisOrigem,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'tem_nome_social': temNomeSocial,
      'nome_social': nomeSocial,
      'tem_nome_afetivo': temNomeAfetivo,
      'nome_afetivo': nomeAfetivo,
      'sexo': sexo,
      'rg': rg,
      'rg_digito': rgDigito,
      'rg_uf': rgUf,
      'rg_data_emissao': rgDataEmissao?.toIso8601String(),
      'cpf': cpf,
      'raca_cor': racaCor,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'idade': idade,
      'nome_mae': nomeMae,
      'nome_pai': nomePai,
      'possui_internet': possuiInternet,
      'possui_device': possuiDevice,
      'telefone': telefone,
      'email': email,
      'is_gemeo': isGemeo,
      'nome_gemeo': nomeGemeo,
      'trabalha': trabalha,
      'profissao': profissao,
      'empresa': empresa,
      'is_pcd': isPCD,
      'deficiencia': deficiencia,
      'user_id': userId,
      'nacionalidade': nacionalidade,
      'nascimento_uf': nascimentoUf,
      'nascimento_cidade': nascimentoCidade,
      'pais_origem': paisOrigem,
    };
  }

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
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
    return PersonalDataModel(
      nomeCompleto: json['nome_completo'],
      temNomeSocial: parseBool(json['tem_nome_social']),
      nomeSocial: json['nome_social'],
      temNomeAfetivo: parseBool(json['tem_nome_afetivo']),
      nomeAfetivo: json['nome_afetivo'],
      sexo: json['sexo'],
      rg: json['rg'],
      rgDigito: json['rg_digito'],
      rgUf: json['rg_uf'],
      rgDataEmissao: parseDate(json['rg_data_emissao']),
      cpf: json['cpf'],
      racaCor: json['raca_cor'],
      dataNascimento: parseDate(json['data_nascimento']),
      idade: json['idade'],
      nomeMae: json['nome_mae'],
      nomePai: json['nome_pai'],
      possuiInternet: parseBool(json['possui_internet']),
      possuiDevice: parseBool(json['possui_device']),
      telefone: json['telefone'],
      email: json['email'],
      isGemeo: parseBool(json['is_gemeo']),
      nomeGemeo: json['nome_gemeo'],
      trabalha: parseBool(json['trabalha']),
      profissao: json['profissao'],
      empresa: json['empresa'],
      isPCD: parseBool(json['is_pcd']),
      deficiencia: json['deficiencia'],
      userId: json['user_id'],
      nacionalidade: json['nacionalidade'],
      nascimentoUf: json['nascimento_uf'],
      nascimentoCidade: json['nascimento_cidade'],
      paisOrigem: json['pais_origem'],
    );
  }

  // Método utilitário para merge dos dados extraídos pela IA
  PersonalDataModel mergeFromExtractedData(Map<String, dynamic> extracted) {
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
    // RG: separar dígito se vier junto
    String? rg = extracted['rg'];
    String? rgDigito = extracted['rg_digito'];
    if (rg != null && rg.contains('-') && (rgDigito == null || rgDigito.isEmpty)) {
      final parts = rg.split('-');
      rg = parts[0];
      rgDigito = parts.length > 1 ? parts[1] : null;
    }
    // Nacionalidade: deduzir se nascimento_uf e nascimento_cidade presentes
    String? nacionalidade = extracted['nacionalidade'];
    if ((nacionalidade == null || nacionalidade.isEmpty) &&
        extracted['nascimento_uf'] != null &&
        extracted['nascimento_cidade'] != null &&
        (extracted['pais_origem'] == null || extracted['pais_origem'].toString().isEmpty)) {
      nacionalidade = 'Brasileira';
    }
    // Padronizar nacionalidade para o dropdown
    if (nacionalidade != null) {
      if (nacionalidade.toLowerCase() == 'brasileira') nacionalidade = 'Brasileira';
      if (nacionalidade.toLowerCase() == 'estrangeira') nacionalidade = 'Estrangeira';
    }
    return copyWith(
      nomeCompleto: extracted['nome_completo'],
      temNomeSocial: parseBool(extracted['tem_nome_social']),
      nomeSocial: extracted['nome_social'],
      temNomeAfetivo: parseBool(extracted['tem_nome_afetivo']),
      nomeAfetivo: extracted['af_nome_afetivo'],
      sexo: extracted['sexo'],
      rg: rg,
      rgDigito: rgDigito,
      rgUf: extracted['rg_uf'],
      rgDataEmissao: parseDate(extracted['rg_data_emissao']),
      cpf: extracted['cpf'],
      racaCor: extracted['raca_cor'],
      dataNascimento: parseDate(extracted['data_nascimento']),
      idade: extracted['idade'],
      nomeMae: extracted['nome_mae'],
      nomePai: extracted['nome_pai'],
      possuiInternet: parseBool(extracted['possui_internet']),
      possuiDevice: parseBool(extracted['possui_device']),
      telefone: extracted['telefone'],
      email: extracted['email'],
      isGemeo: parseBool(extracted['is_gemeo']),
      nomeGemeo: extracted['nome_gemeo'],
      trabalha: parseBool(extracted['trabalha']),
      profissao: extracted['profissao'],
      empresa: extracted['empresa'],
      isPCD: parseBool(extracted['is_pcd']),
      deficiencia: extracted['deficiencia'],
      nacionalidade: nacionalidade,
      nascimentoUf: extracted['nascimento_uf'],
      nascimentoCidade: extracted['nascimento_cidade'],
      paisOrigem: extracted['pais_origem'],
    );
  }
}
