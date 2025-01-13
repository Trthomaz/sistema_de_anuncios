import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/chat.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mensagens extends StatefulWidget {
  final String ip;
  final int id;
  const Mensagens({super.key, required this.id, required this.ip});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  late String ip;
  late int id;

  TextEditingController _buscaController = TextEditingController();

  Future<List<dynamic>> _getConversas() async {
    final url = Uri.parse('http://$ip:5000/get_conversas');

    // Dados enviados
    final dados = {
      'user_id': id,
    };

    // Mensagem de erro
    dynamic conversaErrorMessage(String errorText) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Erro ao buscar conversas",
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
        if (!resposta["dados"]["conversas"].isEmpty) {
          return resposta["dados"]["conversas"];
        } else {
          conversaErrorMessage("ID inválido");
        }
      } else {
        conversaErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      conversaErrorMessage("IP inválido");
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;
    ip = widget.ip;
/*     WidgetsBinding.instance.addPostFrameCallback((_) {
      _setConversa();
    }); */
  }

  @override
  Widget build(BuildContext context) {
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
                  "Mensagens",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
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
                        future: _getConversas(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: Column(children: [
                                SizedBox(height: 10),
                                LayoutBuilder(builder: (context, constraints) {
                                  return SizedBox(
                                    width: containerWidth,
                                    height: containerHeight,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              padding: EdgeInsets.all(6),
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              fixedSize: Size(122, 122),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              print(snapshot.data!);
                                              setState(() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return const Chat();
                                                        },
                                                        settings: RouteSettings(
                                                            arguments: {
                                                              'id_conversa':
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      "conversa_id"],
                                                              'ip': ip,
                                                              'id': snapshot.data![
                                                                              index][
                                                                          "anunciante_id"] ==
                                                                      id
                                                                  ? snapshot.data![
                                                                          index]
                                                                      [
                                                                      "interessado_id"]
                                                                  : snapshot.data![
                                                                          index]
                                                                      [
                                                                      "anunciante_id"]
                                                            })));
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      snapshot.data![index][
                                                                  "anunciante_id"] ==
                                                              id
                                                          ? Text(
                                                              snapshot.data![
                                                                      index][
                                                                  "interessado_nome"],
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight,
                                                                fontSize: 16,
                                                              ),
                                                            )
                                                          : Text(
                                                              snapshot.data![
                                                                      index][
                                                                  "anunciante_nome"],
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight,
                                                                fontSize: 16,
                                                              ),
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
              ],
            ));
          },
        ));
  }
}
