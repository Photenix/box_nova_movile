import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', textAlign: TextAlign.center),
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

  bool _isLoading = false;

  Future<bool?> _postLogin ( email, password ) async {
    
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('https://boxnovan.onrender.com/api/login');
    var response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    var body = json.decode( response.body );
    return body!["success"];
  }

  @override
  Widget build(BuildContext context) {
    final _formKey =  GlobalKey<FormState>();

    String? _validMessage ( value ){
      return (value == null || value.isEmpty) ?"Ingrese el campo en su totalidad" :null;
    }
    
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
            decoration: InputDecoration(
              hintText: 'Contraseña',
            ),
          ),
          SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if( _formKey.currentState!.validate() ){
                // TODO: Enviar datos al backend
                print("Login correcto");
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