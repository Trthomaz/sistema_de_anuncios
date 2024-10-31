import 'package:flutter/material.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(),
    );
  }
}
