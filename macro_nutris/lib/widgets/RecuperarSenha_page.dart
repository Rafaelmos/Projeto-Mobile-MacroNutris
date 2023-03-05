import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/Home_page.dart';
import 'Cadastro_page.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

void checkFirebaseConnection() {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth == null) {
    print("Firebase is not connected");
  } else {
    print("Firebase is connected");
  }
}

class _ResetScreenState extends State<ResetScreen> {
  String _email = '';
  String _passwaord = '';
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar senha'),
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
                autofocus: true,
                keyboardType: TextInputType.text,
                keyboardAppearance: Brightness.dark,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonTheme(
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    _firebaseAuth.sendPasswordResetEmail(email: _email);
                    Navigator.of(context).pop();
                  },
                  color: const Color.fromARGB(255, 224, 176, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    'Enviar Solicitação',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
