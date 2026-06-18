import 'package:flutter/material.dart';
import '../models/carne.dart';
import '../widgets/carne_card.dart';
import 'detalhe_produto_page.dart';
import '../models/carrinho.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Carne> carnes = [
    Carne(
      nome: 'Picanha Premium',
      preco: 89.90,
      imagem: 'https://plus.unsplash.com/premium_photo-1723672929404-36ba6ed8ab50?q=80&w=1063',
    ),
    Carne(
      nome: 'Costela Bovina',
      preco: 39.90,
      imagem: 'https://images.unsplash.com/photo-1625604086988-6e41981275fa?q=80&w=1170',
    ),
    Carne(
      nome: 'Alcatra',
      preco: 49.90,
      imagem: 'https://plus.unsplash.com/premium_photo-1726826441453-e2812a300534?q=80&w=1110',
    ),
    Carne(
      nome: 'Fraldinha',
      preco: 44.90,
      imagem: 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?q=80&w=1170',
    ),
    Carne(
      nome: 'Contra-filé',
      preco: 59.90,
      imagem: 'https://images.unsplash.com/photo-1558030006-450675393462?q=80&w=1170',
    ),
    Carne(
      nome: 'Cupim',
      preco: 35.90,
      imagem: 'https://images.unsplash.com/photo-1615937691194-97dbd4d1c24f?q=80&w=1170',
    ),
    Carne(
      nome: 'Linguiça Toscana',
      preco: 24.90,
      imagem: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?q=80&w=1170',
    ),
    Carne(
      nome: 'Peito de Frango',
      preco: 19.90,
      imagem: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?q=80&w=1170',
    ),
    Carne(
      nome: 'Costela Suína',
      preco: 29.90,
      imagem: 'https://images.unsplash.com/photo-1613145993480-7f7cbe2c8e6f?q=80&w=1170',
    ),
  ];

  int quantidadeCarrinho = 0;

  Position? _posicaoAtual;

  Future<void> _obterLocalizacao() async {
    bool servicoHabilitado =
    await Geolocator.isLocationServiceEnabled();

    if (!servicoHabilitado) {
      return;
    }
    LocationPermission permissao =
    await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _posicaoAtual = posicao;
    });
  }

  @override
  void initState() {
    super.initState();
    atualizarCarrinho();
  }

  Future<void> atualizarCarrinho() async {
    final itens = await Carrinho.listar();
    quantidadeCarrinho = itens.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeatHouse Premium'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _abrirFiltro,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _abrirCarrinho,
              ),
              Positioned(
                right: 5,
                top: 5,
                child: _buildBadge(),
              ),
            ],
          ),
        ],
      ),
      body: _criarLista(),
    );
  }

  Widget _buildBadge() {
    if (quantidadeCarrinho == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 18,
        minHeight: 18,
      ),
      child: Text(
        '$quantidadeCarrinho',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _criarLista() {
    return ListView.builder(
      itemCount: carnes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onClickProduto(carnes[index]),
          child: CarneCard(carne: carnes[index]),
        );
      },
    );
  }

  void _abrirFiltro() async {
    await Navigator.pushNamed(context, '/filtro');
    atualizarCarrinho();
  }

  void _abrirCarrinho() async {
    await Navigator.pushNamed(context, '/carrinho');
    atualizarCarrinho();
  }

  void _onClickProduto(Carne carne) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheProdutoPage(carne: carne),
      ),
    );
    atualizarCarrinho();
  }
}