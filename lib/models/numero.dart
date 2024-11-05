class Numero {
  final String id;
  final String nome;
  final String telefono;
  final String? sezioneId;

  Numero({
    required this.id,
    required this.nome,
    required this.telefono,
    this.sezioneId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'telefono': telefono,
    'sezioneId': sezioneId,
  };

  factory Numero.fromJson(Map<String, dynamic> json) => Numero(
    id: json['id'],
    nome: json['nome'],
    telefono: json['telefono'],
    sezioneId: json['sezioneId'],
  );
}