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
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 150.0, left: 45, right: 45, bottom: 20),
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
                padding: const EdgeInsets.only(top: 150.0, bottom: 8.0),
                child: Container(
                  child: SizedBox(
                    width: 700,
                    child: TextField(
                      autofocus: true,
                      autocorrect: false,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 25,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 25,
                        ),
                        icon: Icon(
                          Icons.email,
                          size: 20,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                child: Container(
                  child: SizedBox(
                    width: 700,
                    child: TextField(
                      autofocus: true,
                      autocorrect: false,
                      obscureText: true,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 128, 141, 148),
                        fontSize: 25,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Senha",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 25,
                        ),
                        icon: Icon(
                          Icons.key,
                          size: 20,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Navigation()),
                      );
                    },
                    style: ButtonStyle(),
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 20),
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
                          style: TextStyle(fontSize: 15),
                        ),
                        Text("sti@ic.uff.br", style: TextStyle(fontSize: 15)),
                      ],
                    ), //Your widget here,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
