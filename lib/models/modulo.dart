class Modulo {
  final String id;
  final String nome;
  final String codice;

  Modulo({
    required this.id,
    required this.nome,
    required this.codice,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'codice': codice,
  };

  factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
    id: json['id'],
    nome: json['nome'],
    codice: json['codice'],
  );

  int compareTo(Modulo other) => codice.compareTo(other.codice);
}