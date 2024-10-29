import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/login.dart';

void main() {
  runApp(MaterialApp(
      title: "Andaime",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: const Color.fromARGB(255, 178, 197, 207),
        cardColor: const Color.fromARGB(255, 178, 197, 207),
        primaryColor: Colors.blueGrey,
        highlightColor: const Color.fromARGB(255, 108, 126, 136),
      ),
      home: Login()));
}
