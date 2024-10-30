import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/pesquisa.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  List<Map<String, dynamic>> anuncios = [
    {
      "titulo": "Calça do Dário",
      "preço": 20,
      "imagem": 'assets/images/calca.jpeg'
    },
    {
      "titulo": "mmmmmmmmmmmmmmmmmmmmmmmmmmmm",
      "preço": 30,
      "imagem": 'assets/images/andaime.png'
    },
    {
      "titulo": "Calça do Dário 2",
      "preço": 20,
      "imagem": 'assets/images/calca.jpeg'
    },
    {"titulo": "Anúncio 3", "preço": 30, "imagem": 'assets/images/andaime.png'},
  ];

  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 150;
    double imageSize = cardHeight - 10;

    return Scaffold(
      appBar: PreferredSize(
        // Tamanho do AppBar
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 3,
          leading: Padding(
            // Leading é o ícone à esquerda do AppBar
            padding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 1),
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
              onTap: () {
                setState(() {
                  // TODO: Mudar animação de transição
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pesquisa()),
                  );
                });
              },
              readOnly: true,
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
              ),
            ),
          ),
          actions: [
            // Actions é o ícone à direita do AppBar
            Padding(
              padding: const EdgeInsets.only(
                  left: 1, top: 10, bottom: 10, right: 10),
              child: IconButton(
                padding: EdgeInsets.only(bottom: 1),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Card(
                      shape: CircleBorder(),
                      color: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("João do Poço",
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColorLight,
                          )),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 5),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Text("Histórico",
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColorLight,
              )),
          SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            double containerWidth = constraints.maxWidth * 0.9;

            return SizedBox(
              width: containerWidth,
              height: 490,
              child: ListView.builder(
                itemCount: anuncios.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(6),
                        backgroundColor: Theme.of(context).cardColor,
                        elevation: 3,
                        fixedSize: Size(cardWidth, cardHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implementar abrir anuncio
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              anuncios[index]["imagem"],
                              fit: BoxFit.contain,
                              height: imageSize,
                              width: imageSize,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  anuncios[index]["titulo"],
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "R\$${anuncios[index]["preço"]}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 55,
                                  child: Card(
                                    color: Colors.blue,
                                    child: Center(
                                      child: Text(
                                        "Ofertado",
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
        ],
      ),
    );
  }
}
