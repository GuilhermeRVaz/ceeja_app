class AddressModel {
  final String? userId;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? nomeCidade;
  final String? ufCidade;
  final String? zona; // 'Urbana' ou 'Rural'
  final bool temLocalizacaoDiferenciada;
  final String? localizacaoDiferenciada; // 'Área de assentamento', 'Terra indígena', 'Área quilombola'
  final String? nacionalidade; // 'Brasileira' ou 'Estrangeira'
  final String? paisOrigem; // Para estrangeiros
  final String? nascimentoUf; // Para brasileiros
  final String? nascimentoCidade; // Para brasileiros

  const AddressModel({
    this.userId,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.nomeCidade,
    this.ufCidade,
    this.zona,
    this.temLocalizacaoDiferenciada = false,
    this.localizacaoDiferenciada,
    this.nacionalidade,
    this.paisOrigem,
    this.nascimentoUf,
    this.nascimentoCidade,
  });

  AddressModel copyWith({
    String? userId,
    String? cep,
    String? logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? nomeCidade,
    String? ufCidade,
    String? zona,
    bool? temLocalizacaoDiferenciada,
    String? localizacaoDiferenciada,
    String? nacionalidade,
    String? paisOrigem,
    String? nascimentoUf,
    String? nascimentoCidade,
  }) {
    return AddressModel(
      userId: userId ?? this.userId,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      nomeCidade: nomeCidade ?? this.nomeCidade,
      ufCidade: ufCidade ?? this.ufCidade,
      zona: zona ?? this.zona,
      temLocalizacaoDiferenciada: temLocalizacaoDiferenciada ?? this.temLocalizacaoDiferenciada,
      localizacaoDiferenciada: localizacaoDiferenciada ?? this.localizacaoDiferenciada,
      nacionalidade: nacionalidade ?? this.nacionalidade,
      paisOrigem: paisOrigem ?? this.paisOrigem,
      nascimentoUf: nascimentoUf ?? this.nascimentoUf,
      nascimentoCidade: nascimentoCidade ?? this.nascimentoCidade,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'nome_cidade': nomeCidade,
      'uf_cidade': ufCidade,
      'zona': zona,
      'tem_localizacao_diferenciada': temLocalizacaoDiferenciada,
      'localizacao_diferenciada': localizacaoDiferenciada,
      'nacionalidade': nacionalidade,
      'pais_origem': paisOrigem,
      'nascimento_uf': nascimentoUf,
      'nascimento_cidade': nascimentoCidade,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return false;
    }
    return AddressModel(
      userId: json['user_id'],
      cep: json['cep'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      nomeCidade: json['nome_cidade'],
      ufCidade: json['uf_cidade'],
      zona: json['zona'],
      temLocalizacaoDiferenciada: parseBool(json['tem_localizacao_diferenciada']),
      localizacaoDiferenciada: json['localizacao_diferenciada'],
      nacionalidade: json['nacionalidade'],
      paisOrigem: json['pais_origem'],
      nascimentoUf: json['nascimento_uf'],
      nascimentoCidade: json['nascimento_cidade'],
    );
  }

  // Método utilitário para merge dos dados extraídos pela IA
  AddressModel mergeFromExtractedData(Map<String, dynamic> extracted) {
    return copyWith(
      cep: extracted['cep'],
      logradouro: extracted['logradouro'],
      numero: extracted['numero'],
      complemento: extracted['complemento'],
      bairro: extracted['bairro'],
      nomeCidade: extracted['nome_cidade'],
      ufCidade: extracted['uf_cidade'],
      zona: extracted['zona'],
      temLocalizacaoDiferenciada: extracted['tem_localizacao_diferenciada'],
      localizacaoDiferenciada: extracted['localizacao_diferenciada'],
      nacionalidade: extracted['nacionalidade'],
      paisOrigem: extracted['pais_origem'],
      nascimentoUf: extracted['nascimento_uf'],
      nascimentoCidade: extracted['nascimento_cidade'],
    );
  }
}
