import 'dart:convert';

import 'package:box_nova/models/Access.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef UsersType = List<Map<String, dynamic>>;
class UserModel {
  String? id, username, email, name, typeIdentifier, firstName, lastName,
  documentNumber, phone, address, birthdate, rol;
  
  bool? state;

  //String URL_PROJECT = dotenv.env['API_URL'] ?? "http://localhost:80";

  UserModel({ this.id, this.username, this.email, this.name });

  UserModel.fromMap(Map<String, dynamic> map) {
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
    birthdate = UserModel.formatBirthDate(map['birthdate']);
    rol = getRol(map['rol']);
  }

  String getRol( String rol ){

    Map<String, dynamic> traslated = {
      "Admin": 'Administrador',
      "Worker": 'Empleado',
      "Client": 'Cliente'
    };

    // return traslated[rol]?? 'Desconocido';
    return traslated[rol]?? rol;
  }

  static String formatBirthDate( String birthday ){
    DateTime date = DateTime.parse( birthday );
    // print(DateFormat('dd/MM/yyyy').format(date));
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static Future<UsersType> getUsers( ) async {
    var token = await Access.getToken();

    String info = dotenv.get('API_URL', fallback: '');
    var url = Uri.parse( info + "auth/user");
    var response = await http.get(url,
      headers: {
        'authorization': token
      }
    );

    //print( response.body );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UsersType.from(jsonResponse);
    } else {
      print('Error getting users: $response.statusCode');
      return [];
    }
  }

  static Future< UsersType > findUsers( String find  ) async {
    var token = await Access.getToken();

    String info = dotenv.get('API_URL', fallback: '');
    var url = Uri.parse( info + "auth/user/search");
    var response = await http.post(url,
      headers: {
        'authorization': token
      },
      body:{
        'find': find
      }
    );
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UsersType.from(jsonResponse);
      // return UserModel.fromJson(jsonResponse);
    } else {
      print('Error getting users: ${response.statusCode}');
      return [];
    }
  }

  static Future<bool> createUser( user ) async{
    var token = await Access.getToken();

    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/user');
    var response = await http.post(url,
      headers: {
        'authorization': token
      },
      body: user
    );

    print( response.body );

    if (response.statusCode == 200)  return true;
    else return false;
  }

  static Future<bool> updateUser( id, user ) async{
    var token = await Access.getToken();

    var insertBody = {
      "id": '$id',
      "changes": user
    };

    // print( user );

    String info = dotenv.get('API_URL', fallback: '');
    var url = Uri.parse( info + "auth/user");
    var response = await http.put(url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token
      },
      body: jsonEncode( insertBody )
    );

    // print( response.body );

    if( response.statusCode == 200 ) return true;
    else return false;
  }

  static Future<bool> deleteUser( id ) async {
    var token = await Access.getToken();

    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/user/$id');
    var response = await http.delete(url,
      headers: {
        'authorization': token
      }
    );

    // print( response.body );

    return response.statusCode == 200;
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