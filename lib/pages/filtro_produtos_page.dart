import 'package:flutter/material.dart';

class FiltroProdutosPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';

  @override
  _FiltroProdutosPageState createState() => _FiltroProdutosPageState();
}

class _FiltroProdutosPageState extends State<FiltroProdutosPage> {

  String tipoSelecionado = 'Bovina';
  bool promocao = false;
  final buscaController = TextEditingController();

  final tipos = ['Bovina', 'Suína', 'Frango', 'Peixe'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Tipo de Carne'),
          ),

          for (final tipo in tipos)
            Row(
              children: [
                Radio(
                  value: tipo,
                  groupValue: tipoSelecionado,
                  onChanged: (valor) {
                    setState(() {
                      tipoSelecionado = valor!;
                    });
                  },
                ),
                Text(tipo),
              ],
            ),

          const Divider(),

          Row(
            children: [
              Checkbox(
                value: promocao,
                onChanged: (valor) {
                  setState(() {
                    promocao = valor!;
                  });
                },
              ),
              const Text('Apenas promoção'),
            ],
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: buscaController,
              decoration: const InputDecoration(
                labelText: 'Buscar produto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}