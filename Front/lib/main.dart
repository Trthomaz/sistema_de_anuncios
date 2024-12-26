import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/login.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:sistema_de_anuncios/pages/mensagens.dart';
import 'package:sistema_de_anuncios/pages/requisicao.dart';

void main() async {
  runApp(MaterialApp(
      title: "Andaime",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color.fromARGB(255, 178, 197, 207),
        cardColor: Color(0xFFA4B7C2),
        primaryColor: Colors.blueGrey,
        highlightColor: const Color.fromARGB(255, 108, 126, 136),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color.fromRGBO(96, 125, 139, 1),
          textTheme: ButtonTextTheme.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white, // Cor do cursor
            selectionColor: Colors.lightBlueAccent
                .withOpacity(0.4), // Cor de fundo do texto selecionado
            selectionHandleColor: Colors.blueGrey),
      ),
      home: Login()));
}
