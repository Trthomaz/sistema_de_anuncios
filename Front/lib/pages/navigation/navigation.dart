import 'package:flutter/material.dart';
import 'package:sistema_de_anuncios/pages/navigation/anunciar.dart';
import 'package:sistema_de_anuncios/pages/navigation/configs.dart';
import 'package:sistema_de_anuncios/pages/navigation/home.dart';
import 'package:sistema_de_anuncios/pages/navigation/meus_anuncios.dart';
import 'package:sistema_de_anuncios/pages/navigation/perfil.dart';

class Navigation extends StatefulWidget {
  final String ip;
  final int id;

  const Navigation({super.key, required this.ip, required this.id});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // Index da página selecionada
  late String ip;
  late int id;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ip = widget.ip;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      Home(ip: ip, id: id),
      Perfil(ip: ip, id: id),
      Anunciar(ip: ip, id: id),
      MeusAnuncios(ip: ip, id: id),
      Configs(),
    ];

    return Scaffold(
      body: _pages[
          _selectedIndex], // Abre a página selecionada no BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          // Muda o index da página selecionada
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).primaryColorDark),
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: "Anunciar",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.grid_view,
            ),
            label: "Meus Anúncios",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Configurações",
          ),
        ],
      ),
    );
  }
}
