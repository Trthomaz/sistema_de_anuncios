import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/login.dart';

class Configs extends StatefulWidget {
  const Configs({super.key});

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: PreferredSize(
          // Tamanho do AppBar
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 3,
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColorLight,
              size: 30,
            ),
            title: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  "Configurações",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 26),
                )),
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          double buttonWidth = constraints.maxWidth;
          double buttonHeight = 40;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Termos de Uso
              FilledButton(
                  onPressed: () {
                    // Todo: Implementar a tela de termos de uso
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).cardColor,
                    fixedSize: Size(buttonWidth, buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Borda reta (90 graus)
                    ),
                    overlayColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Termos de uso",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )),
              Divider(
                color: Theme.of(context).scaffoldBackgroundColor,
                thickness: 2,
                height: 2,
              ),
              // Sair
              FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).cardColor,
                    fixedSize: Size(buttonWidth, buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Borda reta (90 graus)
                    ),
                    overlayColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Sair",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )),
              Divider(
                color: Theme.of(context).scaffoldBackgroundColor,
                thickness: 2,
                height: 2,
              ),
            ],
          );
        }));
  }
}
