import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_de_anuncios/pages/navigation/home.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Anunciar extends StatefulWidget {
  // IP do servidor
  final String ip;

  const Anunciar({
    super.key,
    required this.ip,
  });

  @override
  State<Anunciar> createState() => _AnunciarState();
}

class _AnunciarState extends State<Anunciar> {
  late String ip;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
  }

  final PageStorageBucket _bucket = PageStorageBucket();
  // TextEditingControllers
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _cepController = TextEditingController();

  // Imagem
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Categoria e Tipo de Anuncio selecionados
  String? categoria;
  String? tipo;

  List<String> categorias = ["Opção 1", "Opção 2", "Opção 3"];
  List<String> tipos = ["Busca", "Venda"];

  // Requisição de login
  Future<bool> _anunciar() async {
    final url = Uri.parse('http://$ip:5000/criar_anuncio');

    // Dados enviados
    final dados = {
      'titulo': _tituloController.text,
      'descricao': _descricaoController.text,
      'tipo_anuncio': tipo,
      'categoria': categoria,
      'preco': _precoController.text,
      'celular': _celularController.text,
      'cep': _cepController.text
    };

    // Mensagem de erro
    dynamic anunciarErrorMessage(String errorText) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Erro ao criar anúncio",
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
        if (resposta["status"] == "true") {
          return true;
        } else {
          anunciarErrorMessage("Campos Inválidos");
        }
      } else {
        anunciarErrorMessage("Erro na comunicação, tente novamente mais tarde");
      }
    } catch (e) {
      print(e);
      anunciarErrorMessage("IP inválido, tente novamente");
    }
    return false;
  }

  Future<void> _pickImage() async {
    // Exibe um diálogo para escolher entre câmera ou galeria
    final pickedSource = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tirar Foto'),
              onTap: () => Navigator.pop(context, 0), //Camera
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Escolher da Galeria'),
              onTap: () => Navigator.pop(context, 1), //Galeria
            ),
          ],
        );
      },
    );

    if (pickedSource == null) return;

    final ImageSource source =
        pickedSource == 0 ? ImageSource.camera : ImageSource.gallery;

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                "Anunciar",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: [
                  // Título
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _tituloController,
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
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Título",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Descrição
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                      controller: _descricaoController,
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
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Descrição",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Imagem
                  LayoutBuilder(builder: (context, constraints) {
                    double size =
                        constraints.maxWidth * 0.7; // Altura da imagem
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _selectedImage != null
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navega para a tela de visualização da imagem
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                            imageFile: _selectedImage!),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _selectedImage!,
                                      width: size,
                                      height: size,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FilledButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    fixedSize: Size(double.infinity, 50),
                                    padding: EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.attach_file,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Substituir imagem",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : FilledButton(
                              onPressed: () {
                                _pickImage();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                                fixedSize: Size(double.infinity, 50),
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Escolher imagem",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  }),
                  // Tipo de Anúncio
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      child: DropdownButton<String>(
                        underline: Container(),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        isDense: true,
                        isExpanded: true,
                        value: tipo,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                        ),
                        iconSize: 50,
                        iconEnabledColor: Theme.of(context).primaryColorLight,
                        menuWidth: double.infinity,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Theme.of(context).cardColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            tipo = newValue;
                          });
                        },
                        items:
                            tipos.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == "Venda"
                                ? SizedBox(
                                    height: 40,
                                    child: Card(
                                      color: Color(0xFF134E6C),
                                      child: Center(
                                        child: Text(
                                          "Venda",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 40,
                                    child: Card(
                                      color: Color(0xFF38524A),
                                      child: Center(
                                        child: Text(
                                          "Busca",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        }).toList(),
                        hint: Text(
                          "Tipo de Anúncio",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Categoria
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10), // Arredondando as bordas
                        color: Theme.of(context).cardColor,
                      ),
                      child: DropdownButton<String>(
                        underline: Container(),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        isDense: true,
                        isExpanded: true,
                        value: categoria,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                        ),
                        iconSize: 50,
                        iconEnabledColor: Theme.of(context).primaryColorLight,
                        menuWidth: double.infinity,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Theme.of(context).cardColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            categoria = newValue;
                          });
                        },
                        items: categorias
                            .map<DropdownMenuItem<String>>((String value) {
                          Color cor = Color(0xFFFFFFFF);
                          if (value == "Opção 1") {
                            cor = Color(0xFF134E6C);
                          } else if (value == "Opção 2") {
                            cor = Color(0xFF38524A);
                          } else if (value == "Opção 3") {
                            cor = Color.fromARGB(255, 82, 56, 57);
                          }
                          return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                height: 40,
                                child: Card(
                                  color: cor,
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }).toList(),
                        hint: Text(
                          "Categoria",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Preço
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\,?\d{0,2}'))
                      ],
                      controller: _precoController,
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
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Preço",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Celular
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '(##) #####-####'), // Máscara para celular
                      ],
                      controller: _celularController,
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
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "Celular",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // CEP
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '#####-###'), // Máscara para celular
                      ],
                      controller: _cepController,
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
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        hintText: "CEP",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    // Botão
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool anunciar = await _anunciar();
                          print(_tituloController.text);
                          print(_descricaoController.text);
                          print(_precoController.text);
                          print(categoria);
                          print(tipo);
                          print(_cepController.text);
                          print(_celularController.text);
                          print(ip);
                          print('http://$ip:5000/criar_anuncio');
                          if (anunciar) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const Home();
                            }));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          overlayColor: WidgetStateProperty.all<Color>(
                              Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.1)),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File imageFile;

  const FullScreenImage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Fecha a tela de visualização
          },
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(imageFile), // Exibe a imagem em tela cheia
        ),
      ),
    );
  }
}
