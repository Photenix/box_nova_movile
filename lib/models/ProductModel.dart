import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:box_nova/models/Access.dart';

typedef ProductType = List<Map<String,dynamic>>;

class ProductModel {

  static String basicUrl = "https://boxnovan.onrender.com/api/auth/product";

  static Future<ProductType> getProducts () async {
    var token = await Access.getToken();

    var url = Uri.parse(basicUrl);
    var response = await http.get(url, 
      headers: {
        'authorization': token
      }
    );
    if (response.statusCode == 200) return ProductType.from(json.decode(response.body));
    else throw Exception('Failed to load products');
  }
}