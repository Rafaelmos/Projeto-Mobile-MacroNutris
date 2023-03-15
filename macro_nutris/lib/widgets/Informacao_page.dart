import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'package:macro_nutris/widgets/Sobre_page.dart';
import 'package:macro_nutris/widgets/meta_page.dart';
import 'Checagem_page.dart';
import 'package:macro_nutris/widgets/Relatorio_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_nutris/widgets/ObjetoInformacao.dart';
import 'package:uuid/uuid.dart';

class Informacoes extends StatefulWidget {
  const Informacoes({super.key});

  @override
  State<Informacoes> createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  final _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _altura = TextEditingController();
  TextEditingController _peso = TextEditingController();
  TextEditingController _idade = TextEditingController();
  TextEditingController _imc = TextEditingController();
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
              title: const Text('Metas'),
              trailing: const Icon(Icons.g_mobiledata),
              onTap: () {
                meta_page();
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
              title: const Text('Sobre'),
              trailing: const Icon(Icons.library_books_outlined),
              onTap: () {
                sobre_page();
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
        title: const Text('Informações'),
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
              controller: _idade,
              autofocus: true,
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Idade",
                labelStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
              ),
            ),
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
              keyboardType: TextInputType.text,
              keyboardAppearance: Brightness.dark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Altura",
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
                  addInformacao();
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

  calcular(peso, altura) {
    double imc = peso / (altura * altura);
    return imc;
  }

  String converterParaDecimal(decimal) {
    if (decimal.contains(',')) {
      decimal = decimal.replaceAll(',', '.');
      return decimal;
    } else {
      return decimal;
    }
  }

  void addInformacao() {
    String id = Uuid().v1();
    double peso = double.parse(converterParaDecimal(_peso.text));
    double altura = double.parse(converterParaDecimal(_altura.text));

    Informacao informacoes = Informacao.novaInformacao(
      id,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      int.parse(_idade.text),
      peso,
      altura,
      calcular(peso, altura),
    );

    User? user = getUser();

    db.collection(email).doc(id).set(informacoes.toJson());
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

  sobre_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Sobre()));
  }

  relatorio_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Relatorios()));
  }

  meta_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Metas()));
  }

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }
}
