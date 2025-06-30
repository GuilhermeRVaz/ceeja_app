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
  final int? idade; // Adicionado para armazenar a idade

  // Filiação
  final String? nomeMae;
  final String? nomePai;

  // Nacionalidade
  final String? nacionalidade; // 'Brasileira' ou 'Estrangeira'
  final String? nascimentoUf;
  final String? nascimentoCidade;
  final String? paisOrigem;

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
  final String? userId; // Adicionado para associar ao usuário do Supabase

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
    this.idade, // Adicionado ao construtor
    this.nomeMae,
    this.nomePai,
    this.nacionalidade,
    this.nascimentoUf,
    this.nascimentoCidade,
    this.paisOrigem,
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
    this.userId, // Adicionado ao construtor
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
    int? idade, // Adicionado ao copyWith
    String? nomeMae,
    String? nomePai,
    String? nacionalidade,
    String? nascimentoUf,
    String? nascimentoCidade,
    String? paisOrigem,
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
    String? userId, // Adicionado ao copyWith
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
      idade: idade ?? this.idade, // Adicionado ao retorno do copyWith
      nomeMae: nomeMae ?? this.nomeMae,
      nomePai: nomePai ?? this.nomePai,
      nacionalidade: nacionalidade ?? this.nacionalidade,
      nascimentoUf: nascimentoUf ?? this.nascimentoUf,
      nascimentoCidade: nascimentoCidade ?? this.nascimentoCidade,
      paisOrigem: paisOrigem ?? this.paisOrigem,
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
      userId: userId ?? this.userId, // Adicionado ao retorno do copyWith
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
      'idade': idade, // Adicionado ao toJson
      'nome_mae': nomeMae,
      'nome_pai': nomePai,
      'nacionalidade': nacionalidade,
      'nascimento_uf': nascimentoUf,
      'nascimento_cidade': nascimentoCidade,
      'pais_origem': paisOrigem,
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
      nacionalidade: json['nacionalidade'],
      nascimentoUf: json['nascimento_uf'],
      nascimentoCidade: json['nascimento_cidade'],
      paisOrigem: json['pais_origem'],
      possuiInternet: json['possui_internet'],
      possuiDevice: json['possui_device'],
      telefone: json['telefone'],
      email: json['email'],
      isGemeo: json['is_gemeo'],
      nomeGemeo: json['nome_gemeo'],
      trabalha: json['trabalha'],
      profissao: json['profissao'],
      empresa: json['empresa'],
      isPCD: json['is_pcd'],
      deficiencia: json['deficiencia'],
      userId: json['user_id'],
    );
  }
}
