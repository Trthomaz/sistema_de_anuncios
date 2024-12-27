import 'package:flutter/material.dart';

class Anuncio extends StatefulWidget {
  final String titulo;
  final double preco;
  final String? imagem;

  const Anuncio({
    super.key,
    required this.titulo,
    required this.preco,
    this.imagem,
  });

  @override
  State<Anuncio> createState() => _AnuncioState();
}

class _AnuncioState extends State<Anuncio> {

  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Selecione as opções'),
              content: SingleChildScrollView(
                child: Column(
                  children: options.map((String option) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: selectedOptions[option],
                      onChanged: (bool? value) {
                        setDialogState(() {
                          selectedOptions[option] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    setState(() {}); // Atualiza o estado principal
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _filtroDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              height: 50,
              width: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text("Filtro",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
              ),
            ),
            content: FilledButton(
                onPressed: () {
                  _showMultiSelectDialog();
                },
                child: Text("Categorias")),
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

  // Categoria
  List<String> categorias = [];
  final List<String> lista_categorias = ['Opção 1', 'Opção 2', 'Opção 3'];

  // Lista de opções
  final List<String> options = ['Opção 1', 'Opção 2', 'Opção 3', 'Opção 4'];

  // Estado de seleção para cada opção
  late Map<String, bool> selectedOptions;

  @override
  void initState() {
    super.initState();
    // Inicializa o estado de seleção (todas como não selecionadas)
    selectedOptions = {for (var option in options) option: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // Tamanho do AppBar
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
              // Leading é o ícone à esquerda do AppBar
              padding: const EdgeInsets.only(
                  left: 4, top: 2, bottom: 2, right: 2),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(1),
              child: TextField(
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.tune, // filter_list ou filter_alt ou tune
                      size: 22,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    onPressed: () {
                      _filtroDialog();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      body: LayoutBuilder(builder: (context, constraints) {
          double containerWidth = constraints.maxWidth - 20;
          double containerHeight = constraints.maxHeight - 184;
          return Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: widget.imagem != null 
                ? ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child:  Image.asset(widget.imagem!,
                    fit: BoxFit.contain,
                    height: containerWidth,
                    width: containerWidth,
                  )
                )
                : Container(
                  height: containerWidth,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Sem imagem",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Text(
                          widget.titulo,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Text(
                          "R\$ ${widget.preco.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      )
    );
  }
}