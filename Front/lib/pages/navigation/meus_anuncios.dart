import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  List<Map<String, dynamic>> venda = [
    {"titulo": "Calça", "preço": 60, "imagem": 'assets/images/calca.jpeg'},
    {
      "titulo": "Garrafa Térmica",
      "preço": 30,
      "imagem": 'assets/images/garrafa.jpeg'
    },
    {"titulo": "Mouse", "preço": 15, "imagem": 'assets/images/mouse.jpeg'},
    {"titulo": "Aula de história", "preço": 50, "imagem": null},
    {"titulo": "Aula de matemática", "preço": 60, "imagem": null},
  ];
  
  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 150;
    double imageSize = cardHeight - 10;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                "Meus Anúncios",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
            double containerWidth = constraints.maxWidth * 0.9;
            double containerHeight = constraints.maxHeight - 78;
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: containerWidth,
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
                    fillColor: Theme.of(context).cardColor,
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
                  SizedBox(height: 10),
                  LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      width: containerWidth,
                      height: containerHeight,
                      child: ListView.builder(
                        itemCount: venda.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
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
                                    child: venda[index]["imagem"] != null
                                        ? Image.asset(
                                            venda[index]["imagem"],
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
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                        SizedBox(
                                          height: 15,
                                          width: 40,
                                          child: Card(
                                            margin: EdgeInsets.all(0),
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
          })
    );
  }
}
