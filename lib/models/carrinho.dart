import '../database/carne_dao.dart';
import 'carne.dart';

class Carrinho {
  static final CarneDao _dao = CarneDao();

  static Future<void> adicionar(Carne carne) async {
    await _dao.salvar(carne);
  }

  static Future<void> remover(Carne carne) async {
    if (carne.id != null) {
      await _dao.excluir(carne.id!);
    }
  }

  static Future<List<Carne>> listar() async {
    return await _dao.listar();
  }

  static Future<void> limpar() async {
    final itens = await listar();

    for (var item in itens) {
      if (item.id != null) {
        await _dao.excluir(item.id!);
      }
    }
  }

  static Future<double> total() async {
    final itens = await listar();

    return itens.fold<double>(
      0.0,
          (total, item) => total + (item.preco * item.quantidade),
    );
  }
}