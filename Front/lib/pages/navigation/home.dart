import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/anuncio.dart';
import 'package:sistema_de_anuncios/pages/navigation/mensagens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  late List<Map<String, dynamic>> venda;
  late List<Map<String, dynamic>> busca;

  Future<void> _carregarAnuncios() async {
    // Simula a busca de dados (substitua pela sua lógica real)
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
        print(resposta);
        print("-------------------------");
        print(venda);
        print(busca);
        Map<String, List<Map<String, dynamic>>>? anuncios = {
          'venda': venda,
          'busca': busca,
        };
        print(anuncios);
        return anuncios;
      } else {
        print("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Lista de opções
  final List<String> options = [
    'Opção 1',
    'Opção 2',
  ];

  // Estado de seleção para cada opção
  late Map<String, bool> selectedOptions;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
    // Inicializa o estado de seleção (todas como não selecionadas)
    selectedOptions = {for (var option in options) option: false};
    _carregarAnuncios();
  }

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

  @override
  Widget build(BuildContext context) {
    double cardWidth = 150;
    double cardHeight = 251;
    double cardSpacing = 5;
    double imageSize = cardWidth;
    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: _isLoading
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
                          fixedSize:
                              WidgetStateProperty.all<Size>(Size(50, 50)),
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
                child: Column(
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
                        height: cardHeight + 6,
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
                                                  titulo: venda[index]
                                                      ["titulo"],
                                                  preco: venda[index]
                                                          ["preco"] ??
                                                      0.0,
                                                  imagem: venda[index]
                                                      ["imagem"],
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        venda[index]["imagem"] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  venda[index]["imagem"],
                                                  fit: BoxFit.contain,
                                                  height: imageSize,
                                                  width: imageSize,
                                                ))
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Image.asset(
                                                  'assets/images/image.png',
                                                  fit: BoxFit.contain,
                                                  height: imageSize - 20,
                                                  width: imageSize - 20,
                                                ),
                                              ),
                                        Divider(
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(
                                                  0.4), // Cor do divisor
                                          thickness: 1, // Espessura da linha
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
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "R\$${venda[index]["preco"]}",
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
                                            margin: EdgeInsets.only(bottom: 5),
                                            color: Color(0xFF134E6C),
                                            child: Center(
                                              child: Text(
                                                "Venda",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Theme.of(context)
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
                        height: cardHeight + 6,
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
                                                  titulo: busca[index]
                                                      ["titulo"],
                                                  preco: busca[index]
                                                          ["preco"] ??
                                                      0.0,
                                                  imagem: busca[index]
                                                      ["imagem"],
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        busca[index]["imagem"] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  busca[index]["imagem"],
                                                  fit: BoxFit.contain,
                                                  height: imageSize,
                                                  width: imageSize,
                                                ))
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Image.asset(
                                                  'assets/images/image.png',
                                                  fit: BoxFit.contain,
                                                  height: imageSize - 20,
                                                  width: imageSize - 20,
                                                ),
                                              ),
                                        Divider(
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(
                                                  0.2), // Cor do divisor
                                          thickness: 1, // Espessura da linha
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
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "R\$${busca[index]["preco"]}",
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
                                            margin: EdgeInsets.only(bottom: 5),
                                            color: Color(0xFF38524A),
                                            child: Center(
                                              child: Text(
                                                "Busca",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Theme.of(context)
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
                ),
              ),
            ),
    );
  }
}
