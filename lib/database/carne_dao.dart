import '../models/carne.dart';
import 'database_provider.dart';

class CarneDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Carne carne) async {
    final db = await dbProvider.database;
    final result = await db.query(
      Carne.NOME_TABELA,
      where: '${Carne.CAMPO_NOME} = ?',
      whereArgs: [carne.nome],
    );

    if (result.isNotEmpty) {
      final existente = Carne.fromMap(result.first);
      final novaQuantidade = existente.quantidade + 1;
      final atualizado = await db.update(
        Carne.NOME_TABELA,
        {'quantidade': novaQuantidade},
        where: '${Carne.CAMPO_ID} = ?',
        whereArgs: [existente.id],
      );

      return atualizado > 0;
    } else {
      carne.quantidade = 1;
      carne.id = await db.insert(Carne.NOME_TABELA, carne.toMap());
      return true;
    }
  }

  Future<bool> excluir(int id) async {
    final db = await dbProvider.database;
    final result = await db.delete(
      Carne.NOME_TABELA,
      where: '${Carne.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  Future<bool> atualizarQuantidade(int id, int quantidade) async {
    final db = await dbProvider.database;
    final result = await db.update(
      Carne.NOME_TABELA,
      {'quantidade': quantidade},
      where: '${Carne.CAMPO_ID} = ?',
      whereArgs: [id],
    );

    return result > 0;
  }
  Future<List<Carne>> listar() async {
    final db = await dbProvider.database;
    final result = await db.query(Carne.NOME_TABELA);

    return result.map((e) => Carne.fromMap(e)).toList();
  }
}