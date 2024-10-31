import 'package:flutter/material.dart';

class Anunciar extends StatefulWidget {
  const Anunciar({super.key});

  @override
  State<Anunciar> createState() => _AnunciarState();
}

class _AnunciarState extends State<Anunciar> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(),
    );
  }
}
