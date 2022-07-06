import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaUsuario extends StatelessWidget {
  Future<List<Map<String, Object?>>> buscaUsuarios() async {
    String caminho = join(await getDatabasesPath(), 'banco.db');
    deleteDatabase(caminho);
    Database banco =
        await openDatabase(caminho, version: 4, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE usuario(
          id INT PRIMARY KEY,
          nome TEXT NOT NULL,
          aniversario TEXT NOT NULL          
        )
    ''');
      db.execute(
          'INSERT INTO usuario(nome, aniversario) VALUES ("JOAOpedro", "2001-01-11")');
      db.execute(
          'INSERT INTO usuario(nome, aniversario) VALUES("JAQUELINE", "2002-09-09")');
      db.execute(
          'INSERT INTO usuario(nome, aniversario) VALUES("NINA", "2004-09-09")');
      db.execute(
          'INSERT INTO usuario(nome, aniversario) VALUES("JULHO", "2002-09-09")');
    });

    List<Map<String, Object?>> list =
        await banco.rawQuery('SELECT * FROM usuario');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/formUsuarios');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: buscaUsuarios(),
        builder:
            (Context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturo) {
          if (!dadosFuturo.hasData) return CircularProgressIndicator();
          var listUser = dadosFuturo.data!;
          return ListView.builder(
            itemCount: listUser.length,
            itemBuilder: (context, contador) {
              var tarefa = listUser[contador];
              return ListTile(
                title: Text(tarefa['nome'].toString()),
                subtitle: Text(tarefa['aniversario'].toString()),
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
