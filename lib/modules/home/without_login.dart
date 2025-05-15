import 'dart:convert';

import 'package:box_nova/models/Access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:box_nova/modules/home/admin.dart';
import 'package:http/http.dart' as http;

class WithoutLogin extends StatefulWidget{
  const WithoutLogin({super.key, required this.title});

  final String title;

  @override
  _WithoutLoginState createState() => _WithoutLoginState();
}

class _WithoutLoginState extends State<WithoutLogin> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  String? _msgInvalidPassword;

  String? _validMessage ( value ){
    return (value == null || value.isEmpty) ?"Ingrese el campo en su totalidad" :null;
  }

  bool _isLoading = false;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80),
              // Logo de la empresa
              Image.asset(
                'assets/images/Logo.jpeg', // Reemplaza con la ruta de tu logo
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 40),
              Text(
                'Bienvenido a Estilos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[500]
                ),
              ),
              const SizedBox(height: 30),
              // Campo de email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email)
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validMessage,
              ),
              const SizedBox(height: 20),
              // Campo de contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  errorText: _msgInvalidPassword
                ),
                obscureText: true,
                validator: _validMessage,
              ),
              const SizedBox(height: 30),
              // Botón de login
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                _isLoading
                ?const CircularProgressIndicator()
                :ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Aquí iría la lógica de autenticación
                    if (_formKey.currentState!.validate()) {
                      _postLogin( _emailController.text, _passwordController.text )
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
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          )
        ),
      ),
    );
  }
}