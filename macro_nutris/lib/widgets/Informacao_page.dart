import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'Checagem_page.dart';
import 'package:macro_nutris/widgets/Relatorio_page.dart';

class Informacoes extends StatefulWidget {
  const Informacoes({super.key});

  @override
  State<Informacoes> createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _altura = TextEditingController();
  final _peso = TextEditingController();
  String nome = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(nome), accountEmail: Text(email)),
            ListTile(
              dense: true,
              title: const Text('Refeições'),
              trailing: const Icon(Icons.analytics_outlined),
              onTap: () {
                home_page();
              },
            ),
            ListTile(
              dense: true,
              title: const Text('Relatórios'),
              trailing: const Icon(Icons.analytics_outlined),
              onTap: () {
                relatorio_page();
              },
            ),
            ListTile(
              dense: true,
              title: const Text('Sair'),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () {
                sair();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _peso,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Peso",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _altura,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Altura",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            )
          ],
        )),
      ),
    );
  }

  exibirUsuario() async {
    User? usuario = getUser();
    if (usuario != null) {
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }

  calcular() {
    // peso  / (altura )**2
  }

  sair() async {
    await _firebaseAuth.signOut().then(
          (user) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Checagem_page(),
            ),
          ),
        );
  }

  home_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  relatorio_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Relatorios()));
  }

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }
}
