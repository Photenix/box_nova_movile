import 'dart:convert';

import 'package:box_nova/models/Access.dart';
import 'package:box_nova/modules/home/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', textAlign: TextAlign.justify),
      ),
      body:
      SingleChildScrollView(
      child:
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: const Center(
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

  String? _msgInvalidPassword;

  String? _validMessage ( value ){
    return (value == null || value.isEmpty) ?"Ingrese el campo en su totalidad" :null;
  }

  Future<bool?> _postLogin ( email, password ) async {
    
    setState(() {
      _isLoading = true;
    });

    try {
      String info = dotenv.get('API_URL', fallback: '');
      var url = Uri.parse( "${info}login" );
      var response = await http.post(url,
        body: {
          "email": email,
          "password": password,
        }
      );

      // print( response.body );
      // bottomMessage(context, response.body);

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
      return false;
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
          const SizedBox(height: 20.0),
          TextFormField(
            textAlign: TextAlign.center,
            validator: _validMessage,
            onSaved: ( value ){ _email = value; },
            decoration: const InputDecoration(
              hintText: 'Correo',
            ),
            onTapOutside: (event) => {
              print(event)
            },
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 24),
          _isLoading 
          ? const CircularProgressIndicator()
          : ElevatedButton(
            onPressed: () {
              if( _formKey.currentState!.validate() ){
                //? Enviar datos al backend
                _formKey.currentState!.save();

                _postLogin( _email, _password )
                .then( ( val ){
                  if( val ?? false ){
                    //Iniciar sesión y redireccionar
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Admin()) );
                  }else {
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
            child: const Text("Ingresar"),
          ),
          const SizedBox(height: 12,),
          _isLoading
          ? ElevatedButton(
            onPressed: () {
              setState(() { _isLoading = false; });
            },
            child: const Text("Cancelar"),
          )
          : const SizedBox(),
        ],
      )
    );
  }
}