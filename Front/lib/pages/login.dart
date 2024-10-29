import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/home.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      // Largura do card baseados nas dimensões da tela
      double buttonWidth = constraints.maxWidth * 0.9;
      double buttonHeigh = 200;

      return Padding(
        padding:
            const EdgeInsets.only(top: 150.0, left: 30, right: 30, bottom: 20),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                // Imagem do ícone do app
                'assets/images/andaime.png',
                fit: BoxFit.contain,
                width: 80,
                height: 80,
              ),
/*               Text(
                "Andaime",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 60,
                ),
              ), */
              Padding(
                // Email
                padding: const EdgeInsets.only(top: 150.0, bottom: 8.0),
                child: Container(
                  child: SizedBox(
                    width: buttonWidth,
                    child: TextField(
                      autofocus: false,
                      autocorrect: false,
                      cursorColor: Theme.of(context).primaryColorLight,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                // Senha
                padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                child: Container(
                  child: SizedBox(
                    width: buttonWidth,
                    child: TextField(
                      autofocus: false,
                      autocorrect: false,
                      obscureText: true,
                      cursorColor: Theme.of(context).primaryColorLight,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Senha",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                // Botão
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar a autenticação
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Navigation()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor.withOpacity(1)),
                    ),
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorLight),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Em caso de dúvidas, entre em contato com o email:",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text("sti@ic.uff.br", style: TextStyle(fontSize: 12)),
                      ],
                    ), //Your widget here,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }));
  }
}
