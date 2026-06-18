import 'package:flutter/material.dart';
import '../models/carne.dart';
import '../models/carrinho.dart';

class DetalheProdutoPage extends StatelessWidget {
  final Carne carne;

  const DetalheProdutoPage({super.key, required this.carne});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carne.nome),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.network(
              carne.imagem,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              carne.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'R\$ ${carne.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.amber,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Descrição do produto:\n\nCarne selecionada de alta qualidade, ideal para churrasco.',
              style: TextStyle(fontSize: 16),
            ),
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await Carrinho.adicionar(carne);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adicionado ao carrinho!'),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 10),
                    Text('Adicionar ao Carrinho'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}