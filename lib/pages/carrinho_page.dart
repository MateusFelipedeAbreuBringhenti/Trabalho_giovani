import 'package:flutter/material.dart';
import '../models/carrinho.dart';
import '../models/carne.dart';
import '../database/carne_dao.dart';

class CarrinhoPage extends StatefulWidget {
  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  List<Carne> itens = [];
  final dao = CarneDao();

  double total = 0;

  @override
  void initState() {
    super.initState();
    carregarCarrinho();
  }

  Future<void> carregarCarrinho() async {
    itens = await Carrinho.listar();
    _calcularTotal();
  }

  void _calcularTotal() {
    double soma = 0;

    for (var item in itens) {
      soma += item.preco * item.quantidade;
    }

    setState(() {
      total = soma;
    });
  }

  Future<void> atualizarCarrinho() async {
    await carregarCarrinho();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: _criarLista(),
    );
  }

  Widget _criarLista() {
    if (itens.isEmpty) {
      return const Center(
        child: Text('Carrinho vazio'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final carne = itens[index];

              return ListTile(
                title: Text(carne.nome),

                subtitle: Text(
                  'R\$ ${(carne.preco * carne.quantidade).toStringAsFixed(2)}',
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () async {
                        if (carne.quantidade > 1) {
                          await dao.atualizarQuantidade(
                              carne.id!, carne.quantidade - 1);
                        } else {
                          await dao.excluir(carne.id!);
                        }

                        await atualizarCarrinho();
                      },
                    ),

                    Text('${carne.quantidade}'),

                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await dao.atualizarQuantidade(
                            carne.id!, carne.quantidade + 1);

                        await atualizarCarrinho();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Total: R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _irParaCheckout,
              child: const Text('Finalizar Compra'),
            ),
          ),
        ),
      ],
    );
  }

  void _irParaCheckout() {
    Navigator.pushNamed(context, '/checkout');
  }
}