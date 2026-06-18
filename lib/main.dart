import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/filtro_produtos_page.dart';
import 'pages/carrinho_page.dart';
import 'pages/checkout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeatHouse Shop',
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/filtro': (context) => FiltroProdutosPage(),
        '/carrinho': (context) => CarrinhoPage(),
        '/checkout': (context) => CheckoutPage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}