import 'package:box_nova/main.dart';
import 'package:box_nova/modules/category/category_list.dart';
import 'package:box_nova/modules/user/user_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatelessWidget{
  

  @override
  Widget build(BuildContext context) {

    void _exit() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      print("Saliendo a inicio");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Inicio") ));
      // SystemNavigator.pop();
    }

    // TODO: Agregarle iconos a los buttons
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de administración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 250.0,
              width: 350.0,
              child: Image.asset('assets/images/Logo.jpeg'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {Navigator.push(context, 
                MaterialPageRoute(builder: (context) => UserList()));},
              child: Text('Listado de usuarios'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Navigator.push(context, 
                MaterialPageRoute(builder: (context) => CategoryList()));},
              child: Text('Listado de categoria'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exit,
              child: Text("Salir", style: TextStyle( color: Colors.red ),)
            )
          ],
        )
      ),
    );
  }
}