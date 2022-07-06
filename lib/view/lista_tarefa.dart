import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaTarefa extends StatelessWidget {
  Future<List<Map<String, Object?>>> buscarDados() async {
    String caminho = join(await getDatabasesPath(), 'bando.db');
    Database banco = await openDatabase(
      caminho,
      version: 3,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE tarefa(
            id INT PRIMARY KEY,
            nome TEXT NOT NULL,
            decricao TEXT NOT NULL
          )
        ''');
        db.execute(
            'INSERT INTO tarefa(nome,descricao) VALUES ("Projeto","Projeto Web")');
        db.execute(
            'INSERT INTO tarefa(nome,descricao) VALUES ("Apresentação","Apresentação em grupo")');
        db.execute(
            'INSERT INTO tarefa(nome,descricao) VALUES ("Lista","Lista Execícios")');
      },
    );
    List<Map<String, Object?>> lista =
        await banco.rawQuery('SELECT * FROM tarefa');
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/formTarefa');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: buscarDados(),
        builder:
            (Context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturo) {
          if (!dadosFuturo.hasData) return CircularProgressIndicator();
          var listaTarefa = dadosFuturo.data!;
          return ListView.builder(
            itemCount: listaTarefa.length,
            itemBuilder: (context, contador) {
              var tarefa = listaTarefa[contador];
              return ListTile(
                title: Text(tarefa['nome'].toString()),
                subtitle: Text(tarefa['descricao'].toString()),
              );
            },
          );
        },
      ),
    );

    //flutter clean
    // flutter pub get
  }
}
