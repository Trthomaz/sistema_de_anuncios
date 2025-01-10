import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _mensagemController = TextEditingController();

  // ------------------------------------------------------ Funções para REQUISIÇÕES -----------------------------------------------------

  // -------------------------------------------- Pegar as mensagens

  Future<List<dynamic>> _getMensagens(String ip, int id) async {
    final url = Uri.parse('http://$ip:5000/get_mensagens');

    // Dados enviados
    final dados = {
      'id': id,
    };

    // Mensagem de erro
    dynamic mensagemErrorMessage(String errorText) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Erro ao buscar mensagens",
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(errorText,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 192, 65, 55))),
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
          });
    }

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

        Map<String, dynamic> resposta = json.decode(response.body);
        print(resposta["dados"]);
        if (!resposta["dados"].isEmpty) {
          return resposta["dados"];
        }
      } else {
        mensagemErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      mensagemErrorMessage("IP inválido ou problema na r (front ou back)");
    }
    return [];
  }

  // ------------------------------------------------------- Adicionar uma mensagem
  Future<String> _addMensagem(
      String ip, int user_id, String txt, int conversa_id) async {
    final url = Uri.parse('http://$ip:5000/add_mensagem');
    final now = DateTime.now().toLocal();
    final data = now.toString().substring(0, 19);

    // Dados enviados
    final dados = {
      'user_id': user_id,
      'txt': txt,
      'conversa_id': conversa_id,
      'data': data
    };

    if (txt == "" || txt == '') {
      print("texto vazio");
      return "";
    }

    // Mensagem de erro
    dynamic mensagemErrorMessage(String errorText) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Erro ao buscar mensagens",
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(errorText,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 192, 65, 55))),
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
          });
    }

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
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Resposta da requisição
        if (response.body == "ok") {
          return response.body;
        } else {
          print("oi");
        }
      } else {
        mensagemErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      mensagemErrorMessage(
          "IP inválido ou problema na requisição (front ou back)");
    }
    return "a";
  }

  Future<String> _getNomebyID(String ip, int user_id) async {
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
      print(response.body);
      Map<String, dynamic> resposta = json.decode(response.body);
      return resposta["dados"]["nome"];
    } catch (e) {
      print(e);
      return "Erro";
    }
  }
  //  -------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int id_conversa = arguments['id_conversa'] ?? -1;
    String ip = arguments['ip'] ?? -1;
    int id = arguments['id'] ?? -1;
    print("ip $ip");
    print("id $id");
    print("id conversa $id_conversa");
    return FutureBuilder(
        future: _getNomebyID(ip, id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: PreferredSize(
                  // Tamanho do AppBar
                  preferredSize: Size.fromHeight(60.0),
                  child: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 3,
                    leading: Padding(
                      // Leading é o ícone à esquerda do AppBar
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, bottom: 10, right: 1),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColorLight,
                          )),
                    ),
                    title: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          snapshot.data!,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight),
                        )),
                  ),
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    double containerWidth = constraints.maxWidth * 0.9;
                    double containerHeight = constraints.maxHeight - 184;
                    return Center(
                        child: Column(
                      children: [
                        Container(
                            child: FutureBuilder(
                                future: _getMensagens(ip, id_conversa),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Center(
                                      child: Column(children: [
                                        SizedBox(height: 10),
                                        LayoutBuilder(
                                            builder: (context, constraints) {
                                          return SizedBox(
                                            width: containerWidth,
                                            height: containerHeight,
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: snapshot.data![index]
                                                              ["user_id"] ==
                                                          id
                                                      ? const EdgeInsets.only(
                                                          left: 200, bottom: 20)
                                                      : const EdgeInsets.only(
                                                          right: 200,
                                                          bottom: 20),
                                                  child: FilledButton(
                                                    style:
                                                        FilledButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      backgroundColor: snapshot
                                                                          .data![
                                                                      index]
                                                                  ["user_id"] ==
                                                              id
                                                          ? Theme.of(context)
                                                              .cardColor
                                                          : Theme.of(context)
                                                              .highlightColor,
                                                      fixedSize: Size(122, 122),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      // TODO: Requisição
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5)),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                snapshot.data![
                                                                        index]
                                                                    ["txt"],
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                                  fontSize: 16,
                                                                ),
                                                              )
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
                                        })
                                      ]),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: constraints.maxWidth * 0.85,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextField(
                                    controller: _mensagemController,
                                    autofocus: false,
                                    autocorrect: false,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(context).cardColor,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 14),
                                      hintText: "Mensagem",
                                      hintStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 90,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () => setState(() {
                                          _addMensagem(
                                              ip,
                                              id,
                                              _mensagemController.text,
                                              id_conversa);
                                          _mensagemController.text = "";
                                        }),
                                    child: Text(
                                      "Enviar",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
                  },
                ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
