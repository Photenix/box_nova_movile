import 'package:box_nova/models/CategoryModel.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget{
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  CategoryType _categories = [];

  void getAllCategory() async {
    CategoryType categories = await CategoryModel.getCategories();
    setState(() {
      _categories = categories;
    });
    print( categories.toString() );
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  //TODO: add support of delete, update, create and change state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            var cat = _categories[index];
            List subCat = cat!["subCategorias"] ?? [];
            print(cat);

            return ListTile(
              title: Text('${cat!["nombre"]}'),
              subtitle: Row(
                children: subCat.map( (element) {
                  return Text(' - ${element["nombre"]}', style: TextStyle(fontSize: 16.0));
                }).toList()
              ),
            );
          },
        ),
      ),
    );
  }
}