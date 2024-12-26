import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exibindo JSON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JsonScreen(),
    );
  }
}

class JsonScreen extends StatefulWidget {
  const JsonScreen({super.key});

  @override
  State<JsonScreen> createState() => _JsonScreenState();
}

class _JsonScreenState extends State<JsonScreen> {
  List<dynamic>? _jsonData;
  bool _isLoading = false;
  String ip = "192.168.0.104";
  late Map<String, dynamic> perfil;
  late List<Map<String, dynamic>> anuncios;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<Map<String, dynamic>?> _perfil() async {
    final url = Uri.parse('http://${ip}:5000/get_perfil'); // URL de exemplo
    
    final dados = {
      'user_id': 2,
    };

    // Enviar requisição
    try {
      final response = await http.post(
        url,
        headers: {
          // Define o tipo de conteúdo como json
          'Content-Type': 'application/json'
        },
        body: json.encode(dados),
      );
      if (response.statusCode == 200) {
        // Resposta da requisição
        final resposta = json.decode(response.body);
        final perfil = resposta['dados'];
        print(perfil);
        print("-------------------------");
        return perfil;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> _meusAnuncios() async {
    final url = Uri.parse('http://${ip}:5000/get_meus_anuncios');

    // Dados enviados
    final dados = {
      'user_id': 2,
    };

    // Enviar requisição
    try {
      final response = await http.post(
        url,
        headers: {
          // Define o tipo de conteúdo como json
          'Content-Type': 'application/json'
        },
        body: json.encode(dados),
      );
      if (response.statusCode == 200) {
        // Resposta da requisição
        final resposta = json.decode(response.body);
        final anuncios = resposta['anuncios'].cast<Map<String, dynamic>>(); // List<dynamic> -> List<Map<String, dynamic>>
        print(resposta);
        print("-------------------------");
        return anuncios;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }


  Future<void> _carregarDados() async {
    // Simula a busca de dados (substitua pela sua lógica real)
    Map<String, dynamic>? dados = await _perfil();
    List<Map<String, dynamic>>? anunciosBuscados = await _meusAnuncios();

    setState(() {
      if (dados == null) {
        perfil = {};
        return;
      }

      if (anunciosBuscados == null) {
        anuncios = [];
        return;
      }
      perfil = dados;
      anuncios = anunciosBuscados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exibindo JSON'),
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          Text(perfil.toString()),
          Text(anuncios.toString()),
        ],
      ),
    );
  }
}