import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_de_anuncios/pages/navigation/navigation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarAnuncio extends StatefulWidget {
  // IP do servidor
  final String ip;
  final int id;
  final int anuncioId;

  const EditarAnuncio({
    super.key,
    required this.ip,
    required this.id,
    required this.anuncioId,
  });

  @override
  State<EditarAnuncio> createState() => _EditarAnuncioState();
}

class _EditarAnuncioState extends State<EditarAnuncio> {
  late String ip;
  late int id;
  late int anuncioId;
  bool _isLoading = true;
  Map<String, dynamic> anuncio = {};

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
    anuncioId = widget.anuncioId;
    _carregarAnuncio();
  }

  // TextEditingControllers
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  String imagem = "";

  // Imagem
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late String? base64Image;

  // Categoria e Tipo de Anuncio selecionados
  String? categoria;
  String? tipo;

  List<String> categorias = ["Serviço", "Produto"];
  List<String> tipos = ["Venda", "Busca"];

  Uint8List? decodificar(String base64Image) {
    // Verifica se a string Base64 começa com o prefixo 'data:image'
    if (base64Image.startsWith("data:image")) {
      // Remove o prefixo 'data:image/...;base64,' (se presente)
      base64Image = base64Image.split(",")[1];
    }

    // Decodifica a string Base64 para bytes (Uint8List)
    return base64Decode(base64Image);
  }

  Future<Map<String, dynamic>> _getAnunciobyID() async {
  final url = Uri.parse('http://$ip:5000/get_anuncio');

  // Dados enviados
  final dados = {'anuncio_id': anuncioId};

  try {
    final response = await http.post(
      url,
      headers: {
        // Define o tipo de conteúdo como json
        'Content-Type': 'application/json'
      },
      body: json.encode(dados),
    );

    Map<String, dynamic> resposta = json.decode(response.body);
    return resposta["dados"];
  } catch (e) {
    print(e);
    return {"erro": "erro"};
  }
}
  
  Future<void> _carregarAnuncio() async {
    setState(() {
      _isLoading = true;
    });
    anuncio = await _getAnunciobyID();
    base64Image = anuncio["imagem"];
    _tituloController.text = anuncio["titulo"];
    _descricaoController.text = anuncio["descricao"];
    _precoController.text = anuncio["preco"].toString();
    _celularController.text = anuncio["telefone"];
    _cepController.text = anuncio["local"];
    categoria = anuncio["categoria"];
    tipo = anuncio["tipo"];

    if (categoria == "produto"){
      categoria = "Produto";
    } else {
      categoria = "Serviço";
    }
    if (tipo == "venda"){
      tipo = "Venda";
    } else {
      tipo = "Busca";
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _editarAnuncio() async{
    final url = Uri.parse('http://$ip:5000/editar_anuncio');

    int cat = -1;
    int tip = -1;

    if (categoria != null) {
      cat = categorias.indexOf(categoria!)+1;
    }
    if (tipo != null) {
      tip = tipos.indexOf(tipo!)+1;
    }

    // Dados enviados
    final dados = {
      'anuncio_id': anuncioId,
      'titulo': _tituloController.text,
      'descricao': _descricaoController.text,
      'preco': _precoController.text,
      'celular': _celularController.text,
      'cep': _cepController.text,
      'categoria': cat,
      'tipo_anuncio': tip,
      'imagem': base64Image,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          // Define o tipo de conteúdo como json
          'Content-Type': 'application/json'
        },
        body: json.encode(dados),
      );

      Map<String, dynamic> resposta = json.decode(response.body);
      print(resposta);
    } catch (e) {
      print(e);
    }
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
            onTap: () => Navigator.pop(context, 0), // Câmera
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Escolher da Galeria'),
            onTap: () => Navigator.pop(context, 1), // Galeria
          ),
        ],
      );
    },
  );

  if (pickedSource == null) return;

  final ImageSource source =
      pickedSource == 0 ? ImageSource.camera : ImageSource.gallery;

  // Obtém o arquivo da imagem selecionada
  final pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });

    // Ler os bytes da imagem
    final bytes = await _selectedImage!.readAsBytes();

    // Codificar em Base64
    setState(() {
      base64Image = base64Encode(bytes);
    });

    print("BASE64:");
    print(base64Image);
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
                "Editar Anúncio",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) 
      : ListView(
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
                      child: base64Image != null
                          ? Column(
                            children: [
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                          10),
                                  child: Image.memory(
                                    decodificar(base64Image!)!,
                                    fit: BoxFit.contain,
                                    height: size,
                                    width: size,
                                  )),
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
                                )
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
                          if (value == "Serviço") {
                            cor = Color(0xFF134E6C);
                          } else if (value == "Produto") {
                            cor = Color(0xFF38524A);
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
                            RegExp(r'^\d+\.?\d{0,2}'))
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
                  Padding(
                    // Botão
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool anunciar = true;
                          if (anunciar) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Anúncio Cadastrado com Sucesso",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    content: Text(
                                        "Seu anúncio de $tipo de ${_tituloController.text} foi cadastrado no sistema",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0))),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Ok",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight)),
                                        onPressed: () {
                                          _editarAnuncio();
                                          Navigator.of(context).pop();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Navigation(ip: ip, id: id);
                                          }));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(1)),
                                      )
                                    ],
                                  );
                                });
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
                          "Editar",
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
