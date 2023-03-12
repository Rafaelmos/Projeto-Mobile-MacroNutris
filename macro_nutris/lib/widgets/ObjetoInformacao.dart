import 'package:cloud_firestore/cloud_firestore.dart';

class Informacao {
  String id;
  DateTime data;
  int idade;
  double peso;
  double altura;
  double imc;

  Informacao({
    required this.id,
    required this.data,
    required this.idade,
    required this.peso,
    required this.altura,
    required this.imc,
  });

  static Informacao novaInformacao(id, data, idade, peso, altura, imc) {
    Informacao novaInformacao = Informacao(
      id: id,
      data: data,
      idade: idade,
      peso: peso,
      altura: altura,
      imc: imc,
    );
    return novaInformacao;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'idade': idade.toInt(),
      'peso': peso.toDouble(),
      'altura': altura.toDouble(),
      'imc': imc.toDouble(),
    };
  }

  factory Informacao.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Informacao(
      id: data['id'],
      data: (data['data'] as Timestamp).toDate(),
      idade: data['idade'].toInt(),
      peso: data['peso'].toDouble(),
      altura: data['altura'].toDouble(),
      imc: data['imc'].toDouble(),
    );
  }
}
