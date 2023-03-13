import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'Checagem_page.dart';
import 'package:macro_nutris/widgets/Relatorio_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'Informacao_page.dart';
import 'ObjetoMeta.dart';

class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  State<Metas> createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  final _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _kcal = TextEditingController();
  TextEditingController _proteinas = TextEditingController();
  TextEditingController _carboidratos = TextEditingController();
  TextEditingController _gordura = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String nome = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    exibirUsuario();
  }

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
              title: const Text('Informações'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                informacoes_page();
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
              title: const Text('Refeições'),
              trailing: const Icon(Icons.room_service),
              onTap: () {
                home_page();
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
        title: const Text('Metas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            TextFormField(
              controller: _kcal,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Calorias",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _carboidratos,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Carboidratos",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _proteinas,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Gordura",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _gordura,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Godura",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              height: 50,
              child: MaterialButton(
                onPressed: () {
                  definirMeta();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: const Color.fromARGB(255, 224, 176, 255),
                child: const Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
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

  String converterParaDecimal(decimal) {
    if (decimal.contains(',')) {
      decimal = decimal.replaceAll(',', '.');
      return decimal;
    } else {
      return decimal;
    }
  }

  void definirMeta() {
    String id = Uuid().v1();
    String user = getUser()!.uid;
    double kcal = double.parse(converterParaDecimal(_kcal.text));
    double carbo = double.parse(converterParaDecimal(_carboidratos.text));
    double proteina = double.parse(converterParaDecimal(_proteinas.text));
    double gord = double.parse(converterParaDecimal(_gordura.text));

    Meta meta = Meta.novaMeta(user, kcal, carbo, proteina, gord);

    db.collection('Metas').doc(user).set(meta.toJson());
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

  informacoes_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Informacoes()));
  }

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }
}
