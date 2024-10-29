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
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 3,
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
                autofocus: true,
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
          ),
        ),
        body: Center(
          // TODO: Implementar a pesquisa com os filtros
          child: Text("Pesquisando..."),
        ));
  }
}
