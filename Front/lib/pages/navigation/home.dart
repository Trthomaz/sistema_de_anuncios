import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/pesquisa.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Lista dos anuncios
  List<Map<String, dynamic>> venda = [
    {"titulo": "Calça", "preço": 60, "imagem": 'assets/images/calca.jpeg'},
    {
      "titulo": "Garrafa Térmica",
      "preço": 30,
      "imagem": 'assets/images/garrafa.jpeg'
    },
    {"titulo": "Mouse", "preço": 15, "imagem": 'assets/images/mouse.jpeg'},
    {"titulo": "Aula de história", "preço": 50, "imagem": null},
  ];

  List<Map<String, dynamic>> busca = [
    {"titulo": "Teclado", "preço": 30, "imagem": 'assets/images/teclado.jpeg'},
    {
      "titulo": "Mesa",
      "preço": 70,
      "imagem": 'assets/images/mesa.jpeg',
    },
    {"titulo": "Calculadora", "preço": 20, "imagem": null},
    {"titulo": "Cadeira", "preço": 40, "imagem": null},
  ];

  @override
  Widget build(BuildContext context) {
    double cardWidth = 150;
    double cardHeight = 251;
    double cardSpacing = 5;
    double imageSize = cardWidth;
    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(
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
                    onPressed: () {},
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
                    // TODO: Implementar pra abrir a tela de mensagens
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
                                backgroundColor: Theme.of(context).cardColor,
                                fixedSize: Size(cardWidth, cardHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Implementar abrir anuncio
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.all(10),
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
                                        .withOpacity(0.4), // Cor do divisor
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
                                          "R\$${venda[index]["preço"]}",
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
                                backgroundColor: Theme.of(context).cardColor,
                                fixedSize: Size(cardWidth, cardHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Implementar abrir anuncio
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.all(10),
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
                                        .withOpacity(0.2), // Cor do divisor
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
                                          "R\$${busca[index]["preço"]}",
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
