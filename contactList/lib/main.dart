import 'package:aprendizagem/screens/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/welcome') {
          return MaterialPageRoute(
              builder: (context) => ContactList(titulo: 'Lista de contato'));
        }

        return MaterialPageRoute(
            builder: (context) => ContactList(titulo: 'Lista de contato'));
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
              child: Text(
                'My Contacts',
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.blue[900]),
        body: Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Bem vindo na sua agenda!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/welcome');
                    },
                    child: Text(
                      'Entre',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    style: TextButton.styleFrom(primary: Colors.white),
                  ),
                )
              ],
            )),
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("lib/assets/images/back.jpg"),
                    fit: BoxFit.cover))));
  }
}
