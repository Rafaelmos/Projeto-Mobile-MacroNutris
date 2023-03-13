import 'package:cloud_firestore/cloud_firestore.dart';

class Meta {
  String id;
  double kcal;
  double carboidratos;
  double proteina;
  double gordura;

  Meta({
    required this.id,
    required this.kcal,
    required this.carboidratos,
    required this.proteina,
    required this.gordura,
  });

  static Meta novaMeta(
      id, kcal, carbo, prote, gord) {
    Meta novaRefeicao = Meta(
      id: id,
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
      'kcal': kcal.toDouble(),
      'carboidratos': carboidratos.toDouble(),
      'proteina': proteina.toDouble(),
      'gordura': gordura.toDouble(),
    };
  }

  factory Meta.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Meta(
      id: data['id'],
      kcal: data['kcal'].toDouble(),
      carboidratos: data['carboidratos'].toDouble(),
      proteina: data['proteina'].toDouble(),
      gordura: data['gordura'].toDouble(),
    );
  }
}
