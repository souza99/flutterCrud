

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FormProduct extends StatelessWidget{

  String? nome;
  String? dataCadastro;
  String? descricao;



  Future<int>salvar(String nome, String dataCadastro,String descricao, [int? id]) async{
    String caminho = join(await getDatabasesPath(), 'bando.db');
    Database banco = await openDatabase(caminho, version: 1);

    String sql;
    Future<int> linhasAfetadas;
    if(id == null){
      sql = 'INSERT INTO produto (nome, dataCadastro, descricao) VALUES (?,?,?)';
      linhasAfetadas = banco.rawInsert(sql, [nome, dataCadastro, descricao] );
    }else{
      sql = 'UPDATE produto SET  nome = ?, dataCadastro = ?, descricao = ? WHERE id = ? ';
      linhasAfetadas = banco.rawUpdate(sql, [nome, dataCadastro, id]);
    }
    return linhasAfetadas;

  }

  deletar(String id) async{
    String caminho = join(await getDatabasesPath(), 'bando.db');
    Database banco = await openDatabase(caminho, version: 1);

    String sql;
    Future<int> linhaDeletada;
    if(id !=null){
      sql = "DELETE FROM produto WHERE id = ?";
      linhaDeletada = banco.rawDelete(sql, [id]);
    }
  }

  _dialog(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Produto"),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text('nome Item: '), hintText: 'Insira o nome do item'),
            onChanged: (valorInserido){
            nome = valorInserido;
            }
            ),
          TextFormField(
              decoration: InputDecoration(
                  label: Text('Descricao: '), hintText: 'Insira uma descrição para o item'),
              onChanged: (valorInserido){
                descricao = valorInserido;
              }
          ),
          ElevatedButton(
              child: Text('Salvar'),
              onPressed: (){
                dataCadastro = DateTime.now().toString();
                salvar(nome!, dataCadastro!, descricao!);
                print(dataCadastro);
                Navigator.pushNamed(context, '/');
              })
        ],
      ),
    );
  }

}