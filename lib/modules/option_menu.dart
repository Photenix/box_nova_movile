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
              builder: (BuildContext context) {
                Map<String, dynamic> user = widget.user;
                return SizedBox.expand(
                  child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Información de el usuario ${user['username']}', style: TextStyle(fontSize: 20),),
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