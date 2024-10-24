import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/feed.dart';

void main() {
  runApp(MaterialApp(
      title: "Andaime",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorDark: Colors.black,
          primaryColorLight: Colors.white,
          scaffoldBackgroundColor: const Color.fromARGB(255, 178, 197, 207),
          cardColor: const Color.fromARGB(255, 178, 197, 207),
          highlightColor: Colors.blueGrey),
      home: Feed()));
}
