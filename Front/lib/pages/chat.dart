import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _mensagemController = TextEditingController();
  ScrollController _listViewController = ScrollController();
  int jaEntrou = 0;
  int mensagemNova = 0;
  bool saiuDaPagina = false;
  late Timer _timer;

  void _scrollDown() {
    if ((jaEntrou == 0) | (mensagemNova == 1)) {
      if (_listViewController.hasClients) {
        _listViewController.jumpTo(
          _listViewController.position.maxScrollExtent,
        );
        jaEntrou = 1;
        mensagemNova = 0;
      }
    }
  }

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
      Map<String, dynamic> resposta = json.decode(response.body);
      if (response.statusCode == 200) {
        // Resposta da requisição
        mensagemNova = 1;
        if (resposta["dados"]["msg"] == "ok") {
          print("Mensagem Adicionada com Sucesso!");
        } else {
          print("Falha na inserção da mensagem");
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
      Map<String, dynamic> resposta = json.decode(response.body);
      return resposta["dados"]["nome"];
    } catch (e) {
      print(e);
      return "Erro";
    }
  }
  //  -------------------------------------------------------------------------------------------------------------------------------------------

/*   @override

  void _initState(){
    super.initState();

    // Inicia o Timer para fazer uma requisição a cada 1 segundo
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter < 5) { // Limita o número de requisições, altere conforme necessário
        _makeRequest();
      } else {
        _timer.cancel(); // Cancela o Timer após 5 requisições
      }
      _counter++;
    });
  }
 */

  @override
  void initState() {
    super.initState();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (!mounted) return; // Verifica se o widget ainda está montado
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela o timer ao destruir o widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    int id_conversa = arguments['id_conversa'] ?? -1;
    String ip = arguments['ip'] ?? -1;
    int id = arguments['id'] ?? -1;

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
                    double containerHeight = constraints.maxHeight - 90;
                    return Center(
                        child: Column(
                      children: [
                        Container(
                            child: FutureBuilder(
                                future: _getMensagens(ip, id_conversa),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _scrollDown();
                                    });
                                    return Center(
                                      child: Column(children: [
                                        SizedBox(height: 10),
                                        LayoutBuilder(
                                            builder: (context, constraints) {
                                          return SizedBox(
                                            width: containerWidth,
                                            height: containerHeight,
                                            child: ListView.builder(
                                              controller: _listViewController,
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
                                                  child: Card(
                                                    color: snapshot.data![index]
                                                                ["user_id"] ==
                                                            id
                                                        ? Theme.of(context)
                                                            .cardColor
                                                        : Theme.of(context)
                                                            .highlightColor,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5)),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 8,
                                                                        right:
                                                                            12,
                                                                        top: 8),
                                                                child: Text(
                                                                  snapshot.data![
                                                                          index]
                                                                      ["txt"],
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 100,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorLight,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            4),
                                                                child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index][
                                                                            "date"]
                                                                        .toString()
                                                                        .substring(
                                                                            5, 22),
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColorLight,
                                                                        fontSize:
                                                                            12)),
                                                              ),
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: SizedBox(
                                  width: constraints.maxWidth - 128,
                                  height: 50,
                                  child: TextField(
                                    controller: _mensagemController,
                                    autofocus: false,
                                    autocorrect: false,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 14,
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
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
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
                                          fontSize: 14,
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
