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
    {
      "titulo": "Nome muitooooooooooo oooooooooooo grandeeeeeeeeeee eeeeeee",
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

  String limitarTexto(String text) {
    int maxLenght = 34;
    if (text.length > maxLenght) {
      return text.substring(0, maxLenght) + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Largura da tela
    double screenHeight = MediaQuery.of(context).size.height; // Altura da tela
    // Largura do card baseados nas dimensões da tela
    double cardWidth = screenWidth * 0.46;
    double cardHeight = screenHeight * 0.35;
    double cardSpacing = screenWidth * 0.02;
    double imageSize = cardWidth;
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
                  print("Mensagem");
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: cardHeight + 10,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: anuncios.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: cardSpacing,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(4),
                              backgroundColor: Theme.of(context).cardColor,
                              elevation: 3,
                              fixedSize: Size(cardWidth, cardHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Implementar abrir anuncio
                              print(cardHeight);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  anuncios[index]["imagem"],
                                  fit: BoxFit.contain,
                                  height: imageSize,
                                  width: imageSize,
                                ),
                                Text(
                                  limitarTexto(anuncios[index]["titulo"]),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "R\$" + anuncios[index]["preço"].toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 22,
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
    );
  }
}
