import 'dart:convert';

import 'package:http/http.dart' as http;

class UserModel {
  String? id, username, email, name, typeIdentifier, firstName, lastName,
  documentNumber, phone, address, birthdate, rol;
  bool? state;

  UserModel({ this.id, this.username, this.email, this.name });

  UserModel.fromMap(Map<String, dynamic> map) {
    DateTime date = DateTime.parse(map["birthdate"]);
    id = map['_id'];
    username = map['username'];
    email = map['email'];
    firstName = map['firstName'];
    lastName = map['lastName'];
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

  static Future<Map<String,dynamic>?> getUsers( token ) async {
    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/user');
    var response = await http.get(url,
      headers: {
        'authorization': token
      }
    );

    // print( response.body );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromMap(jsonResponse).toMap();
      // return UserModel.fromJson(jsonResponse);
    } else {
      print('Error getting users: $response.statusCode');
      return null;
    }
  }

  static Future<void> deleteUser( id, token ) async {
    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/user/$id');
    var response = await http.get(url,
      headers: {
        'authorization': token
      }
    );
    if( response.statusCode == 200 ) {
      print('User eliminado correctamente');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
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