import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:practicawidgets/src/api/apiService.dart';
import 'package:practicawidgets/src/models/materia.dart';
import 'package:practicawidgets/src/ui/home/form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: FutureBuilder(
          future: apiService.getMaterias(),
          builder: (BuildContext context, AsyncSnapshot<List<Materia>> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text("Ocurrió un error: ${snapshot.error.toString()}"),
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              List<Materia> materias = snapshot.data;
              return _buildListView(materias);
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  Widget _buildListView(List<Materia> materias){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index){
          Materia materia = materias[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        materia.nombre,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(materia.profesor),
                      Text(materia.cuatrimestre),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text('¿Estás seguro?'),
                                        content: Text('Esto eliminará la materia ${materia.nombre}'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                                apiService
                                                    .deleteMateria(materia.id)
                                                    .then((isSuccess){
                                                  if(isSuccess){
                                                    setState(() {
                                                      Scaffold.of(context)
                                                          .showSnackBar(SnackBar(
                                                        content: Text('Eliminación exitosa'),
                                                      ));
                                                    });
                                                  }else{
                                                    Scaffold.of(context).showSnackBar(
                                                        SnackBar(
                                                            content: Text('No pudimos eliminar, intenta nuevamente')
                                                        )
                                                    );
                                                  }
                                                });
                                              },
                                              child: Text('Si, elimina')
                                          ),
                                          FlatButton(
                                            onPressed: (){ Navigator.pop(context);},
                                            child: Text('No'),
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              child: Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              )
                          ),
                          FlatButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context){ return FormAddScreen(materia: materia);}
                                    )
                                );
                              },
                              child: Text(
                                'Editar',
                                style: TextStyle(color: Colors.blue),
                              )
                          )
                        ],
                      )
                    ],
                  ),
                )
            ),
          );
        },
        itemCount: materias.length,
      ),
    );
  }
}
