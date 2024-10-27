import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/general/CommonSearch.dart';
import 'package:box_nova/modules/option_menu.dart';
import 'package:box_nova/modules/user/user_form.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({ super.key });

  // TODO: Agregar funcionalidad
  void _findUser( value ){
    if( value.length > 3 ){
      print( value );
    }
    else{
      print("Todos");
    }
  }
  
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
      body: UserBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Agregar usuario",
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm()));},
        child: const Icon(Icons.add),
      )
      // floatingActionButton: Builder(
      //   builder: (context) => FloatingActionButton(
      //     child: const Icon(Icons.search),
      //     onPressed: () async{
      //       await showSearch(context: context, delegate: CustomSearchDelegate());
      //     }
      //   )
      // ),
    );
  }
}

class UserBody extends StatefulWidget{
  const UserBody({ super.key });
  @override
  _UserBodyState createState() => _UserBodyState();
}


typedef UserType = List<Map<String,dynamic>>;
class _UserBodyState extends State<UserBody> {

  UserType _userData = [];

  void _findUser( String value ) async {
    if( value.length > 4 ){
      UserType user = await UserModel.findUsers( value );
      if( user.length > 0 ){
        setState(() {
          _userData = user;
        });
      }
    }
    if( value.length == 0 ){
      _getAllUsers();
    }
  }

  void _getAllUsers() async {
    UserType user = await UserModel.getUsers();
    if( user.length > 0 ){
      setState(() {
        _userData = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
    
    SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Commonsearch( handleFind: _findUser, ),
            SizedBox( height: 8, ),
            UserTable( usersList: _userData ),
            SizedBox(height: 70,)
          ]
        )
      ),
    );
  }
}
class UserTable extends StatelessWidget {
  const UserTable({ super.key, required this.usersList });
  final UserType usersList;

  String shortString ( String text, {int end = 5 } ){
    if( end > text.length ) return '${text.substring(0, text.length)}';
    return '${text.substring(0, end)}...';
  }
  
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Documento')),
        DataColumn(label: Text('Nombre', textAlign: TextAlign.center,)),
        DataColumn(label: Text('Opciones')),
      ],
      rows: usersList.map( (user){
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
          ],
          color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            return user['state']? Colors.transparent : const Color.fromARGB(54, 85, 85, 85);
          }),
        );
      }).toList()
    );
  }
}