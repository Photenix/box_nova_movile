import 'package:box_nova/models/User.dart';
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget{
  UserForm({super.key, this.user});

  final Map<String,dynamic>? user;

  Map<String,dynamic> newUser = {};

  final _formKey =  GlobalKey();

  Widget _input( title, realKey, { String? initValue } ){
    return TextFormField(
      initialValue: initValue,
      onChanged: (value){
        newUser[realKey] = value;
      },
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
          padding: EdgeInsets.all(18),
          child: Form(child: Column(
            key: _formKey,
            children: [
              _input("Nombre", "firstName", initValue: user?["firstName"] ),
              _input("Apellido", "lastName",initValue: user?["lastName"] ),
              _input("Correo", "email", initValue: user?["email"] ),
              _input("Documento de Identidad", "documentNumber",initValue: user?["documentNumber"] ),
              _input("Telefono", "phone", initValue: user?["phone"] ),
              _input("Dirección", "address", initValue: user?["address"] ),
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