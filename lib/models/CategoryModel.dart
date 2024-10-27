import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:box_nova/models/Access.dart';

typedef CategoryType = List<Map<String, dynamic>>;

class CategoryModel{


  static Future< CategoryType > getCategories() async{
    var token = await Access.getToken();

    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/category');
    var response = await http.get(url,
      headers: {
        'authorization': token
      }
    );

    // print( response.body );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CategoryType.from(jsonResponse);
    } else {
      print('Error getting users: $response.statusCode');
      return CategoryType.from([{}]);
    }

  }
}