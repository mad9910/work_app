class Sezione {
  final String id;
  final String nome;
  final String? descrizione;

  Sezione({
    required this.id,
    required this.nome,
    this.descrizione,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'descrizione': descrizione,
  };

  factory Sezione.fromJson(Map<String, dynamic> json) => Sezione(
    id: json['id'],
    nome: json['nome'],
    descrizione: json['descrizione'],
  );
}