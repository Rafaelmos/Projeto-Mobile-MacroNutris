import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macro_nutris/widgets/Checagem_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class Alimentos {
  String tipo; //cafe, almoco, janta, outro
  DateTime data;
  String nome;
  double gramasMl;
  double kcal;
  double carboidratos;
  double proteina;
  double gordura;

  Alimentos({
    required this.tipo,
    required this.data,
    required this.nome,
    required this.gramasMl,
    required this.kcal,
    required this.carboidratos,
    required this.proteina,
    required this.gordura,
  });
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';
  DateTime dataSelecionada = DateTime.now();
  List<Alimentos> listaCafe = [];
  List<Alimentos> listaAlmoco = [];
  List<Alimentos> listaJantar = [];
  List<Alimentos> listaOutros = [];
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _gramasMlController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _carboidratosController = TextEditingController();
  TextEditingController _proteinaController = TextEditingController();
  TextEditingController _gorduraController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listaCafe = [];
    listaAlmoco = [];
    listaJantar = [];
    listaOutros = [];
    pegar_Usuario();
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
        title: Text(
            DateFormat('dd/MM/yyyy').format(dataSelecionada ?? DateTime.now())),
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
                          title: const Text('Novo alimento'),
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
                                Alimentos novaRefeicao = Alimentos(
                                  tipo: selectedList,
                                  data: dataSelecionada,
                                  nome: _nomeController.text,
                                  gramasMl:
                                      double.parse(_gramasMlController.text),
                                  kcal: double.parse(_kcalController.text),
                                  carboidratos: double.parse(
                                      _carboidratosController.text),
                                  proteina:
                                      double.parse(_proteinaController.text),
                                  gordura:
                                      double.parse(_gorduraController.text),
                                );
                                switch (selectedList) {
                                  case 'Cafe':
                                    setState(() {
                                      listaCafe.add(novaRefeicao);
                                    });
                                    break;
                                  case 'Almoco':
                                    setState(() {
                                      listaAlmoco.add(novaRefeicao);
                                    });
                                    break;
                                  case 'Jantar':
                                    setState(() {
                                      listaJantar.add(novaRefeicao);
                                    });
                                    break;
                                  case 'Outros':
                                    setState(() {
                                      listaOutros.add(novaRefeicao);
                                    });
                                    break;
                                  default:
                                    break;
                                }
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

  List<Widget> _buildList(List<Alimentos> lista) {
    return lista
        .map((alimento) => ListTile(
              title: Text(alimento.nome),
              trailing:
                  Text('${alimento.gramasMl} g/mL - ${alimento.kcal} kcal'),
            ))
        .toList();
  }

  pegar_Usuario() async {
    User? usuario = await _firebaseAuth.currentUser;
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (dataSelecionada != null) {
      setState(() {
        this.dataSelecionada = dataSelecionada;
      });
    }
  }
}
