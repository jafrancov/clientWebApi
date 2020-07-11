import 'package:flutter/material.dart';
import 'package:practicawidgets/src/models/materia.dart';

import 'package:practicawidgets/src/api/apiService.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final Materia materia;
  FormAddScreen({this.materia});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNombreValid;
  bool _isFieldProfesorValid;
  bool _isFieldCuatrimestreValid;
  bool _isFieldHorarioValid;

  TextEditingController _controllerNombre   = TextEditingController();
  TextEditingController _controllerProfesor = TextEditingController();
  TextEditingController _controllerCuatrimestre   = TextEditingController();
  TextEditingController _controllerHorario  = TextEditingController();

  @override
  void initState() {
    if (widget.materia != null) {
      _isFieldNombreValid = true;
      _controllerNombre.text = widget.materia.nombre;
      _isFieldProfesorValid = true;
      _controllerProfesor.text = widget.materia.profesor;
      _isFieldCuatrimestreValid = true;
      _controllerCuatrimestre.text = widget.materia.cuatrimestre;
      _isFieldHorarioValid = true;
      _controllerHorario.text = widget.materia.horario;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.materia == null ? "Agregar materia" : "Editar materia",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldNombre(),
                _buildTextFieldProfesor(),
                _buildTextFieldCuatrimestre(),
                _buildTextFieldHorario(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.materia == null ? "Guardar".toUpperCase() : "Actualizar".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      if( _isFieldNombreValid == null || _isFieldProfesorValid == null || _isFieldCuatrimestreValid == null || _isFieldHorarioValid == null || !_isFieldNombreValid || !_isFieldProfesorValid || !_isFieldCuatrimestreValid || !_isFieldHorarioValid ){
                        _scaffoldState.currentState.showSnackBar(
                            SnackBar(content: Text("Por favor llena todos los campos"),)
                        );
                        return;
                      }
                      setState( ()=>_isLoading = true );
                      String nombre   = _controllerNombre.text.toString();
                      String profesor = _controllerProfesor.text.toString();
                      String cuatrimestre   = _controllerCuatrimestre.text.toString();
                      String horario  = _controllerHorario.text.toString();
                      //cómo obtener el siguiente ID
                      Materia materia = Materia(id: 3,nombre: nombre, profesor: profesor, cuatrimestre: cuatrimestre, horario: horario);
                      if( widget.materia == null ){
                        _apiService.createMateria(materia).then((isSuccess) {
                          setState(()=> _isLoading = false);
                          if( isSuccess ){
                            Navigator.pop(_scaffoldState.currentState.context);
                          }else{
                            _scaffoldState.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Tenemos problemas para agregar la materia, intenta nuevamente."),
                                )
                            );
                          }
                        });
                      }else{
                        materia.id = widget.materia.id;
                        _apiService.updateMateria(materia).then((isSuccess) {
                          setState(() => _isLoading=false );
                          if( isSuccess ){
                            Navigator.pop(_scaffoldState.currentState.context);
                          }else{
                            _scaffoldState.currentState.showSnackBar(
                                SnackBar(content: Text('No pudimos actualizar, intenta nuevamente.'))
                            );
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.3,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              ),
              Center(child: CircularProgressIndicator()),
            ],
          ) : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldNombre(){
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Materia",
        errorText: _isFieldNombreValid == null || _isFieldNombreValid
            ? null
            : "El nombre de la materia es obligatorio",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNombreValid) {
          setState(() => _isFieldNombreValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldProfesor(){
    return TextField(
      controller: _controllerProfesor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Profesor",
        errorText: _isFieldProfesorValid == null || _isFieldProfesorValid
            ? null
            : "El nombre del Profesor es obligatorio",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldProfesorValid) {
          setState(() => _isFieldProfesorValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldCuatrimestre(){
    return TextField(
      controller: _controllerCuatrimestre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Cuatrimestre",
        errorText: _isFieldCuatrimestreValid == null || _isFieldCuatrimestreValid
            ? null
            : "El Cuatrimestre es obligatorio",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldCuatrimestreValid) {
          setState(() => _isFieldCuatrimestreValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldHorario(){
    return TextField(
      controller: _controllerHorario,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Horario",
        errorText: _isFieldHorarioValid == null || _isFieldHorarioValid
            ? null
            : "El horario es obligatorio",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldHorarioValid) {
          setState(() => _isFieldHorarioValid = isFieldValid);
        }
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:practicawidgets/src/api/apiService.dart';
import 'package:practicawidgets/src/model/profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.name;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldEmail(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.profile == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldEmailValid == null ||
                          _isFieldAgeValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldEmailValid ||
                          !_isFieldAgeValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String email = _controllerEmail.text.toString();
                      int age = int.parse(_controllerAge.text.toString());
                      Profile profile =
                          Profile(name: name, email: email, age: age);
                      if (widget.profile == null) {
                        _apiService.createProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Submit data failed"),
                            ));
                          }
                        });
                      } else {
                        profile.id = widget.profile.id;
                        _apiService.updateProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}
*/