import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              const TextField(
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
              const SizedBox(
                height: 10,
              ),
              const TextField(
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
                    print("click");
                    /*É NO ONPRESSED QUE COLOCAMOS O EVENTO PARA O LOGIN, OU SEJA, VAMOS RELACIONAR O AUTENTICAR DO FIREBASE POR AQUI DE ALGUMA FORMA*/
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
}
