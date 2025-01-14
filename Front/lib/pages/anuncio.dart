import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:sistema_de_anuncios/pages/chat.dart';
import 'package:sistema_de_anuncios/pages/navigation/perfil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Anuncio extends StatefulWidget {
  final String ip;
  final int anuncioId;
  final int userId;

  const Anuncio(
      {super.key,
      required this.ip,
      required this.anuncioId,
      required this.userId});

  @override
  State<Anuncio> createState() => _AnuncioState();
}

Future<Map<String, dynamic>?> _getPerfil(String ip, int user_id) async {
  final url = Uri.parse('http://$ip:5000/get_perfil');

  // Dados enviados
  final dados = {'user_id': user_id};

  try {
    final response = await http.post(
      url,
      headers: {
        // Define o tipo de conteúdo como json
        'Content-Type': 'application/json'
      },
      body: json.encode(dados),
    );
    Map<String, dynamic> resposta = json.decode(response.body);
    return resposta["dados"];
  } catch (e) {
    print(e);
    return null;
  }
}

Future<int> _criarConversa(String ip, int user1_id, int user2_id) async {
  final url = Uri.parse('http://$ip:5000/iniciar_conversa');

  // Dados enviados
  final dados = {'anunciante_id': user1_id, 'interessado_id': user2_id};

  try {
    final response = await http.post(
      url,
      headers: {
        // Define o tipo de conteúdo como json
        'Content-Type': 'application/json'
      },
      body: json.encode(dados),
    );

    Map<String, dynamic> resposta = json.decode(response.body);
    return resposta["dados"]["conversa_id"];
  } catch (e) {
    print(e);
    return -1;
  }
}

Future<Map<String, dynamic>> _getAnunciobyID(String ip, int anuncio_id) async {
  final url = Uri.parse('http://$ip:5000/get_anuncio');

  // Dados enviados
  final dados = {'anuncio_id': anuncio_id};

  try {
    final response = await http.post(
      url,
      headers: {
        // Define o tipo de conteúdo como json
        'Content-Type': 'application/json'
      },
      body: json.encode(dados),
    );

    Map<String, dynamic> resposta = json.decode(response.body);
    return resposta["dados"];
  } catch (e) {
    print(e);
    return {"erro": "erro"};
  }
}

class _AnuncioState extends State<Anuncio> {
  Uint8List? decodificar(String base64Image) {
    // Verifica se a string Base64 começa com o prefixo 'data:image'
    if (base64Image.startsWith("data:image")) {
      // Remove o prefixo 'data:image/...;base64,' (se presente)
      base64Image = base64Image.split(",")[1];
    }

    // Decodifica a string Base64 para bytes (Uint8List)
    return base64Decode(base64Image);
  }

