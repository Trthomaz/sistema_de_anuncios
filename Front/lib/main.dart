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
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.blueGrey,
      ),
      home: Feed()));
}
