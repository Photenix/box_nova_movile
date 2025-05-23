import 'package:flutter/material.dart';
import 'package:box_nova/models/User.dart';

dynamic traduction = {
  "Admin": "Administrador",
  "Worker": "Empleado",
  "Client": "Cliente",
};

class UserCardGrid extends StatefulWidget {
  final List<Map<String, dynamic>> initialUsers;

  const UserCardGrid({
    Key? key,
    required this.initialUsers,
  }) : super(key: key);

  @override
  _UserCardGridState createState() => _UserCardGridState();
}


class _UserCardGridState extends State<UserCardGrid> {
  late List<Map<String, dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _users = List<Map<String, dynamic>>.from(widget.initialUsers);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleUserState(Map<String, dynamic> user) async {
    try {
      final success = await UserModel.updateUser(
          user["_id"],
          {"state": !user['state']}
      );

      if (success) {
        setState(() {
          final index = _users.indexWhere((u) => u['_id'] == user['_id']);
          if (index != -1) {
            _users[index]['state'] = !_users[index]['state'];
          }
        });
        _showMessage("Estado actualizado");
      } else {
        _showMessage("No se pudo cambiar el estado");
      }
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserCard(user);
      },
    );
  }


  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      elevation: 3,
      child: InkWell(
        // onTap: () => _showUserDetails(user),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con avatar y estado
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: user['state'] ? Colors.purple[100] : Colors.grey,
                    child: Text(
                      '${user['firstName'][0]}${user['lastName'][0]}',
                      style: TextStyle(color: Colors.purple[800]),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        user['state'] ? Icons.verified : Icons.block,
                        key: ValueKey<bool>(user['state']),
                      ),
                    ),
                    color: user['state'] ? Colors.green : Colors.red,
                    onPressed: () => _toggleUserState(user),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Información principal
              Text(
                '${user['firstName']} ${user['lastName']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                user['documentNumber'],
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),

              // Información adicional
              _buildInfoRow(Icons.email, user['email'] ?? 'Sin email'),
              SizedBox(height: 8),
              _buildInfoRow(Icons.phone, user['phone'] ?? 'Sin teléfono'),
              SizedBox(height: 8),
              _buildInfoRow(Icons.supervised_user_circle, traduction[user['rol']] ?? user['rol']),
              Spacer(),

              // Botones de acción
              Row(
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.edit, size: 20),
                  //   onPressed: () => _editUser(user),
                  // ),
                  Spacer(),
                  TextButton(
                    child: Text('VER DETALLE'),
                    onPressed: () => _showUserDetails(context, user),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _editUser(Map<String, dynamic> user) {
    // Implementa la lógica de edición aquí
    print(user);
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${user['firstName']} ${user['lastName']}'),
            Text('Documento: ${user['documentNumber']}'),
            if (user['email'] != null) Text('Email: ${user['email']}'),
            if (user['phone'] != null) Text('Teléfono: ${user['phone']}'),
            Text('Rol: ${traduction[user['rol']] ?? user['rol']}'),
            SizedBox(height: 8),
            Text('Estado: ${user['state'] ? 'Activo' : 'Inactivo'}',
              style: TextStyle(
                color: user['state'] ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('CERRAR'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}