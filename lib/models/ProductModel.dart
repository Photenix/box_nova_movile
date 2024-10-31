import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
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

  static Future<ProductType> searchProducts( value ) async {
    var token = await Access.getToken();
    var url = Uri.parse(basicUrl+"/search");
    var response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token
      },
      body: json.encode({
        'find': value
      })
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return ProductType.from(data["data"]);
    }
    else throw Exception('Failed to load products');
  }

  static Future<bool> deleteProduct (String id, Map<String, dynamic> data) async{
    var token = await Access.getToken();
    var url = Uri.parse(basicUrl+"/"+id);
    var response = await http.delete(url, 
      headers: {
        'authorization': token
      }
    );
    if (response.statusCode == 200) return true;
    return false;
  }

  static Future< String > uploadImage ( XFile image ) async {
    var token = await Access.getToken();

    // Leer la imagen como bytes
    final bytes = await File(image.path).readAsBytes();
    // Convertir los bytes a base64
    String base64Image = base64Encode(bytes);

    // Crear el cuerpo de la solicitud
    final body = jsonEncode(
      {
        'data': 'data:image/jpeg;base64,$base64Image'
      }
    );

    var url = Uri.parse(basicUrl+"/img");

    // Hacer la solicitud POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token, // Si necesitas autorización
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Imagen subida con éxito');
      final jsonResponse = json.decode(response.body);
      String imageUrl = jsonResponse['img']; // Obtén la URL de la respuesta
      print('Imagen subida con éxito: $imageUrl');
      return "";
    } else {
      print('Error al subir la imagen');
      print(response.body);
      return "";
    }
  }
}