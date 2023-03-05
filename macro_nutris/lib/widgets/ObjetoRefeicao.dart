class Refeicao {
  String tipo; //cafe, almoco, janta, outro
  DateTime data;
  String nome;
  double gramasMl;
  double kcal;
  double carboidratos;
  double proteina;
  double gordura;

  Refeicao({
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
      tipo, data, nome, gramasMl, kcal, carbo, prote, gord) {
    Refeicao novaRefeicao = Refeicao(
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
}
