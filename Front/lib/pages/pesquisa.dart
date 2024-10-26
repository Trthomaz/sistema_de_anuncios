import 'package:flutter/material.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
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
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  padding: EdgeInsets.only(bottom: 1),
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).primaryColorLight),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )),
            title: Container(
              child: TextField(
                autofocus: true,
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
          ),
        ),
        body: Center(
          // TODO: Implementar a pesquisa com os filtros
          child: Text("Pesquisando..."),
        ));
  }
}
