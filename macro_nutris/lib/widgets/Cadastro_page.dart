import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Checagem_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar'),
        ),
        backgroundColor: const Color.fromARGB(255, 247, 238, 253),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  TextFormField(
                    controller: _userController,
                    decoration:
                        const InputDecoration(label: Text('Nome do Usuário')),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(label: Text('Password')),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    height: 60,
                    child: MaterialButton(
                      onPressed: () {
                        cadastro();
                      },
                      color: const Color.fromARGB(255, 224, 176, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ]))));
  }

  cadastro() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_userController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Checagem_page()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Crie uma senha mais forte'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Já existe uma conta com esse E-mail'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
