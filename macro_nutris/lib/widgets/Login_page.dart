import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 238, 253),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/logo.png"),
              ),
              TextFormField(
                controller: _emailController,
                autofocus: true,
                keyboardType: TextInputType.text,
                keyboardAppearance: Brightness.dark,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Usuário",
                  labelStyle: TextStyle(color: Colors.black),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _senhaController,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.dark,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Senha do usuário",
                    labelStyle: TextStyle(color: Colors.black),
                    alignLabelWithHint: true,
                  )),
              const SizedBox(
                height: 20,
              ),
              ButtonTheme(
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    login();
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30)),
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color.fromARGB(255, 224, 176, 255),
                ),
              )
            ],
          )),
        ));
  }

  login() async {
    try {
      UserCredential usuarioCredenciado =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (usuarioCredenciado != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não encontrado'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'wrong.passaword') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha incorreta'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
