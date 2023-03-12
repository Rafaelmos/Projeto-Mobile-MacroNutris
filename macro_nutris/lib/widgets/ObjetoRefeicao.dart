import 'package:cloud_firestore/cloud_firestore.dart';

class Refeicao {
  String id;
  String tipo; //cafe, almoco, janta, outro
  DateTime data;
  String nome;
  double gramasMl;
  double kcal;
  double carboidratos;
  double proteina;
  double gordura;

  Refeicao({
    required this.id,
    required this.tipo,
    required this.data,
    required this.nome,
    required this.gramasMl,
    required this.kcal,
    required this.carboidratos,
    required this.proteina,
    required this.gordura,
  });

  static Refeicao novaRefeicao(
      id, tipo, data, nome, gramasMl, kcal, carbo, prote, gord) {
    Refeicao novaRefeicao = Refeicao(
      id: id,
      tipo: tipo,
      data: data,
      nome: nome,
      gramasMl: gramasMl,
      kcal: kcal,
      carboidratos: carbo,
      proteina: prote,
      gordura: gord,
    );
    return novaRefeicao;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'data': data,
      'nome': nome,
      'gramasMl': gramasMl.toDouble(),
      'kcal': kcal.toDouble(),
      'carboidratos': carboidratos.toDouble(),
      'proteina': proteina.toDouble(),
      'gordura': gordura.toDouble(),
    };
  }

  factory Refeicao.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Refeicao(
      id: data['id'],
      tipo: data['tipo'],
      data: (data['data'] as Timestamp).toDate(),
      nome: data['nome'],
      gramasMl: data['gramasMl'].toDouble(),
      kcal: data['kcal'].toDouble(),
      carboidratos: data['carboidratos'].toDouble(),
      proteina: data['proteina'].toDouble(),
      gordura: data['gordura'].toDouble(),
    );
  }
}
