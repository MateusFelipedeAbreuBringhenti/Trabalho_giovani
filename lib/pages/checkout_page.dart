import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/carrinho.dart';
import '../models/carne.dart';
import 'sucesso_page.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nomeController = TextEditingController();
  final enderecoController = TextEditingController();
  final cepController = TextEditingController();

  String formaPagamento = 'PIX';

  List<Carne> itens = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    itens = await Carrinho.listar();
    total = await Carrinho.total();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Resumo do Pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          for (var item in itens)
            ListTile(
              title: Text(item.nome),
              trailing: Text(
                'R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}',
              ),
            ),

          const Divider(),

          Text(
            'Total: R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          const Text(
            'Seus Dados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: cepController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'CEP',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _buscarCep,
              ),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: enderecoController,
            decoration: const InputDecoration(
              labelText: 'Endereço',
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: _pegarLocalizacao,
              icon: const Icon(Icons.my_location),
              label: const Text(
                'Usar minha localização (GPS)',
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Forma de Pagamento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          RadioListTile(
            title: const Text('PIX'),
            value: 'PIX',
            groupValue: formaPagamento,
            onChanged: (valor) {
              setState(() {
                formaPagamento = valor!;
              });
            },
          ),

          RadioListTile(
            title: const Text('Cartão'),
            value: 'Cartao',
            groupValue: formaPagamento,
            onChanged: (valor) {
              setState(() {
                formaPagamento = valor!;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _irParaSucesso,
              child: const Text('Finalizar Pedido'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buscarCep() async {
    String cep = cepController.text.trim();

    if (cep.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um CEP'),
        ),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);

        if (dados['erro'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CEP não encontrado'),
            ),
          );
          return;
        }

        setState(() {
          enderecoController.text =
          '${dados['logradouro']}, '
              '${dados['bairro']} - '
              '${dados['localidade']}/${dados['uf']}';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar CEP: $e'),
        ),
      );
    }
  }

  Future<void> _pegarLocalizacao() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position pos =
    await Geolocator.getCurrentPosition();

    setState(() {
      enderecoController.text =
      "Lat: ${pos.latitude} | Lng: ${pos.longitude}";
    });
  }

  void _irParaSucesso() async {
    await Carrinho.limpar();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SucessoPage(),
      ),
    );
  }
}