import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:sistema_de_anuncios/pages/anuncio.dart';

class MeusAnuncios extends StatefulWidget {
  final String ip;
  final int id;

  const MeusAnuncios({super.key, required this.ip, required this.id});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  late String ip;
  late int id;
  late List<Map<String, dynamic>> anuncios;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
    _carregarAnuncios();
  }

  Uint8List? decodificar(String base64Image) {
    // Verifica se a string Base64 começa com o prefixo 'data:image'
    if (base64Image.startsWith("data:image")) {
      // Remove o prefixo 'data:image/...;base64,' (se presente)
      base64Image = base64Image.split(",")[1];
    }

    // Decodifica a string Base64 para bytes (Uint8List)
    return base64Decode(base64Image);
  }

  Future<void> _carregarAnuncios() async {
    // Simula a busca de dados (substitua pela sua lógica real)
    List<Map<String, dynamic>>? anunciosBuscados = await _meusAnuncios();

    setState(() {
      if (anunciosBuscados == null) {
        anuncios = [];
        return;
      }
      anuncios = anunciosBuscados;
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>?> _meusAnuncios() async {
    final url = Uri.parse('http://${ip}:5000/get_meus_anuncios');
    final now = DateTime.now().toLocal();
    final data = now.toString().substring(0, 19);

    // Dados enviados
    final dados = {'user_id': id, 'data': data};

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
        final anuncios = resposta['anuncios'].cast<
            Map<String,
                dynamic>>(); // List<dynamic> -> List<Map<String, dynamic>>
        return anuncios;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 150;
    double imageSize = cardHeight - 10;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                automaticallyImplyLeading: false,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      "Meus Anúncios",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              double containerWidth = constraints.maxWidth * 0.9;
              double containerHeight = constraints.maxHeight - 94;
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: containerWidth,
                      child: TextField(
                        autocorrect: false,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 22,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          hintText: "Pesquisar",
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: containerWidth,
                        height: containerHeight,
                        child: ListView.builder(
                          itemCount: anuncios.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 5),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.all(6),
                                  backgroundColor:
                                      Theme.of(context).cardColor,
                                  fixedSize: Size(cardWidth, cardHeight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Anuncio(
                                            ip: ip,
                                            anuncioId: anuncios[index]["id"],
                                            userId: id,
                                          ),
                                        ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: anuncios[index]["imagem"] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                decodificar(anuncios[index]["imagem"])!,
                                                fit: BoxFit.contain,
                                                height: imageSize,
                                                width: imageSize,
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(
                                                      10),
                                              child: Image.asset(
                                                'assets/images/image.png',
                                                fit: BoxFit.contain,
                                                height: imageSize - 20,
                                                width: imageSize - 20,
                                              ),
                                            ),
                                    ),
                                    VerticalDivider(
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.4),
                                      thickness: 1,
                                      width: 10,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            anuncios[index]["titulo"],
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "R\$${anuncios[index]["preco"].toStringAsFixed(2)}",
                                            softWrap: true,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 22,
                                            ),
                                          ),
                                          SizedBox(
                                              height: 15,
                                              width: 40,
                                              child: anuncios[index]
                                                          ["tipo"] ==
                                                      "venda"
                                                  ? Card(
                                                      margin:
                                                          EdgeInsets.all(0),
                                                      color:
                                                          Color(0xFF134E6C),
                                                      child: Center(
                                                        child: Text(
                                                          "Venda",
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight),
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      margin:
                                                          EdgeInsets.all(0),
                                                      color:
                                                          Color(0xFF38524A),
                                                      child: Center(
                                                        child: Text(
                                                          "Busca",
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight),
                                                        ),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            }));
  }
}
