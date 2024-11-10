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
    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(
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
                  padding: const EdgeInsets.all(1),
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
                SizedBox(
                  height: 10,
                ),
                FilledButton(
                    onPressed: () {
                      // Todo: Implementar a tela de termos de uso
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        fixedSize: Size(buttonWidth, buttonHeight)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Termos de uso",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        fixedSize: Size(buttonWidth, buttonHeight)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Sair",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          })),
    );
  }
}
