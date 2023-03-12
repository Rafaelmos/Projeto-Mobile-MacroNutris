import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macro_nutris/widgets/Checagem_page.dart';
import 'package:macro_nutris/widgets/ObjetoRefeicao.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';
  DateTime dataSelecionada =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<Refeicao> refeicoes = [];
  List<Refeicao> listaCafe = [];
  List<Refeicao> listaAlmoco = [];
  List<Refeicao> listaJantar = [];
  List<Refeicao> listaOutros = [];
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _gramasMlController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _carboidratosController = TextEditingController();
  TextEditingController _proteinaController = TextEditingController();
  TextEditingController _gorduraController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    buscarRefeicoes();
    listaCafe = [];
    listaAlmoco = [];
    listaJantar = [];
    listaOutros = [];
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
        title: GestureDetector(
          onTap: () => selecionarData(),
          child: Text(DateFormat('dd/MM/yyyy').format(dataSelecionada)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => selecionarData(),
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: Text('Café da Manhã'),
                  children: _buildList(listaCafe),
                ),
                ExpansionTile(
                  title: Text('Almoço'),
                  children: _buildList(listaAlmoco),
                ),
                ExpansionTile(
                  title: Text('Jantar'),
                  children: _buildList(listaJantar),
                ),
                ExpansionTile(
                  title: Text('Outros'),
                  children: _buildList(listaOutros),
                ),
                ElevatedButton(
                  onPressed: () {
                    String selectedList = 'Cafe'; // valor padrão
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Nova Refeição'),
                          content: SingleChildScrollView(
                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _nomeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _gramasMlController,
                                    decoration: const InputDecoration(
                                      labelText: 'Gramas/Ml',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _kcalController,
                                    decoration: const InputDecoration(
                                      labelText: 'Kcal',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _carboidratosController,
                                    decoration: const InputDecoration(
                                      labelText: 'Carboidratos',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _proteinaController,
                                    decoration: const InputDecoration(
                                      labelText: 'Proteína',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _gorduraController,
                                    decoration: const InputDecoration(
                                      labelText: 'Gordura',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  DropdownButton<String>(
                                    value: selectedList,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedList = value!;
                                      });
                                    },
                                    items: <String>[
                                      'Cafe',
                                      'Almoco',
                                      'Jantar',
                                      'Outros'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                addRefeicaoBD(selectedList);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Adicionar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Adicionar Refeição'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(List<Refeicao> lista) {
    return lista
        .map((refeicao) => ListTile(
              title: Text(refeicao.nome),
              trailing: Container(
                width: 70,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            removerRefeicaoBD(refeicao);
                            lista.remove(refeicao);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navegar para a tela de edição
                        },
                      ),
                    ),
                  ],
                ),
              ),
              subtitle:
                  Text('${refeicao.gramasMl} g/mL - ${refeicao.kcal} kcal'),
            ))
        .toList();
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

  sair() async {
    await _firebaseAuth.signOut().then(
          (user) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Checagem_page(),
            ),
          ),
        );
  }

  Future<void> selecionarData() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (dataSelecionada != null) {
      setState(() {
        this.dataSelecionada = dataSelecionada;
      });
    }
    buscarRefeicoes();
  }

  User? getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }

  void addRefeicaoBD(selectedList) {
    String id = Uuid().v1();
    Refeicao novaRefeicao = Refeicao.novaRefeicao(
        id,
        selectedList,
        dataSelecionada,
        _nomeController.text,
        double.parse(_gramasMlController.text),
        double.parse(_kcalController.text),
        double.parse(_carboidratosController.text),
        double.parse(_proteinaController.text),
        double.parse(_gorduraController.text));

    User? user = getUser();

    db.collection(user!.uid).doc(id).set(novaRefeicao.toJson());
    addRefeicaoLista(novaRefeicao);
  }

  void addRefeicaoLista(Refeicao novaRefeicao) {
    if (novaRefeicao.tipo == 'Cafe') {
      setState(() {
        listaCafe.add(novaRefeicao);
      });
    } else if (novaRefeicao.tipo == 'Almoco') {
      setState(() {
        listaAlmoco.add(novaRefeicao);
      });
    } else if (novaRefeicao.tipo == 'Jantar') {
      setState(() {
        listaJantar.add(novaRefeicao);
      });
    } else if (novaRefeicao.tipo == 'Outros') {
      setState(() {
        listaOutros.add(novaRefeicao);
      });
    }
  }

  void removerRefeicaoBD(Refeicao refeicao) {
    User? user = getUser();
    FirebaseFirestore.instance.collection(user!.uid).doc(refeicao.id).delete();
  }

  void buscarRefeicoes() async {
    refeicoes.clear();
    listaCafe.clear();
    listaAlmoco.clear();
    listaJantar.clear();
    listaOutros.clear();
    User? user = getUser();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(user!.uid)
          .where('data', isEqualTo: dataSelecionada)
          .get();

      querySnapshot.docs.forEach((doc) {
        Refeicao refeicao = Refeicao.fromFirestore(doc);
        refeicoes.add(refeicao);
      });
    } catch (e) {}
    atualizarLista();
  }

  void atualizarLista() {
    for (Refeicao refeicao in refeicoes) {
      addRefeicaoLista(refeicao);
    }
  }
}
