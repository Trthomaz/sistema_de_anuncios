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
  Future<bool> _login() async {
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
              title: Text("Erro ao fazer login"),
              content: Text(errorText),
              actions: [
                ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 241, 232, 232)))
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
        if (resposta['login'] == "true") {
          return true;
        } else {
          loginErrorMessage("Login ou senha inválidos");
        }
      } else {
        loginErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      loginErrorMessage("IP inválido, tente novamente");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o teclado esta visivel
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    bool invalidLogin = false;

    return PopScope(
      // Impede o uso do botão de voltar do celular para voltar para a tela de login
      canPop: false,
      child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        // Largura do textField baseados nas dimensões da tela
        double textFieldWidth = constraints.maxWidth * 0.9;

        return Padding(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 0),
          child: Center(
            child: Column(
              children: [
                isKeyboardVisible // Verifica se o treclado está visível
                    ? Container()
                    : SizedBox(
                        height: 100,
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
                  // CPF
                  padding: EdgeInsets.only(top: 50, bottom: 8.0),
                  child: SizedBox(
                    width: textFieldWidth,
                    child: TextField(
                      controller: _cpfController,
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
                        hintText: "CPF",
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
                  padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                  child: SizedBox(
                    width: textFieldWidth,
                    child: TextField(
                      controller: _senhaController,
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
                Padding(
                  // Botão
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        print("CPF: ${_cpfController.text}");
                        bool entrar = await _login();
                        if (entrar) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Navigation()),
                          );
                        } else {
                          invalidLogin = true;
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
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
                Padding(
                  // CPF
                  padding: EdgeInsets.only(
                      top: 190.0, bottom: 8.0, left: 80.0, right: 80.0),
                  child: SizedBox(
                    width: textFieldWidth,
                    child: TextField(
                      controller: _ipController,
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
                        hintText: "IP",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}
