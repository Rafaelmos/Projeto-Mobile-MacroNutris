import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'package:macro_nutris/widgets/Informacao_page.dart';
import 'package:macro_nutris/widgets/ObjetoDadosSemana.dart';
import 'package:macro_nutris/widgets/ObjetoMeta.dart';
import 'package:macro_nutris/widgets/Sobre_page.dart';
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
  List refeicoesDia = [];
  List refeicoesSemana = [];
  List metas = [];
  double kcalDia = 0;
  double carboDia = 0;
  double proteinaDia = 0;
  double gordDia = 0;
  double kcalMeta = 0;
  double carboMeta = 0;
  double proteinaMeta = 0;
  double gordMeta = 0;

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
        title: const Text('Relatórios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            const Text(
              "Relatório Diario",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                """META""",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                """KCAL: $kcalMeta CARBO: $carboMeta PROT: $proteinaMeta GORD: $gordMeta""",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                """CONSUMIDAS""",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                """KCAL: $kcalDia CARBO: $carboDia PROT: $proteinaDia GORD: $gordDia""",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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

  gerarGraficoSemanal() {
    DateTime hoje =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    List lista1 = [hoje, 0];
    List lista2 = [hoje.subtract(Duration(days: 1)), 0];
    List lista3 = [hoje.subtract(Duration(days: 2)), 0];
    List lista4 = [hoje.subtract(Duration(days: 3)), 0];
    List lista5 = [hoje.subtract(Duration(days: 4)), 0];
    List lista6 = [hoje.subtract(Duration(days: 5)), 0];
    List lista7 = [hoje.subtract(Duration(days: 6)), 0];

    refeicoesSemana.forEach((refeicao) {
      if (refeicao['data'] == lista1[0]) {
        lista1[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista2[1]) {
        lista2[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista3[1]) {
        lista3[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista4[1]) {
        lista4[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista5[1]) {
        lista5[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista6[1]) {
        lista6[1] += refeicao['kcal'];
      } else if (refeicao['data'] == lista7[1]) {
        lista7[1] += refeicao['kcal'];
      }
    });

    List kcalSemanal = [
      DadosSemana(data: lista1[0], dado: lista1[1]),
      DadosSemana(data: lista2[0], dado: lista2[1]),
      DadosSemana(data: lista3[0], dado: lista3[1]),
      DadosSemana(data: lista4[0], dado: lista4[1]),
      DadosSemana(data: lista5[0], dado: lista5[1]),
      DadosSemana(data: lista6[0], dado: lista6[1]),
      DadosSemana(data: lista7[0], dado: lista7[1]),
    ];
  }

  gerarGraficoDiario() {
    setState(() {
      refeicoesDia.forEach((refeicao) {
        kcalDia += refeicao['kcal'];
        carboDia += refeicao['carboidratos'];
        proteinaDia += refeicao['proteina'];
        gordDia += refeicao['gordura'];
      });

      kcalMeta = metas[0]['kcal'];
      carboMeta = metas[0]['carboidratos'];
      proteinaMeta = metas[0]['proteina'];
      gordMeta = metas[0]['gordura'];
    });
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
        refeicoesDia.add(refeicao.toJson());
      });
    } catch (e) {}

    gerarGraficoDiario();
  }

  void buscarMeta() async {
    User? user = getUser();

    try {
      QuerySnapshot querySnapshot =
          await db.collection('Metas').where('id', isEqualTo: user!.uid).get();

      querySnapshot.docs.forEach((doc) {
        Meta meta = Meta.fromFirestore(doc);
        metas.add(meta.toJson());
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
        refeicoesSemana.add(refeicao.toJson());
      });
    } catch (e) {}

    gerarGraficoSemanal();
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
