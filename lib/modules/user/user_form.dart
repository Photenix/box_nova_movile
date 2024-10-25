import 'package:box_nova/models/User.dart';
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget{
  const UserForm({super.key, this.user});

  final Map<String,dynamic>? user;

  Widget _input( title ){
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( user == null ? 'Nuevo Usuario' : 'Actualizar Usuario'),
      ),
      body: Center(
        child: Container(
          child: Form(child: Column(
            children: [
              _input("Nombre"),
              _input("Apellido"),
              _input("Correo"),
              _input("Documento de Identidad"),
              _input("Telefono"),
              _input("Dirección"),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 10)
            ],
          )),
        )
      )
    );
  }
}