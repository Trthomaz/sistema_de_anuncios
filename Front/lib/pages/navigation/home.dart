import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/anuncio.dart';
import 'package:sistema_de_anuncios/pages/navigation/mensagens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class Home extends StatefulWidget {
  final String ip;
  final int id;

  const Home({super.key, required this.ip, required this.id});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String ip;
  late int id;
  bool _isLoading = true;
  bool pesquisa = false;
  TextEditingController _pesquisaController = TextEditingController();
  TextEditingController minPreco = TextEditingController();
  TextEditingController maxPreco = TextEditingController();

  late List<Map<String, dynamic>> venda;
  late List<Map<String, dynamic>> busca;
  late List<Map<String, dynamic>> anuncios;

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
    setState(() {
      _isLoading = true;
    });
    Map<String, List<Map<String, dynamic>>>? feed = await _feed();

    setState(() {
      if (feed == null) {
        venda = [];
        busca = [];
        return;
      }
      venda = feed['venda']!;
      busca = feed['busca']!;
      _isLoading = false;
    });
  }

  Future<void> _carregarPesquisa(txt) async {
    setState(() {
      _isLoading = true;
    });
    List<Map<String, dynamic>>? feed = await _pesquisar(txt);

    setState(() {
      if (feed == null) {
        anuncios = [];
        return;
      }
      anuncios = feed;
      _isLoading = false;
    });
  }

  Future<Map<String, List<Map<String, dynamic>>>?> _feed() async {
    final url = Uri.parse('http://${ip}:5000/get_feed');

    // Dados enviados
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
        final venda = resposta['dados']['venda'].cast<Map<String, dynamic>>();
        final busca = resposta['dados']['busca'].cast<Map<String, dynamic>>();
        Map<String, List<Map<String, dynamic>>>? anuncios = {
          'venda': venda,
          'busca': busca,
        };
        return anuncios;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> _pesquisar(txt) async {
    final url = Uri.parse('http://${ip}:5000/fazer_busca');

    int cat = -1;
    int tip = -1;

    if (categoria != null) {
      cat = categorias.indexOf(categoria!)+1;
    }
    if (tipo != null) {
      tip = tipos.indexOf(tipo!)+1;
    }
    if (minPreco.text == "") {
      minPreco.text = "0";
    }
    if (maxPreco.text == "") {
      maxPreco.text = "999999";
    }

    // Dados enviados
    final dados = {
      'user_id': id,
      'txt': txt,
      'categoria': cat,
      'tipo': tip,
      'preco_inicial': double.tryParse(minPreco.text),
      'preco_final': double.tryParse(maxPreco.text),
      'local': "-1",
    };

    // Enviar requisição
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dados),
      );
      if (response.statusCode == 200) {
        // Resposta da requisição
        final resposta = json.decode(response.body);
        final anuncios =
            resposta['dados']['anuncios'].cast<Map<String, dynamic>>();
        return anuncios;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  final List<String> categorias = [
    'Serviço',
    'Produto',
  ];

  final List<String> tipos = [
    'Venda',
    'Busca',
  ];

  String? categoria;
  String? tipo;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
    _carregarAnuncios();
  }

  void _categorias() {
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
                    child: Text("Categorias",
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColorLight,
                        )),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: SingleChildScrollView(
                child: Column(
                  children: categorias.map((String option) {
                    return RadioListTile<String>(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(option),
                      value: option,
                      groupValue: categoria,
                      onChanged: (String? value) {
                        setDialogState(() {
                          categoria = value; // Atualiza a opção selecionada
                        });
                      },
                    );
                  }).toList(),
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
  }

  void _tipos() {
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
                    child: Text("Tipos de Anúncio",
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColorLight,
                        )),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: SingleChildScrollView(
                child: Column(
                  children: tipos.map((String option) {
                    return RadioListTile<String>(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(option),
                      value: option,
                      groupValue: tipo,
                      onChanged: (String? value) {
                        setDialogState(() {
                          tipo = value; // Atualiza a opção selecionada
                        });
                      },
                    );
                  }).toList(),
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
  }

  void _precos() {
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
                    child: Text("Preço",
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColorLight,
                        )),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: minPreco,
                    autofocus: false,
                    autocorrect: false,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      hintText: "Preço mínimo",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: maxPreco,
                    autofocus: false,
                    autocorrect: false,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      hintText: "Preço máximo",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
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
  }

  void _filtroDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              height: 60,
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
            content: SizedBox(
              height: 170,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 250,
                    child: FilledButton(
                      onPressed: () {
                        _categorias();
                      },
                      child: Text(
                        "Categorias",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    child: FilledButton(
                      onPressed: () {
                        _tipos();
                      },
                      child: Text("Tipos de Anúncio",
                          style: TextStyle(fontSize: 20)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    child: FilledButton(
                      onPressed: () {
                        _precos();
                      },
                      child: Text("Preço", style: TextStyle(fontSize: 20)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    double verticalCardWidth = 150;
    double verticalCardHeight = 273;
    double horizontalCardWidth = 400;
    double horizontalCardHeight = 150;
    double cardSpacing = 5;
    double verticalImageSize = verticalCardWidth;
    double horizontalImageSize = horizontalCardHeight;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
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
                    controller: _pesquisaController,
                    onSubmitted: (txt) {
                      _carregarPesquisa(txt);
                      setState(() {
                        pesquisa = true;
                      });
                    },
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
                actions: [
                  // Actions é o ícone à direita do AppBar
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 1, top: 2, bottom: 1, right: 10),
                    child: IconButton(
                      padding: EdgeInsets.only(bottom: 1),
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all<Size>(Size(50, 50)),
                      ),
                      icon: Icon(
                        Icons.message_rounded,
                        color: Theme.of(context).primaryColorLight,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Mensagens(id: id, ip: ip)));
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
                child: !pesquisa
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 46,
                            width: double.infinity,
                            child: Card(
                              color: Color(0xFF134E6C),
                              child: Center(
                                child: Text(
                                  "Venda",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            return SizedBox(
                              height: verticalCardHeight + 6,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: venda.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: cardSpacing,
                                        ),
                                        FilledButton(
                                          style: FilledButton.styleFrom(
                                            padding: EdgeInsets.all(4),
                                            backgroundColor:
                                                Theme.of(context).cardColor,
                                            fixedSize:
                                                Size(verticalCardWidth, verticalCardHeight),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            print(venda[index]["anuncio_id"]);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Anuncio(
                                                    ip: ip,
                                                    anuncioId: venda[index]
                                                        ["anuncio_id"],
                                                    userId: id,
                                                  ),
                                                ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              venda[index]["imagem"] != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.memory(
                                                        decodificar(venda[index]
                                                            ["imagem"])!,
                                                        fit: BoxFit.contain,
                                                        height: verticalImageSize,
                                                        width: verticalImageSize,
                                                      ))
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Image.asset(
                                                        'assets/images/image.png',
                                                        fit: BoxFit.contain,
                                                        height: verticalImageSize - 20,
                                                        width: verticalImageSize - 20,
                                                      ),
                                                    ),
                                              Divider(
                                                color: Theme.of(context)
                                                    .primaryColorLight
                                                    .withOpacity(
                                                        0.4), // Cor do divisor
                                                thickness:
                                                    1, // Espessura da linha
                                                height:
                                                    4, // Espaço vertical ao redor do divisor
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      venda[index]["titulo"],
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "R\$${venda[index]["preco"].toStringAsFixed(2)}",
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                                width: 40,
                                                child: Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: cardSpacing,
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          }),
                          SizedBox(
                            height: 46,
                            width: double.infinity,
                            child: Card(
                              color: Color(0xFF38524A),
                              child: Center(
                                child: Text(
                                  "Busca",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            return SizedBox(
                              height: verticalCardHeight + 6,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: busca.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: cardSpacing,
                                        ),
                                        FilledButton(
                                          style: FilledButton.styleFrom(
                                            padding: EdgeInsets.all(4),
                                            backgroundColor:
                                                Theme.of(context).cardColor,
                                            fixedSize:
                                                Size(verticalCardWidth, verticalCardHeight),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Anuncio(
                                                    ip: ip,
                                                    anuncioId: busca[index]
                                                        ["anuncio_id"],
                                                    userId: id,
                                                  ),
                                                ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              busca[index]["imagem"] != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.memory(
                                                        decodificar(busca[index]
                                                            ["imagem"])!,
                                                        fit: BoxFit.contain,
                                                        height: verticalImageSize,
                                                        width: verticalImageSize,
                                                      ))
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Image.asset(
                                                        'assets/images/image.png',
                                                        fit: BoxFit.contain,
                                                        height: verticalImageSize - 20,
                                                        width: verticalImageSize - 20,
                                                      ),
                                                    ),
                                              Divider(
                                                color: Theme.of(context)
                                                    .primaryColorLight
                                                    .withOpacity(
                                                        0.2), // Cor do divisor
                                                thickness:
                                                    1, // Espessura da linha
                                                height:
                                                    4, // Espaço vertical ao redor do divisor
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      busca[index]["titulo"],
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "R\$${busca[index]["preco"].toStringAsFixed(2)}",
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                                width: 40,
                                                child: Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: cardSpacing,
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          }),
                        ],
                      )
                    : SizedBox(
                        height: 800,
                        child: LayoutBuilder(builder: (context, constraints) {
                          double containerWidth = constraints.maxWidth * 0.9;
                          double containerHeight = constraints.maxHeight - 94;
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                LayoutBuilder(builder: (context, constraints) {
                                  return SizedBox(
                                    width: containerWidth,
                                    height: containerHeight,
                                    child: ListView.builder(
                                      itemCount: anuncios.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              padding: EdgeInsets.all(6),
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              fixedSize:
                                                  Size(horizontalCardWidth, horizontalCardHeight),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Anuncio(
                                                      ip: ip,
                                                      anuncioId: anuncios[index]
                                                          ["anuncio_id"],
                                                      userId: id,
                                                    ),
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: anuncios[index]
                                                              ["imagem"] !=
                                                          null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.memory(
                                                            decodificar(
                                                                anuncios[index][
                                                                    "imagem"])!,
                                                            fit: BoxFit.contain,
                                                            height: horizontalImageSize,
                                                            width: horizontalImageSize,
                                                          ))
                                                      : Icon(
                                                          Icons.image_rounded,
                                                          size: horizontalImageSize,
                                                          color: Theme.of(
                                                                  context)
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        anuncios[index]
                                                            ["titulo"],
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        "R\$${anuncios[index]["preco"].toStringAsFixed(2)}",
                                                        softWrap: true,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: 15,
                                                          width: 40,
                                                          child: anuncios[index]
                                                                      [
                                                                      "tipo"] ==
                                                                  1
                                                              ? Card(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  color: Color(
                                                                      0xFF134E6C),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Venda",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          color:
                                                                              Theme.of(context).primaryColorLight),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Card(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  color: Color(
                                                                      0xFF38524A),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Busca",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          color:
                                                                              Theme.of(context).primaryColorLight),
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
                        }),
                      )),
          );
  }
}
