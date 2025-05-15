import 'package:box_nova/main.dart';
import 'package:box_nova/modules/product/product_list.dart';
import 'package:box_nova/modules/user/user_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatelessWidget{
  const Admin({super.key});

  

  @override
  Widget build(BuildContext context) {

    void exit() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      print("Saliendo a inicio");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Inicio") ));
      // SystemNavigator.pop();
    }

    // TODO: Agregarle iconos a los buttons
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Panel de administración'),
      ),
      body:
      SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 250.0,
              width: 350.0,
              child: Image.asset('assets/images/Logo.jpeg'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const UserList()));},
              child: const Text('Listado de usuarios'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const ProductList()));},
              child: const Text('Listado de productos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: exit,
              child: const Text("Cerrar sección", style: TextStyle( color: Colors.red ),)
            ),
            const SizedBox(height: 20.0),
            const Text( 'Proyecto creado por Juan Manuel Pino Ross año 2024',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center, ),
          ],
        )
      ),
      )
    );
  }
}