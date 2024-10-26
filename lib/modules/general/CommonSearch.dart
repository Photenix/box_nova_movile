import 'package:flutter/material.dart';

class Commonsearch extends StatelessWidget{

  Commonsearch({ required this.handleFind });
  final handleFind;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            // onTap: () {
            //   // controller.openView();
            //   print("coma codornis");
            //   print( controller.text );
            // },
            onChanged: handleFind,
            onSubmitted: handleFind,
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder:
          (BuildContext context, SearchController controller) {
            return [
              ListTile(
                title: Text(''),
                onTap: () {
                },
              )
            ];
          }
      )
    );
  }
}