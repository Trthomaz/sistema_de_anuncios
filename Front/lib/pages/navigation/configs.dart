import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/login.dart';
import 'package:sistema_de_anuncios/pages/pesquisa.dart';

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
          body: LayoutBuilder(builder: (context, constraints) {
            double buttonWidth = constraints.maxWidth;
            double buttonHeight = 30;
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
                            color: Theme.of(context).primaryColorLight,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Termos de uso",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )),
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
                            color: Theme.of(context).primaryColorLight,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Sair",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 18,
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
