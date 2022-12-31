import 'package:flutter/material.dart';
import 'package:macro_nutris/widgets/login.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {

  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const Login(),

    );
    
  }
}
