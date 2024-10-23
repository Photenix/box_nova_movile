import 'dart:convert';

import 'package:box_nova/models/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class UserList extends StatelessWidget {
  const UserList({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      // body: ListView.builder(
      //   itemCount: 100,
      //   itemBuilder: (context, index) {
      //     return UserCard(name: 'User $index');
      //   },
      // ),
      body: UserTable(),
    );
  }
}


class UserTable extends StatefulWidget {
  const UserTable({ super.key });
  
  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  // List<UserModel> user = [];
  List users = [];
  

  Future<UserModel?> _getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    var url = Uri.parse('https://boxnovan.onrender.com/api/auth/user');
    var response = await http.get(url,
      headers: {
        'authorization': token
      }
    );

    print( response.body );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print( jsonResponse ); 
      setState(() {
        users = jsonResponse;
      });
      // return UserModel.fromJson(jsonResponse);
    } else {
      print('Error getting users: $response.statusCode');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    print("hi");
    _getUsers();
  }

  //! Ver como funcionan las ToolTips y como puedeo implementarlas
  
  @override
  Widget build(BuildContext context) {
    return 
    DataTable(
      columns: [
        DataColumn(label: Text('Nombre', textAlign: TextAlign.center,)),
        DataColumn(label: Text('Correo')),
        DataColumn(label: Text('Opciones')),
      ],
      // rows: [
      //   DataRow(cells: [
      //     DataCell(Text("Juan")),
      //     DataCell(Text("Juan")),
      //     DataCell(Text("Juan")),
      //   ])
      // ],
      rows: users.map( (user){
        return DataRow(cells: [
          DataCell(Text(user['username'])),
          DataCell(Text(user['email'])),
          DataCell(
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // TODO: Implement options menu
                },
              ),
          ),
        ]);
      }).toList()
    );
  }
}
