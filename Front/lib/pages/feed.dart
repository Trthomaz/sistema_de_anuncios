import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // Lista dos anuncios
  List<Map<String, dynamic>> anuncios = [
    {
      "titulo": "Calça do Dário",
      "preço": 20,
      "imagem": 'assets/images/calca.jpeg'
    },
    {"titulo": "Anúncio 2", "preço": 30, "imagem": 'assets/images/andaime.png'},
  ];

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // Tamanho do AppBar
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: Padding(
            // Leading é o ícone à esquerda do AppBar
            padding: const EdgeInsets.all(8.0),
            child: isSearching // Se está pesquisando, exibe o ícone de voltar
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                      });
                      print(isSearching);
                    },
                  )
                : Image.asset(
                    // Imagem do ícone do app
                    'assets/images/andaime.png',
                    fit: BoxFit.contain,
                    width: 20,
                    height: 20,
                  ),
          ),
          title: Container(
            padding: EdgeInsets.only(right: 30),
            child: TextField(
              onTap: () {
                setState(() {
                  isSearching = true;
                });
                print(isSearching);
              },
              autocorrect: false,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove a borda
                ),
                filled: true, // Para que o TextField tenha um fundo
                fillColor: Theme.of(context)
                    .cardColor
                    .withOpacity(0.1), // Cor de fundo do campo
                prefixIcon: Icon(
                  Icons.search,
                  size: 20, // Tamanho ajustado do ícone
                  color: Theme.of(context).primaryColorLight,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 14), // Espaçamento interno ajustado
                hintText: "Pesquisar",
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 3,
        ),
      ),
      body: isSearching
          ? Center(
              // Se está pesquisando, exibe a mensagem de "Pesquisando..."
              child: Text("Pesquisando..."),
            )
          : Center(
              // Se não está pesquisando, exibe o Feed
              child: LayoutBuilder(builder: (context, constraints) {
                // Largura do card baseados nas dimensões da tela
                double cardWidth = constraints.maxWidth * 0.46;
                double cardHeight = cardWidth + 100;
                double cardSpacing = constraints.maxWidth * 0.02;
                double imageSize = cardWidth;

                return ListView.builder(
                    itemCount: (anuncios.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      int id = index * 2;

                      int getId() {
                        if (id > anuncios.length - 2) {
                          id = -1;
                        }
                        return id;
                      }

                      return Column(children: [
                        SizedBox(
                          height: cardSpacing,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).cardColor, // Cor de fundo
                                elevation: 3, // Sombra do botão
                                fixedSize:
                                    Size(cardWidth, cardHeight), // Tamanho fixo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Ação do botão
                                print("Botão 1 clicado");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      anuncios[id]["imagem"],
                                      fit: BoxFit.contain,
                                      height: imageSize,
                                      width: imageSize,
                                    ),
                                    Text(
                                      anuncios[id]["titulo"] +
                                          "\n" +
                                          "R\$" +
                                          anuncios[id]["preço"].toString(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ), // Espaço entre os botões
                            SizedBox(width: cardSpacing),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).cardColor, // Cor de fundo
                                elevation: 3, // Sombra do botão
                                fixedSize:
                                    Size(cardWidth, cardHeight), // Tamanho fixo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Ação do botão
                                print("Botão 2 clicado");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      anuncios[getId() + 1]["imagem"],
                                      fit: BoxFit.contain,
                                      height: imageSize,
                                      width: imageSize,
                                    ),
                                    Text(
                                      anuncios[getId() + 1]["titulo"] +
                                          "\n" +
                                          "R\$" +
                                          anuncios[getId() + 1]["preço"]
                                              .toString(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: cardSpacing,
                        )
                      ]);
                    });
              }),
            ),
    );
  }
}
