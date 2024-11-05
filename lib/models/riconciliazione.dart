class Riconciliazione {
  final String id;
  final DateTime data;
  final int primo;
  final int inMacchina;
  final int pezziProdotti;
  final int scarti;
  final int campione;
  final int primaPartita;
  final int bancale;
  final int risultato;

  Riconciliazione({
    required this.id,
    required this.data,
    required this.primo,
    required this.inMacchina,
    required this.pezziProdotti,
    required this.scarti,
    required this.campione,
    required this.primaPartita,
    required this.bancale,
    required this.risultato,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'data': data.toIso8601String(),
    'primo': primo,
    'inMacchina': inMacchina,
    'pezziProdotti': pezziProdotti,
    'scarti': scarti,
    'campione': campione,
    'primaPartita': primaPartita,
    'bancale': bancale,
    'risultato': risultato,
  };

  factory Riconciliazione.fromJson(Map<String, dynamic> json) => Riconciliazione(
    id: json['id'],
    data: DateTime.parse(json['data']),
    primo: json['primo'],
    inMacchina: json['inMacchina'],
    pezziProdotti: json['pezziProdotti'],
    scarti: json['scarti'],
    campione: json['campione'],
    primaPartita: json['primaPartita'],
    bancale: json['bancale'],
    risultato: json['risultato'],
  );
}