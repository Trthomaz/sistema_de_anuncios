import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/pesquisa.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Perfil extends StatefulWidget {
  final String ip;
  final int id;

  const Perfil({super.key, required this.ip, required this.id});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late String ip;
  late int id;
  bool _isLoading = true;

  late Map<String, dynamic> perfil;
  late List<Map<String, dynamic>> anuncios;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
    _carregarPerfil();
    _carregarAnuncios();
  }

  Future<Map<String, dynamic>?> _perfil() async {
    final url = Uri.parse('http://${ip}:5000/get_perfil'); // URL de exemplo

    final dados = {
      'user_id': id,
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

  Future<void> _carregarPerfil() async {
    // Simula a busca de dados (substitua pela sua lógica real)
    Map<String, dynamic>? dados = await _perfil();
    print(dados);

    setState(() {
      if (dados == null) {
        perfil = {};
        return;
      }
      perfil = dados;
      print("----------AQUI---------------");
      print(perfil);
    });
  }

  Future<void> _carregarAnuncios() async {
    // Simula a busca de dados (substitua pela sua lógica real)
    List<Map<String, dynamic>>? anunciosBuscados = await _meusAnuncios();
    print(anunciosBuscados);

    setState(() {
      if (anunciosBuscados == null) {
        anuncios = [];
        return;
      }
      anuncios = anunciosBuscados;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 150;
    double imageSize = cardHeight - 10;

    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: PreferredSize(
                // Tamanho do AppBar
                preferredSize: Size.fromHeight(60.0),
                child: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  leading: Padding(
                    // Leading é o ícone à esquerda do AppBar
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 1),
                    child: Image.asset(
                      // Imagem do ícone do app
                      'assets/images/andaime.png',
                      fit: BoxFit.contain,
                      width: 0.5,
                      height: 0.5,
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(1),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          // TODO: Mudar animação de transição
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pesquisa()),
                          );
                        });
                      },
                      readOnly: true,
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
                        fillColor: Theme.of(context).cardColor.withOpacity(0.1),
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
                  actions: [
                    // Actions é o ícone à direita do AppBar
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 1, top: 10, bottom: 10, right: 10),
                      child: IconButton(
                        padding: EdgeInsets.only(bottom: 1),
                        icon: Icon(
                          Icons.message_rounded,
                          color: Theme.of(context).primaryColorLight,
                          size: 30,
                        ),
                        onPressed: () {
                          // TODO
                        },
                      ),
                    ),
                  ],
                ),
              ),
              body: LayoutBuilder(builder: (context, constraints) {
                double containerWidth = constraints.maxWidth * 0.9;
                double containerHeight = constraints.maxHeight - 190;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 4, left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Card(
                                shape: CircleBorder(),
                                color: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 60,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(perfil["nome"],
                                    style: TextStyle(
                                      fontSize: 24,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    )),
                                SizedBox(height: 5),
                                Text(perfil["curso"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    )),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        "${perfil["reputacao"]}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    RatingBarIndicator(
                                      rating: perfil["reputacao"],
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      itemCount: 5,
                                      itemSize: 24,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text("Histórico",
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).primaryColorLight,
                              )),
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
                              padding: const EdgeInsets.all(5),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.all(6),
                                  backgroundColor: Theme.of(context).cardColor,
                                  fixedSize: Size(cardWidth, cardHeight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  print(constraints.maxHeight);
                                  // TODO: Implementar abrir anuncio
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: anuncios[index]["imagem"] != null
                                          ? Image.asset(
                                              anuncios[index]["imagem"],
                                              fit: BoxFit.contain,
                                              height: imageSize,
                                              width: imageSize,
                                            )
                                          : Icon(
                                              Icons.image_rounded,
                                              size: imageSize,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
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
                                            "R\$${anuncios[index]["preco"]}",
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
                                              child: anuncios[index]["tipo"] ==
                                                      "venda"
                                                  ? Card(
                                                      margin: EdgeInsets.all(0),
                                                      color: Color(0xFF134E6C),
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
                                                      margin: EdgeInsets.all(0),
                                                      color: Color(0xFF38524A),
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
                  ],
                );
              })),
    );
  }
}
