import 'package:flutter/material.dart';

/// Flutter code sample for [PopupMenuButton].

// This is the type used by the popup menu below.
enum ActionItem { view, edit, delete }

class OptionMenu extends StatefulWidget {
  const OptionMenu({super.key, required this.id });

  final String id;

  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  ActionItem? selectedItem;

  void _handleActions( ActionItem action ){
    if( action == ActionItem.view ){
      print('Viendo información de ${widget.id}');
    }
    else if( action == ActionItem.edit ){
      print('Editando ${widget.id}');
    }
    else if( action == ActionItem.delete ){
      print('Eliminando ${widget.id}');
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
