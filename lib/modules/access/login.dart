import 'dart:convert';

import 'package:box_nova/modules/user/user_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', textAlign: TextAlign.justify),
      ),
      body: Center(
        child: LoginForm()
      ),
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

    var url = Uri.parse('https://boxnovan.onrender.com/api/login');
    var response = await http.post(url,
      body: {
        "email": email,
        "password": password,
      }
    );

    print( response.body );

    final tokenHeader = response.headers["set-cookie"] ?? "";

    final token = tokenHeader.split(';')[0].replaceFirst('token=', '');

    print( token );

    var body = json.decode( response.body );
    return body!["success"];
  }

  @override
  Widget build(BuildContext context) {
    return
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
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
            SizedBox(height: 18),
            _isLoading 
            ? CircularProgressIndicator()
            : ElevatedButton(
              onPressed: () {
                if( _formKey.currentState!.validate() ){
                  // TODO: Enviar datos al backend
                  _formKey.currentState!.save();

                  _postLogin( _email, _password )
                  .then( ( val ){
                    if( val ?? false ){
                      //Iniciar sesión y redireccionar
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserList()) );
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
          ],
        )
      )
    );
  }
}