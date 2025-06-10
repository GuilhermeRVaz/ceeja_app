class AddressModel {
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
}
