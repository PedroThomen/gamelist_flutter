import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// APP PRINCIPAL
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameList',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// TELA INICIAL
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'GameList',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Lista de Jogos', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Entrar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameListPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DE LISTA
class GameListPage extends StatefulWidget {
  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  // Agora é uma lista de mapas (nome + descrição)
  List<Map<String, String>> jogos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Jogos')),

      body: ListView.builder(
        itemCount: jogos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(jogos[index]['nome']!),
            subtitle: Text(jogos[index]['descricao']!),
            onTap: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(
                    nomeJogo: jogos[index]['nome']!,
                    descricao: jogos[index]['descricao']!,
                    index: index,
                  ),
                ),
              );

              if (resultado != null) {
                setState(() {
                  if (resultado['acao'] == 'editar') {
                    jogos[resultado['index']] = {
                      'nome': resultado['nome'],
                      'descricao': resultado['descricao'],
                    };
                  } else if (resultado['acao'] == 'excluir') {
                    jogos.removeAt(resultado['index']);
                  }
                });
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final novoJogo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGamePage()),
          );

          if (novoJogo != null) {
            setState(() {
              jogos.add({
                'nome': novoJogo['nome'],
                'descricao': novoJogo['descricao'],
              });
            });
          }
        },
      ),
    );
  }
}

// TELA ADICIONAR / EDITAR
class AddGamePage extends StatefulWidget {
  final String? nomeInicial;
  final String? descricaoInicial;

  AddGamePage({this.nomeInicial, this.descricaoInicial});

  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.nomeInicial ?? '';
    descricaoController.text = widget.descricaoInicial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar / Editar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do jogo'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                Navigator.pop(context, {
                  'nome': nomeController.text,
                  'descricao': descricaoController.text,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DETALHES
class GameDetailPage extends StatelessWidget {
  final String nomeJogo;
  final String descricao;
  final int index;

  GameDetailPage({
    required this.nomeJogo,
    required this.descricao,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeJogo,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(descricao),
            SizedBox(height: 20),

            ElevatedButton(
              child: Text('Editar'),
              onPressed: () async {
                final editado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGamePage(
                      nomeInicial: nomeJogo,
                      descricaoInicial: descricao,
                    ),
                  ),
                );

                if (editado != null) {
                  Navigator.pop(context, {
                    'acao': 'editar',
                    'index': index,
                    'nome': editado['nome'],
                    'descricao': editado['descricao'],
                  });
                }
              },
            ),

            ElevatedButton(
              child: Text('Excluir'),
              onPressed: () {
                Navigator.pop(context, {'acao': 'excluir', 'index': index});
              },
            ),
          ],
        ),
      ),
    );
  }
}
