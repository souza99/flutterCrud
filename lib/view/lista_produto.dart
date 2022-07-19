
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/form_product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaProduto extends StatelessWidget {
  final FormProduct formll = new FormProduct();
  Future<List<Map<String, Object?>>> buscaProdutos() async {
    String caminho = join(await getDatabasesPath(), 'bando.db');
    //deleteDatabase(caminho);
    Database banco = await openDatabase(
        caminho,
        version: 1,
        onCreate: (db, version) {
        db.execute('''
          CREATE TABLE produto(
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            dataCadastro TEXT NOT NULL,
            descricao TEXT NOT NULL
          )
        ''');
      db.execute('INSERT INTO produto(nome, dataCadastro, descricao) VALUES ("GRATE BALL", "2022-07-12", "Maior chance de pegar pokemon") ');
    });

    List<Map<String, Object?>> listProduct = await banco.rawQuery('SELECT * FROM produto');

    return listProduct;
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos a venda'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.pushNamed(context, '/cadastroProduto');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: buscaProdutos(),
        builder:
          (Context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturos){
          if(!dadosFuturos.hasData) return CircularProgressIndicator();
          var productList = dadosFuturos.data!;
          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, contador) {
              var produto = productList[contador];
              return ListTile(
                title: Text(produto['nome'].toString()),
                subtitle: Text(produto['dataCadastro'].toString()),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        //olors.amber
                        color: Colors.red,
                          icon: Icon(Icons.delete), onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              color: Colors.grey,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ElevatedButton(
                                        child: const Text('Deletar'),
                                        onPressed: () =>{
                                          formll.deletar(produto['id'].toString()),
                                          Navigator.pop(context),
                                          Navigator.pushNamed(context, "/"),
                                        }
                                    ),

                                    ElevatedButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () =>{
                                        Navigator.pop(context),
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      ),
                      IconButton(
                        color: Colors.greenAccent,
                          onPressed: (){
                          //formll.salvar(produto['nome'].toString(), produto!['dataCadastro'].toString(), produto!['descricao'].toString(),int.parse(produto['id']));
                          },
                          icon: Icon(Icons.update))
                    ],
                  ),
                )
              );
            },
          );

        },
      ),
    );


  }

}
