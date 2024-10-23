import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.abc), // Ícone à esquerda
              onPressed: () {
                print('Clicou no ícone de menu');
              },
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                    color: Theme.of(context).primaryColorLight, fontSize: 20),
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titleTextStyle: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 24,
            ),
            elevation: 3,
            actions: <Widget>[
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ]),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  bottom: 100,
                  left: 200,
                  right: 200,
                ),
                child: Text(
                  "Feed",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  bottom: 100,
                  left: 200,
                  right: 200,
                ),
                child: Text(
                  "Feed",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
