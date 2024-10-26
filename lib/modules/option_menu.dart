import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/user/user_form.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [PopupMenuButton].

// This is the type used by the popup menu below.
enum ActionItem { view, edit, delete, state }

class OptionMenu extends StatefulWidget {
  const OptionMenu({super.key, required this.user });

  final user;

  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  ActionItem? selectedItem;
  bool _state = true;

  void _handleActions( ActionItem action ){
    if( action == ActionItem.view ){
      showModalBottomSheet<void>(
        context: context,
        // sheetAnimationStyle: _animationStyle,
        builder: viewUser
      );
    }
    else if( action == ActionItem.edit ){
      print('Editando ${widget.user["_id"]}');
      print(widget.user["state"]);
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm( user: widget.user )));
    }
    else if( action == ActionItem.delete ){
      print('Eliminando ${widget.user["_id"]}');
    }
    else if( action == ActionItem.state ){
      setState(() {
        _state =!_state;
      });
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
  void initState() {
    super.initState();
    setState(() {
      _state = widget.user["state"];
    });
  }

  @override
  Widget build(BuildContext context) {

    Color iconColor = _state ?Colors.green :Colors.red;

    return Center(
      child: PopupMenuButton<ActionItem>(
      initialValue: selectedItem,

      onSelected: (ActionItem item) {
        _handleActions(item);
      },

      // itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
        const PopupMenuItem(
          value: ActionItem.view,
          child: const ListTile(
            leading: Icon(Icons.visibility_outlined),
            title: Text('Detalle'),
          ),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.edit,
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Editar'),
          ),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Eliminar'),
          ),
        ),
        PopupMenuItem<ActionItem>(
          value: ActionItem.state,
          child: ListTile(
            leading: Icon(Icons.check_circle_outline),
            iconColor: iconColor,
            title: Text('Estado'),
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