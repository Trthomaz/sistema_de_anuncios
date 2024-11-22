import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Anunciar extends StatefulWidget {
  const Anunciar({super.key});

  @override
  State<Anunciar> createState() => _AnunciarState();
}

class _AnunciarState extends State<Anunciar> {
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Converte para File
      });
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

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
          
          children: [Center(
           child: Padding(
             padding: const EdgeInsets.only(right: 10, left: 10,),
             child: Column(
              children: [
                // Titulo
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
                      fillColor:
                          Theme.of(context).cardColor,
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
                      fillColor:
                          Theme.of(context).cardColor,
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
                  double size = constraints.maxWidth * 0.7; // Altura da imagem
                  return
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _selectedImage != null
                      ? Column(children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Image.file(_selectedImage!, width: size, height: size, fit: BoxFit.cover,) // Mostra a imagem selecionada
                            ),
                          SizedBox(height: 10),
                          FilledButton(
                            onPressed: (){
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
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Substituir imagem",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                          )),])

                      : FilledButton(
                          onPressed: (){
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
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "Escolher imagem",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  }
                ),
                // Tipo de Anúncio
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Arredondando as bordas
                      color: Theme.of(context).cardColor,
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      isDense: true,
                      isExpanded: true,
                      value: tipo,
                      icon: Icon(Icons.arrow_drop_down, size: 24,),
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
                      items: tipos.map<DropdownMenuItem<String>>((String value) {
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
                                      color: Theme.of(context).primaryColorLight,
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
                                      color: Theme.of(context).primaryColorLight,
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
                      borderRadius: BorderRadius.circular(10), // Arredondando as bordas
                      color: Theme.of(context).cardColor,
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      isDense: true,
                      isExpanded: true,
                      value: categoria,
                      icon: Icon(Icons.arrow_drop_down, size: 24,),
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
                      items: categorias.map<DropdownMenuItem<String>>((String value) {
                        Color cor = Color(0xFFFFFFFF);
                        if (value == "Opção 1"){
                          cor = Color(0xFF134E6C);
                        } else if (value == "Opção 2"){
                          cor = Color(0xFF38524A);
                        } else if (value == "Opção 3"){
                          cor = Color.fromARGB(255, 82, 56, 57);
                        }
                          return DropdownMenuItem<String>(
                            value: value,
                            child: 
                                SizedBox(
                                  height: 40,
                                  child: Card(
                                      color: cor,
                                      child: Center(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColorLight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                          );
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
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}'))
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
                      fillColor:
                          Theme.of(context).cardColor,
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
                            MaskTextInputFormatter(mask: '(##) #####-####'), // Máscara para celular
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
                            fillColor:
                                Theme.of(context).cardColor,
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
                            MaskTextInputFormatter(mask: '#####-###'), // Máscara para celular
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
                            fillColor:
                                Theme.of(context).cardColor,
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
              ],
             ),
           ), 
          ),]
        )
    ));
  }
}
