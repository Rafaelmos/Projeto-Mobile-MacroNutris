import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'package:macro_nutris/widgets/Informacao_page.dart';
import 'package:macro_nutris/widgets/ObjetoMeta.dart';
import 'package:macro_nutris/widgets/Relatorio_page.dart';
import 'Checagem_page.dart';
import 'Meta_page.dart';
import 'ObjetoRefeicao.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
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
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/logo.png"),
            ),
            const Text(
              "    O aplicativo de nutrição foi desenvolvido para ajudá-lo a controlar sua dieta e alcançar seus objetivos de saúde e bem-estar. Cadastre seus alimentos diários e suas quantidades em gramas e acompanhe facilmente as informações nutricionais de cada alimento, como kcal, carboidratos, proteínas e gorduras. Defina metas de ingestão diárias para cada nutriente e monitore seu progresso com nossos gráficos de fácil visualização.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "   \n Esse programa foi desenvolvido para Disciplina de Desenvolvimento Mobile da Universidade UFRPE - UAST.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "    Desenvolvido em 2023",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " Feito por: \n\n Rafael José Moura \n\n Github: https://github.com/Rafaelmos \n\n Rafaéla Maria Moura \n\n Github: https://github.com/rafaela-moura",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w100,
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

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }

  sair() async {
    await FirebaseAuth.instance.signOut().then(
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

  relatorio_page() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Relatorios()));
  }
}
