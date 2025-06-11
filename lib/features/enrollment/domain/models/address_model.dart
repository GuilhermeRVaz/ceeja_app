class AddressModel {
  String? userId;
  String? cep;
  String? logradouro;
  String? numero;
  String? complemento;
  String? bairro;
  String? nomeCidade;
  String? ufCidade;
  String? zona; // 'Urbana' ou 'Rural'
  bool temLocalizacaoDiferenciada;
  String?
  localizacaoDiferenciada; // 'Área de assentamento', 'Terra indígena', 'Área quilombola'

  AddressModel({
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
      temLocalizacaoDiferenciada:
          temLocalizacaoDiferenciada ?? this.temLocalizacaoDiferenciada,
      localizacaoDiferenciada:
          localizacaoDiferenciada ?? this.localizacaoDiferenciada,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'nomeCidade': nomeCidade,
      'ufCidade': ufCidade,
      'zona': zona,
      'temLocalizacaoDiferenciada': temLocalizacaoDiferenciada,
      'localizacaoDiferenciada': localizacaoDiferenciada,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      userId: json['userId'],
      cep: json['cep'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      nomeCidade: json['nomeCidade'],
      ufCidade: json['ufCidade'],
      zona: json['zona'],
      temLocalizacaoDiferenciada: json['temLocalizacaoDiferenciada'],
      localizacaoDiferenciada: json['localizacaoDiferenciada'],
    );
  }
}
