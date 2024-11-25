import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  List<Map<String, dynamic>> anuncios = [
    {
      "item": "Cachecol",
      "cliente": "Garota que mora logo ali",
      "tipoAnuncio": "Venda"
    },
    {"item": "Aula de Inglês", "cliente": "Poliglota", "tipoAnuncio": "Busca"},
    {
      "item": "Comandante Miniatura",
      "cliente": "Rei João VI",
      "tipoAnuncio": "Busca"
    },
  ];

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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    onTap: () {
                      // TODO
                    },
                    readOnly: true,
                    autocorrect: false,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
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
                      itemCount: anuncios.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.all(6),
                              backgroundColor: Theme.of(context).cardColor,
                              fixedSize: Size(122, 122),
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
                                Padding(padding: const EdgeInsets.all(5)),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        anuncios[index]["cliente"],
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
                                        anuncios[index]["item"],
                                        softWrap: true,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 22,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                        width: 40,
                                        child: Card(
                                          margin: EdgeInsets.all(0),
                                          color: anuncios[index]
                                                      ["tipoAnuncio"] ==
                                                  "Venda"
                                              ? Color(0xFF38524A)
                                              : Color(0xFF134E6C),
                                          child: Center(
                                            child: Text(
                                              anuncios[index]["tipoAnuncio"],
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
                })
              ],
            ));
          },
        ));
  }
}
