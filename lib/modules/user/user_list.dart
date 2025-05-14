import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/general/CommonSearch.dart';
import 'package:box_nova/modules/general/pagination_controls.dart';
import 'package:box_nova/modules/user/components/option_menu.dart';
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
        centerTitle: true,
        title: Text('Usuarios'),
      ),
      body: UserBody()
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
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMore = true;

  TextEditingController _searchController = TextEditingController();

  void _findUser(  ) async {
    final query = _searchController.text.toLowerCase();
    if( query.length > 3 ){
      UserType user = await UserModel.findUsers( query );
      if( user.length > 0 ){
        setState(() {
          _userData = user;
        });
      }
    }
    if( query.length == 0 ){
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

  Future<void> _refreshUsers() async {
    setState(() {
      // _currentPage = 1;
      // _productList.clear();
    });
    _getAllUsers();
  }

  void _changeLimit(int newLimit) {
    setState(() {
      _limit = newLimit;
      _currentPage = 1;
      _userData.clear();
      _hasMore = true;
    });
    _getAllUsers();
  }

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    setState(() {});
    _searchController.addListener(_findUser);
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Usuarios'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar usuarios...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshUsers,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: UserTable(usersList: _userData),
                ),
              )
            ),
            // Commonsearch( handleFind: _findUser, ),
            // SizedBox( height: 8, ),
            // SizedBox(height: 70,)
            PaginationControls(
              currentPage: _currentPage,
              hasMore: _hasMore,
              limit: _limit,
              onPrevious: () {
                setState(() => _currentPage--);
                _getAllUsers();
              },
              onNext: () {
                setState(() => _currentPage++);
                _getAllUsers();
              },
              onChangeLimit: (newLimit) {
                _changeLimit(newLimit);
              },
            )
          ]
        )
      )
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