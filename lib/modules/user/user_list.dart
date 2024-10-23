import 'package:box_nova/models/User.dart';
import 'package:flutter/material.dart';

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
  List<UserModel> user = [];

  @override
  void initState() {
    super.initState();
    // fetchUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Nombre', textAlign: TextAlign.center,)),
        DataColumn(label: Text('Correo')),
        DataColumn(label: Text('Opciones')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Juan")),
          DataCell(Text("Juan")),
          DataCell(Text("Juan")),
        ])
      ],
    );
  }
}
