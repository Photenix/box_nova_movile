import 'package:flutter/material.dart';

class UserModel {
  String? id, username, email, name, typeIdentifier,
  documentNumber, phone, address, birthdate, rol;
  bool? state;

  UserModel({ this.id, this.username, this.email, this.name });

  UserModel.fromMap(Map<String, dynamic> map) {
    DateTime date = DateTime.parse(map["birthdate"]);
    id = map['_id'];
    username = map['username'];
    email = map['email'];
    name = '${map['firstName']} ${map['lastName']}';
    typeIdentifier = map['typeIdentifier'];
    documentNumber = map['documentNumber'];
    phone = map['phone'];
    address = map['address'];
    state = map['state'];
    birthdate = '${date.day}/${date.month}/${date.year}';
    rol = getRol(map['rol']);
  }

  String getRol( String rol ){

    Map<String, dynamic> traslated = {
      "Admin": 'Administrador',
      "Worker": 'Empleado',
      "Client": 'Cliente'
    };

    return traslated[rol]?? 'Desconocido';
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'name': name,
      'typeIdentifier': typeIdentifier,
      'documentNumber': documentNumber,
      'phone': phone,
      'address': address,
      'birthdate': birthdate,
      'rol': rol,
      'state': state,
    };
  }
}