import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/general/pagination_controls.dart';
import 'package:box_nova/modules/user/components/option_menu.dart';
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
        title: const Text('Usuarios'),
      ),
      body: const UserBody()
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

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _quantity = 20;

  void _findUser(  ) async {
    final query = _searchController.text.toLowerCase();
    if( query.length > 3 ){
      setState(() {
        _isLoading = true; // Activar el estado de carga
      });
      UserType user = await UserModel.findUsers( query );
      setState(() {
        _userData = user;
        _isLoading = false;
      });
    }
    if( query.isEmpty ){
      _getAllUsers();
    }
  }

  void _getAllUsers() async {
    setState(() {
      _isLoading = true; // Activar el estado de carga
    });
    UserType user = await UserModel.getUsers(_currentPage, _limit);
    if( user.isNotEmpty ){
      setState(() {
        _userData = user;
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _currentPage = 1;
      _userData.clear();
      _searchController.clear();
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

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
    _getAllUsers();
  }

  void _getQuantityUsers() async {
    int quantity = await UserModel.quantityUsers();
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    setState(() {});
    _searchController.addListener(_findUser);
    _getQuantityUsers();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Usuarios'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar usuarios...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
        ),
      body:
      _isLoading
      ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Indicador de carga circular
            SizedBox(height: 16),
            Text('Cargando usuarios...'),
          ],
        ),
      )
      :
      _userData.isEmpty
      ?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No hay productos disponibles'
                  : 'No se encontraron resultados',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: _clearSearch,
                label: const Text(
                  "Limpiar busqueda",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[500],
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            )
          ],
        ),
      )
      :Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshUsers,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
    if( end > text.length ) return text.substring(0, text.length);
    return '${text.substring(0, end)}...';
  }
  
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
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
          color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            return user['state']? Colors.transparent : const Color.fromARGB(54, 85, 85, 85);
          }),
        );
      }).toList()
    );
  }
}