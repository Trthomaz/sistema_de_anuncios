import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:sistema_de_anuncios/pages/navigation/anunciar.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/perfil.dart';
import 'package:sistema_de_anuncios/pages/navigation/configs.dart';
import 'package:sistema_de_anuncios/pages/pesquisa.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Lista dos anuncios
  List<Map<String, dynamic>> anuncios = [
    {
      "titulo": "Calça do Dário",
      "preço": 20,
      "imagem": 'assets/images/calca.jpeg'
    },
    {"titulo": "Anúncio 2", "preço": 30, "imagem": 'assets/images/andaime.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // Tamanho do AppBar
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 3,
          leading: Padding(
            // Leading é o ícone à esquerda do AppBar
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              // Imagem do ícone do app
              'assets/images/andaime.png',
              fit: BoxFit.contain,
              width: 20,
              height: 20,
            ),
          ),
          title: Container(
            child: TextField(
              onTap: () {
                setState(() {
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
                fontSize: 14,
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
                  size: 20,
                  color: Theme.of(context).primaryColorLight,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                hintText: "Pesquisar",
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          actions: [
            // Actions é o ícone à direita do AppBar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                padding: EdgeInsets.only(bottom: 1),
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  // TODO: Implementar pra abrir a tela de mensagens
                  print("Mensagem");
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
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
                          backgroundColor: Theme.of(context).cardColor,
                          elevation: 3,
                          fixedSize: Size(cardWidth, cardHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Implementar abrir anuncio
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
                                  color: Theme.of(context).primaryColorLight,
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
                          backgroundColor: Theme.of(context).cardColor,
                          elevation: 3,
                          fixedSize: Size(cardWidth, cardHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Implementar abrir anuncio
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
                                    anuncios[getId() + 1]["preço"].toString(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
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
