// class UserTable extends StatefulWidget {
//   const UserTable({ super.key, required this.usersList });
//   final usersList;
  
//   @override
//   _UserTableState createState() => _UserTableState();
// }

/*
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

    // print( response.body );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // print( jsonResponse ); 
      setState(() {
        users = jsonResponse;
      });
      // return UserModel.fromJson(jsonResponse);
    } else {
      print('Error getting users: $response.statusCode');
      return null;
    }
  }

  String shortString ( String text, {int end = 5 } ){
    if( end > text.length ) return '${text.substring(0, text.length)}';
    return '${text.substring(0, end)}...';
  }

  @override
  void initState() {
    super.initState();
    // _getUsers();
    setState(() {
      users = widget.usersList;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return 
    DataTable(
      columns: [
        DataColumn(label: Text('Documento')),
        DataColumn(label: Text('Nombre', textAlign: TextAlign.center,)),
        DataColumn(label: Text('Opciones')),
      ],
      rows: users.map( (user){
        return DataRow(cells: [
          DataCell(
            Tooltip(
              message: user['documentNumber'],
              child: Text(shortString(user['documentNumber'])),
            )
          ),
          DataCell(
            Tooltip(
              message: '${user['firstName']} ${user['lastName']}',
              child: Text(shortString('${user['firstName']} ${user['lastName']}', end: 20), textAlign: TextAlign.center,)
            )
          ),
          DataCell( OptionMenu( user: user ) ),
        ]);
      }).toList(),
    );
  }
}
*/


import 'package:flutter/material.dart';

class UserFinder extends StatelessWidget {
  UserFinder({ required this.handleFind });
  final handleFind;
  final TextEditingController _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( vertical: 20, horizontal: 12 ),
      child: Form(child: Column(
        children: [
          TextFormField(
            // onChanged: handleFind,
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Buscar usuario',
            ),
          ),
          SizedBox( height: 8, ),
          ElevatedButton(
            onPressed: (){
              var text = _controller.text;
              handleFind( text );
              _controller.text = text;
            },
            child: Text('Buscar'),
          )
        ],
      )),
    );
  }
}