  void _editarAnuncio(String ip, int anuncio_id) {
  // Implementar
  // Redirecionar pra página de criar anuncio mas com os campos preenchidos podendo ser editados
}

void _excluirAnuncio(String ip, int anuncio_id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: SizedBox(
                height: 60,
                width: 270,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text("Excluir Anúncio",
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColorLight,
                        )),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(
                "Tem certeza que deseja excluir o anúncio?",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text("Ok",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(1)),
                )
              ],
            );
          },
        );
      },
    );
  return;
}

  late int userId;

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAnunciobyID(widget.ip, widget.anuncioId),
        builder: (context, snapshot_anuncio) {
            return Scaffold(
                appBar: PreferredSize(
                  // Tamanho do AppBar
                  preferredSize: Size.fromHeight(60.0),
                  child: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    leading: Padding(
                      // Leading é o ícone à esquerda do AppBar
                      padding: const EdgeInsets.only(
                          left: 4, top: 2, bottom: 2, right: 2),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Center(
                        child: Text(
                          "Anúncio",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: snapshot_anuncio.hasData ? LayoutBuilder(builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth - 20;
                  double containerHeight = constraints.maxHeight - 123;
                  double imagem = constraints.maxHeight - 500;
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        SizedBox(
                            height: containerHeight,
                            child: SingleChildScrollView(
                              // (Imagem, Título, Preço, Descrição)
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  // Imagem
                                  Center(
                                      child: snapshot_anuncio.data!["imagem"] !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                decodificar(snapshot_anuncio
                                                    .data!["imagem"])!,
                                                fit: BoxFit.contain,
                                                height: imagem,
                                                width: imagem,
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'assets/images/image.png',
                                                fit: BoxFit.contain,
                                                height: imagem - 50,
                                                width: imagem - 50,
                                              ),
                                            )),
                                  Divider(
                                    color: Theme.of(context).primaryColorLight,
                                    thickness: 1,
                                    height: 10,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  Column(
                                    children: [
                                      // Título
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text(
                                            snapshot_anuncio.data!["titulo"],
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Preço
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text(
                                            "R\$ ${snapshot_anuncio.data!["preco"].toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        thickness: 1,
                                        height: 10,
                                      ),
                                      // Descrição
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Descrição",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                  height: 30,
                                                  width: 80,
                                                  child: snapshot_anuncio
                                                              .data!["tipo"] ==
                                                          "venda"
                                                      ? Card(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          color: Color(0xFF134E6C),
                                                          child: Center(
                                                            child: Text(
                                                              "Venda",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight),
                                                            ),
                                                          ),
                                                        )
                                                      : Card(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          color: Color(0xFF38524A),
                                                          child: Center(
                                                            child: Text(
                                                              "Busca",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight),
                                                            ),
                                                          ),
                                                        )),
                                              SizedBox(
                                                  height: 30,
                                                  width: 80,
                                                  child: snapshot_anuncio
                                                              .data!["categoria"] ==
                                                          "serviço"
                                                      ? Card(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          color: Color(0xFF134E6C),
                                                          child: Center(
                                                            child: Text(
                                                              "Serviço",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight),
                                                            ),
                                                          ),
                                                        )
                                                      : Card(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          color: Color(0xFF38524A),
                                                          child: Center(
                                                            child: Text(
                                                              "Produto",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight),
                                                            ),
                                                          ),
                                                        )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text(
                                            snapshot_anuncio.data!["descricao"],
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        // Anunciante
                        userId == snapshot_anuncio.data!["anunciante_id"]
                            // Se o usuário for o anunciante
                            ? Column(
                                children: [
                                  Divider(
                                    color: Theme.of(context).primaryColorLight,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Editar Anúncio
                                        FutureBuilder(
                                            future: _criarConversa(
                                                widget.ip,
                                                snapshot_anuncio
                                                    .data!["anunciante_id"],
                                                widget.userId),
                                            builder:
                                                (context, snapshot_conversa) {
                                              if (snapshot_conversa.hasData) {
                                                return Container(
                                                  height: 40,
                                                  width:
                                                      constraints.maxWidth / 2 -
                                                          20,
                                                  child: ElevatedButton(
                                                    onPressed: () => {
                                                      setState(() {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return const Chat();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                        arguments: {
                                                                      'id_conversa':
                                                                          snapshot_conversa
                                                                              .data!,
                                                                      'ip': widget
                                                                          .ip,
                                                                      'id': snapshot_anuncio.data!["anunciante_id"] ==
                                                                              widget
                                                                                  .userId
                                                                          ? snapshot_anuncio.data![
                                                                              "interessado_id"]
                                                                          : snapshot_anuncio
                                                                              .data!["anunciante_id"]
                                                                    })));
                                                      })
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        1)),
                                                    child: Text(
                                                        "Editar Anúncio",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight)),
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            }),
                                        // Excluir Anúncio
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 40,
                                            width:
                                                constraints.maxWidth / 2 - 20,
                                            child: ElevatedButton(
                                              onPressed: () => {
                                                _excluirAnuncio(
                                                    widget.ip,
                                                    snapshot_anuncio
                                                        .data!["anuncio_id"]),
                                                Navigator.of(context).pop()
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(1)),
                                              child: Text("Excluir Anúncio",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorLight)),
                                            ),
                                          ),
                                        )
                                      ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            // Se o usuário não for o anunciante
                            : Column(
                                children: [
                                  Divider(
                                    color: Theme.of(context).primaryColorLight,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                  FutureBuilder(
                                      future: _getPerfil(
                                          widget.ip,
                                          snapshot_anuncio
                                              .data!["anunciante_id"]),
                                      builder: (context, snapshot3) {
                                        if (snapshot3.hasData) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, left: 10, right: 10),
                                              child: Text(
                                                "${snapshot3.data!["nome"]}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 23,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  FutureBuilder(
                                      future: _getPerfil(
                                          widget.ip,
                                          snapshot_anuncio
                                              .data!["anunciante_id"]),
                                      builder: (context, snapshot3) {
                                        if (snapshot3.hasData) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                  left: 10,
                                                  right: 10),
                                              child: RatingBarIndicator(
                                                rating: snapshot3
                                                    .data!["reputacao"],
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                itemCount: 5,
                                                itemSize: 24,
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                            future: _criarConversa(
                                                widget.ip,
                                                snapshot_anuncio
                                                    .data!["anunciante_id"],
                                                widget.userId),
                                            builder:
                                                (context, snapshot_conversa) {
                                              if (snapshot_conversa.hasData) {
                                                return Container(
                                                  height: 40,
                                                  width:
                                                      constraints.maxWidth / 2 -
                                                          20,
                                                  child: ElevatedButton(
                                                    onPressed: () => {
                                                      setState(() {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return const Chat();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                        arguments: {
                                                                      'id_conversa':
                                                                          snapshot_conversa
                                                                              .data!,
                                                                      'ip': widget
                                                                          .ip,
                                                                      'id': snapshot_anuncio.data!["anunciante_id"] ==
                                                                              widget
                                                                                  .userId
                                                                          ? snapshot_anuncio.data![
                                                                              "interessado_id"]
                                                                          : snapshot_anuncio
                                                                              .data!["anunciante_id"]
                                                                    })));
                                                      })
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        1)),
                                                    child: Text(
                                                        "Enviar Mensagem",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight)),
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 40,
                                            width:
                                                constraints.maxWidth / 2 - 20,
                                            child: ElevatedButton(
                                              onPressed: () => {
                                                setState(() {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return Perfil(
                                                      ip: widget.ip,
                                                      id: userId,
                                                      perfilId: snapshot_anuncio
                                                              .data![
                                                          "anunciante_id"],
                                                    );
                                                  }));
                                                })
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(1)),
                                              child: Text("Visitar Perfil",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorLight)),
                                            ),
                                          ),
                                        )
                                      ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                      ],
                    );
                  });
                })
                : Center(
                    child: CircularProgressIndicator(),
                  ));
        });
  }
}
