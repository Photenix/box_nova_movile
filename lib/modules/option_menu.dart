import 'package:box_nova/models/User.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [PopupMenuButton].

// This is the type used by the popup menu below.
enum ActionItem { view, edit, delete }

class OptionMenu extends StatefulWidget {
  const OptionMenu({super.key, required this.user });

  final user;

  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  ActionItem? selectedItem;

  void _handleActions( ActionItem action ){
    if( action == ActionItem.view ){
      print('Viendo información de ${widget.user}');
    }
    else if( action == ActionItem.edit ){
      print('Editando ${widget.user.id}');
    }
    else if( action == ActionItem.delete ){
      print('Eliminando ${widget.user.id}');
    }
  }

  Widget viewUser (BuildContext context){
    Map<String, dynamic> user = UserModel.fromMap( widget.user ).toMap();

    Widget info( title, text ){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 17, color: Colors.blueAccent )),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 15)),
        ],
      );
    }

    // DateTime date = DateTime.parse(user["birthdate"]);
    // user["birthdate"] = '${date.day}/${date.month}/${date.year}';

    return SizedBox.expand(
      child: 
      Padding(
        padding: EdgeInsets.all(12),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Información de el usuario ${user['username']}', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              info('Documento', '${user['typeIdentifier']}. ${user['documentNumber']}'),
              const SizedBox(height: 8,),
              info('Nombre', '${user['name']}'),
              const SizedBox(height: 8,),
              info('Correo', '${user['email']}'),
              const SizedBox(height: 8,),
              info('Telefono', '${user['phone']}'),
              const SizedBox(height: 8,),
              info('Dirección', '${user['address']}'),
              const SizedBox(height: 8,),
              info('Fecha de nacimiento', '${user['birthdate']}'),
              const SizedBox(height: 8,),
              info('Cargo', '${user['rol']}'),
              const SizedBox(height: 8,),
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<ActionItem>(
      initialValue: selectedItem,

      onSelected: (ActionItem item) {
        _handleActions(item);
        // setState(() {
        //   selectedItem = item;
        // });
      },

      // itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
        PopupMenuItem(
          value: ActionItem.view,
          child: const ListTile(
            leading: Icon(Icons.visibility_outlined),
            title: Text('Detalle'),
          ),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              // sheetAnimationStyle: _animationStyle,
              builder: viewUser
            );
          }
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.edit,
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Editar'),
          ),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.view,
          child: ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Estado'),
          ),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Eliminar'),
          ),
        ),
      ],
    ));
  }
}


class ModalDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: ActionItem.view,
      child: const ListTile(
            leading: Icon(Icons.visibility_outlined),
            title: Text('Detalle'),
          ),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          // sheetAnimationStyle: _animationStyle,
          builder: (BuildContext context) {
            return SizedBox.expand(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Modal bottom sheet'),
                    ElevatedButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}