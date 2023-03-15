import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'package:macro_nutris/widgets/Informacao_page.dart';
import 'package:macro_nutris/widgets/ObjetoMeta.dart';
import 'Checagem_page.dart';
import 'Meta_page.dart';
import 'ObjetoRefeicao.dart';

class Relatorios extends StatefulWidget {
  const Relatorios({super.key});

  @override
  State<Relatorios> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';
  DateTime dataHoje =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Refeicao> refeicoesDia = [];
  List<Refeicao> refeicoesSemana = [];
  List<Meta> metas = [];

  @override
  void initState() {
    super.initState();
    exibirUsuario();
    buscarMeta();
    buscarRefeicoesDia();
    buscarRefeicoesSemana();
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
              trailing: const Icon(Icons.trending_up),
              onTap: () {
                meta_page();
              },
            ),
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
              title: const Text('Refeições'),
              trailing: const Icon(Icons.room_service),
              onTap: () {
                home_page();
              },
            ),
            ListTile(
              dense: true,
              title: const Text('Sobre'),
              trailing: const Icon(Icons.abc_outlined),
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
        title: const Text('Relatórios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Relatório Diário",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            //Metas Calorias
            //Calorias Atingidas Hoje
            //Metas de MacroNutrientes
            //Grafico de MacroNutrientes (DE PIZZA)

            carregarGraficoDiario(),
            const Text(
              "Relatório Semanal",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            //Grafico de Calorias (DE LINHA)
            //Grafico de Carboidratos (DE LINHA) #NAO SEI SE VALE A PENA FAZER
            //Grafico de Proteinas (DE LINHA) #NAO SEI SE VALE A PENA FAZER
            //Grafico de Gorduras (DE LINHA) #NAO SEI SE VALE A PENA FAZER

            carregarGraficoSemanal(),
          ],
        ),
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

  carregarGraficoDiario() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  carregarGraficoSemanal() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void buscarRefeicoesDia() async {
    User? user = getUser();
    try {
      QuerySnapshot querySnapshot = await db
          .collection(user!.uid)
          .where('data', isEqualTo: dataHoje)
          .get();

      querySnapshot.docs.forEach((doc) {
        Refeicao refeicao = Refeicao.fromFirestore(doc);
        refeicoesDia.add(refeicao);
      });
    } catch (e) {}
  }

  void buscarMeta() async {
    User? user = getUser();

    try {
      QuerySnapshot querySnapshot =
          await db.collection('Metas').where('id', isEqualTo: user!.uid).get();

      querySnapshot.docs.forEach((doc) {
        Meta meta = Meta.fromFirestore(doc);
        metas.add(meta);
      });
    } catch (e) {}
  }

  void buscarRefeicoesSemana() async {
    User? user = getUser();
    DateTime dataSubtraida = dataHoje.subtract(Duration(days: 7));
    try {
      QuerySnapshot querySnapshot = await db
          .collection(user!.uid)
          .where('data', isGreaterThanOrEqualTo: dataSubtraida)
          .where('data', isLessThanOrEqualTo: dataHoje)
          .get();

      querySnapshot.docs.forEach((doc) {
        Refeicao refeicao = Refeicao.fromFirestore(doc);
        refeicoesSemana.add(refeicao);
      });
    } catch (e) {}
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

  informacoes_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Informacoes()));
  }

  meta_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Metas()));
  }

  sobre_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Sobre()));
  }

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }
}
