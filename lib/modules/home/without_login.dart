import 'package:box_nova/modules/access/login.dart';
import 'package:flutter/material.dart';

class WithoutLogin extends StatefulWidget{
  const WithoutLogin({super.key, required this.title});

  final String title;

  @override
  _WithoutLoginState createState() => _WithoutLoginState();
}

class _WithoutLoginState extends State<WithoutLogin> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text( 'Bienvenido' ),
            SizedBox(
              height: 250.0,
              width: 350.0,
              child: Image.asset('assets/images/Logo.jpeg'),
            ),
            SizedBox(height: 20.0),
            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));},
              child: Text("Ingresar", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
            ),
            SizedBox(height: 20.0),
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));},
              child: Text("Registrarse", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
            )
          ],
        ),
      )
    );
  }
}