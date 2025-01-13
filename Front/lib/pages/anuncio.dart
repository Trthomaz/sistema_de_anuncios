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
  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Selecione as opções'),
              content: SingleChildScrollView(
                child: Column(
                  children: options.map((String option) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: selectedOptions[option],
                      onChanged: (bool? value) {
                        setDialogState(() {
                          selectedOptions[option] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    setState(() {}); // Atualiza o estado principal
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
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

  void _filtroDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              height: 50,
              width: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text("Filtro",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
              ),
            ),
            content: FilledButton(
                onPressed: () {
                  _showMultiSelectDialog();
                },
                child: Text("Categorias")),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              ElevatedButton(
                child: Text("Ok",
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight)),
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

  // Categoria
  List<String> categorias = [];
  final List<String> lista_categorias = ['Opção 1', 'Opção 2', 'Opção 3'];

  // Lista de opções
  final List<String> options = ['Opção 1', 'Opção 2', 'Opção 3', 'Opção 4'];

  // Estado de seleção para cada opção
  late Map<String, bool> selectedOptions;

  @override
  void initState() {
    super.initState();
    // Inicializa o estado de seleção (todas como não selecionadas)
    selectedOptions = {for (var option in options) option: false};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAnunciobyID(widget.ip, widget.anuncioId),
        builder: (context, snapshot_anuncio) {
          if (snapshot_anuncio.hasData) {
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
                      padding: const EdgeInsets.all(1),
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
                          fillColor:
                              Theme.of(context).cardColor.withOpacity(0.1),
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.tune, // filter_list ou filter_alt ou tune
                              size: 22,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            onPressed: () {
                              _filtroDialog();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: LayoutBuilder(builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth - 20;
                  double containerHeight = constraints.maxHeight - 123;
                  double imagem = constraints.maxHeight - 500;
                  return LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        children: [
                          SizedBox(
                            height: containerHeight,
                            child: SingleChildScrollView(
                            child: Column(
                          children: [
                            SizedBox(height: 10),
                            Center(
                              child: snapshot_anuncio.data!["imagem"] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        decodificar(
                                            snapshot_anuncio.data!["imagem"])!,
                                        fit: BoxFit.contain,
                                        height: imagem,
                                        width: imagem,
                                      ))
                                  : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                        'assets/images/image.png',
                                        fit: BoxFit.contain,
                                        height: imagem - 50,
                                        width: imagem - 50,
                                      ),
                                  )
                            ),
                            Divider(
                                    color: Theme.of(context).primaryColorLight,
                                    thickness: 1,
                                    height: 10,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                      snapshot_anuncio.data!["titulo"],
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColorLight,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                      "R\$ ${snapshot_anuncio.data!["preco"].toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColorLight,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColorLight,
                                  thickness: 1,
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                      "Descrição",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColorLight,
                                        fontSize: 30,
                                      ),
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
                                        color: Theme.of(context).primaryColorLight,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                                            ),
                                              )
                          ),
                          Divider(
                              color: Theme.of(context).primaryColorLight,
                              thickness: 1,
                              height: 1,
                            ),
                            FutureBuilder(
                                future: _getPerfil(widget.ip,
                                    snapshot_anuncio.data!["anunciante_id"]),
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
                                future: _getPerfil(widget.ip,
                                    snapshot_anuncio.data!["anunciante_id"]),
                                builder: (context, snapshot3) {
                                  if (snapshot3.hasData) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 10, right: 10),
                                        child: RatingBarIndicator(
                                          rating: snapshot3.data!["reputacao"],
                                          itemBuilder: (context, index) => Icon(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                      future: _criarConversa(
                                          widget.ip,
                                          snapshot_anuncio
                                              .data!["anunciante_id"],
                                          widget.userId),
                                      builder: (context, snapshot_conversa) {
                                        if (snapshot_conversa.hasData) {
                                          return Container(
                                            height: 40,
                                            width: constraints.maxWidth / 2 - 20,
                                            child: ElevatedButton(
                                              onPressed: () => {
                                                setState(() {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return const Chat();
                                                          },
                                                          settings:
                                                              RouteSettings(
                                                                  arguments: {
                                                                'id_conversa':
                                                                    snapshot_conversa
                                                                        .data!,
                                                                'ip': widget.ip,
                                                                'id': snapshot_anuncio.data![
                                                                            "anunciante_id"] ==
                                                                        widget
                                                                            .userId
                                                                    ? snapshot_anuncio
                                                                            .data![
                                                                        "interessado_id"]
                                                                    : snapshot_anuncio
                                                                            .data![
                                                                        "anunciante_id"]
                                                              })));
                                                })
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(1)),
                                              child: Text("Enviar Mensagem",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorLight)),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Container(
                                      height: 40,
                                      width: constraints.maxWidth / 2 - 20,
                                      child: ElevatedButton(
                                        onPressed: () => {
                                          setState(() {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Perfil(
                                                ip: widget.ip,
                                                id: snapshot_anuncio
                                                    .data!["anunciante_id"],
                                                ondeEntrou: "Anuncio",
                                              );
                                            }));
                                          })
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
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
                                SizedBox(height: 10,)
                        ],
                      );
                });}));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
