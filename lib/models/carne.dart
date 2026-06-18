class Carne {
  static const String NOME_TABELA = 'carne';
  static const String CAMPO_ID = 'id';
  static const String CAMPO_NOME = 'nome';
  static const String CAMPO_PRECO = 'preco';
  static const String CAMPO_IMAGEM = 'imagem';

  int? id;
  String nome;
  double preco;
  String imagem;
  int quantidade;

  Carne({
    this.id,
    required this.nome,
    required this.preco,
    required this.imagem,
    this.quantidade = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      CAMPO_ID: id,
      CAMPO_NOME: nome,
      CAMPO_PRECO: preco,
      CAMPO_IMAGEM: imagem,
      'quantidade': quantidade,
    };
  }

  factory Carne.fromMap(Map<String, dynamic> map) {
    return Carne(
      id: map[CAMPO_ID],
      nome: map[CAMPO_NOME],
      preco: map[CAMPO_PRECO],
      imagem: map[CAMPO_IMAGEM],
      quantidade: map['quantidade'] ?? 1,
    );
  }
}