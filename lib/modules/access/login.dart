import 'dart:convert';

import 'package:box_nova/models/Access.dart';
import 'package:box_nova/modules/home/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', textAlign: TextAlign.justify),
      ),
      body:
      SingleChildScrollView(
      child:
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            // heightFactor: 3,
            widthFactor: 1,
            child: LoginForm()
          ),
        )
      )
    );
  }
}


class LoginForm extends StatefulWidget{
  const LoginForm({ super.key });
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{

  final _formKey =  GlobalKey<FormState>();

  String? _email, _password;

  bool _isLoading = false;

  String? _msgInvalidPassword = null;

  String? _validMessage ( value ){
    return (value == null || value.isEmpty) ?"Ingrese el campo en su totalidad" :null;
  }

  Future<bool?> _postLogin ( email, password ) async {
    
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('https://boxnovan.onrender.com/api/login');
      var response = await http.post(url,
        body: {
          "email": email,
          "password": password,
        }
      );

      // print( response.body );

      final tokenHeader = response.headers["set-cookie"] ?? "";

      final token = tokenHeader.split(';')[0].replaceFirst('token=', '');

      // print( token );
      
      // Save token in SharedPreferences
      Access.saveToken(token);
      
      var body = json.decode( response.body );

      return body!["success"];
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 250.0,
            width: 350.0,
            child: Image.asset('assets/images/Logo.jpeg'),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            textAlign: TextAlign.center,
            validator: _validMessage,
            onSaved: ( value ){ _email = value; },
            decoration: InputDecoration(
              hintText: 'Correo',
            ),
            onTapOutside: (event) => {
              print(event)
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            textAlign: TextAlign.center,
            validator: _validMessage,
            onSaved: ( value ){ _password = value; },
            decoration: InputDecoration(
              hintText: 'Contraseña',
              errorText: _msgInvalidPassword
            ),
          ),
          SizedBox(height: 24),
          _isLoading 
          ? CircularProgressIndicator()
          : ElevatedButton(
            onPressed: () {
              if( _formKey.currentState!.validate() ){
                //? Enviar datos al backend
                _formKey.currentState!.save();

                _postLogin( _email, _password )
                .then( ( val ){
                  if( val ?? false ){
                    //Iniciar sesión y redireccionar
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Admin()) );
                  }else {
                    // showDialog(context: context, child: Text("Error al iniciar sesión"));
                    setState(() {
                      _msgInvalidPassword = "La contraseña es invalida";
                    });
                  }
                  setState(() {
                    _isLoading = false;
                  });
                });
              }
            },
            child: Text("Ingresar"),
          ),
          SizedBox(height: 12,),
          _isLoading
          ? ElevatedButton(
            onPressed: () {
              setState(() { _isLoading = false; });
            },
            child: Text("Cancelar"),
          )
          : SizedBox(),
        ],
      )
    );
  }
}