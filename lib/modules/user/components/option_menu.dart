import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/user/user_form.dart';
import 'package:box_nova/modules/user/user_list.dart';
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

  dynamic _messageState( context, message ){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar( content: Text(message,
        textAlign: TextAlign.center),
        duration: Duration(seconds: 2) )
    );
  }

  void _handleActions( ActionItem action ) async {
    if( action == ActionItem.view ){
      showModalBottomSheet<void>(
        context: context,
        // sheetAnimationStyle: _animationStyle,
        builder: viewUser
      );
    }
    else if( action == ActionItem.edit ){
      // print('Editando ${widget.user["_id"]}');
      // print(widget.user["state"]);
      // print( widget.user );
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm( user: widget.user )));
    }
    else if( action == ActionItem.delete ) {
      bool isDeleted = await UserModel.deleteUser( widget.user["_id"] );
      if( isDeleted ){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserList()));
        _messageState(context, "Usuario eliminado");
      }
      else{
        _messageState(context, "No se ha podido eliminar el usuario");
      }
    }
    else if( action == ActionItem.state ){
      bool isChanget = await UserModel.updateUser( widget.user["_id"], { "state":  !_state } );
      if( isChanget ){
        setState(() {
          _state =!_state;
        });
        String strAdvice = _state ?"activo" :"inactivo";
        _messageState(context, "Se ha cambiado el estado al usuario a " + strAdvice);
      }
      else{
        // TODO : hacer que sea posible aplicar cambios de estado en el lado del backend
        _messageState(context, "No se ha podido cambiar de estado al usuario");
      }
    }
  }

  Widget viewUser (BuildContext context){
    Map<String, dynamic> user = UserModel.fromMap( widget.user ).toMap();

    Widget info( title, text ){
      return Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 17, color: Colors.blueAccent )),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 15)),
        ],
      );
    }

    return SizedBox.expand(
      child:
      SingleChildScrollView(
      child: Padding(
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
    Icon iconType = _state ?Icon(Icons.check_circle_outline) :Icon(Icons.radio_button_unchecked_outlined);

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
        /*const PopupMenuItem<ActionItem>(
          value: ActionItem.edit,
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Editar'),
          ),
        ),*/
        /*const PopupMenuItem<ActionItem>(
          value: ActionItem.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Eliminar'),
          ),
        ),*/
        PopupMenuItem<ActionItem>(
          value: ActionItem.state,
          child: ListTile(
            leading: iconType,
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