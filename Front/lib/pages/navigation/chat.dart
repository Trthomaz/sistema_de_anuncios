import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _messageController = TextEditingController();

  // Lista viria de requisição com os dados
  List<Map<String, dynamic>> anuncios = [
    {
      "id": 1,
      "item": "Cachecol",
      "cliente": "Garota que mora logo ali",
      "tipoAnuncio": "Venda"
    },
    {
      "id": 2,
      "item": "Aula de Inglês",
      "cliente": "Poliglota",
      "tipoAnuncio": "Busca"
    },
    {
      "id": 3,
      "item": "Comandante Miniatura",
      "cliente": "Rei João VI",
      "tipoAnuncio": "Busca"
    },
  ];
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    int id = arguments['id'] ?? -1;
    print(id);
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
                  "Chat",
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
                SizedBox(height: 10),
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                      width: containerWidth,
                      height: containerHeight,
                      child: Padding(
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
                            print(id);
                            // TODO: Requisição
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.all(5)),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      anuncios[id]["cliente"],
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      anuncios[id]["item"],
                                      softWrap: true,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                      width: 40,
                                      child: Card(
                                        margin: EdgeInsets.all(0),
                                        color: anuncios[id]["tipoAnuncio"] ==
                                                "Venda"
                                            ? Color(0xFF38524A)
                                            : Color(0xFF134E6C),
                                        child: Center(
                                          child: Text(
                                            anuncios[id]["tipoAnuncio"],
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
                      ));
                })
              ],
            ));
          },
        ));
  }
}
