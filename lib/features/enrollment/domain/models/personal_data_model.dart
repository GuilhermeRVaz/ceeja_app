class PersonalDataModel {
  // Dados de Identificação
  String? nomeCompleto;
  bool temNomeSocial;
  String? nomeSocial;
  bool temNomeAfetivo;
  String? nomeAfetivo;
  String? sexo;
  String? rg;
  String? rgDigito;
  String? rgUf;
  DateTime? rgDataEmissao;
  String? cpf;
  String? racaCor;
  DateTime? dataNascimento;

  // Filiação
  String? nomeMae;
  String? nomePai;

  // Nacionalidade
  String? nacionalidade; // 'Brasileira' ou 'Estrangeira'
  String? nascimentoUf;
  String? nascimentoCidade;
  String? paisOrigem;

  // Contato e Conectividade
  bool? possuiInternet;
  bool? possuiDevice;
  String? telefone;
  String? email;

  // Outros
  bool? isGemeo;
  String? nomeGemeo;
  bool? trabalha;
  String? profissao;
  String? empresa;
  bool? isPCD;
  String? deficiencia;

  PersonalDataModel({
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
    );
  }
}
