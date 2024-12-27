import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _ipController = TextEditingController();

  // IP do servidor
  late String ip = _ipController.text;

  // Requisição de login
  Future<int> _login() async {
    final url = Uri.parse('http://${_ipController.text}:5000/login');

    // Dados enviados
    final dados = {
      'cpf': _cpfController.text,
      'senha': _senhaController.text,
    };

    // Mensagem de erro
    dynamic loginErrorMessage(String errorText) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Erro ao fazer login",
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(errorText,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 192, 65, 55))),
              actions: [
                ElevatedButton(
                  child: Text("Ok",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(1)),
                )
              ],
            );
          });
    }

    // Enviar requisição
    try {
      final response = await http.post(
        url,
        headers: {
          // Define o tipo de conteúdo como json
          'Content-Type': 'application/json'
        },
        body: json.encode(dados),
      );
      if (response.statusCode == 200) {
        // Resposta da requisição
        Map<String, dynamic> resposta = json.decode(response.body);
        print(response.statusCode);
        print(url);
        if (resposta['login'] == true) {
          return resposta['user_id'];
        } else {
          loginErrorMessage("Login ou senha inválidos");
        }
      } else {
        loginErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      loginErrorMessage("IP inválido, tente novamente");
    }
    return -1;
  }

  dynamic _ipDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              height: 50,
              width: 360,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text("Configurações de Desenvolvimento",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
              ),
            ),
            content: TextField(
              controller: _ipController,
              autofocus: false,
              autocorrect: false,
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
                fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                hintText: "IP",
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              ElevatedButton(
                child: Text("Ok",
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(1)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o teclado esta visivel
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        // Largura do textField baseados nas dimensões da tela
        double textFieldWidth = constraints.maxWidth * 0.9;

        return Padding(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 0),
          child: Column(
            children: [
              isKeyboardVisible // Verifica se o treclado está visível
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: IconButton(
                              highlightColor:
                                  Theme.of(context).primaryColorLight,
                              iconSize: 30,
                              icon: Icon(Icons.settings),
                              color: Theme.of(context).primaryColorLight,
                              onPressed: () {
                                _ipDialog();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
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
              isKeyboardVisible // Verifica se o treclado está visível
                  ? Container()
                  : SizedBox(
                      height: 100,
                    ),
              Padding(
                // CPF/Email
                padding: EdgeInsets.only(top: 50, bottom: 8.0),
                child: SizedBox(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _cpfController,
                    autofocus: false,
                    autocorrect: false,
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
                      hintText: "CPF/Email",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                // Senha
                padding: const EdgeInsets.only(top: 8.0, bottom: 30),
                child: SizedBox(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _senhaController,
                    autofocus: false,
                    autocorrect: false,
                    obscureText: true,
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
              Padding(
                // Botão
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Navigation(ip: "0", id: -1)),
                      );
                    },
                    onPressed: () async {
                      var entrar = await _login();
                      print(entrar);
                      print(_ipController.text);
                      if (entrar != -1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Navigation(ip: ip, id: entrar);
                        }));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      overlayColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColorLight.withOpacity(0.1)),
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
              //Texto inferior
              Align(
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
            ],
          ),
        );
      })),
    );
  }
}
