import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/CommonSearch.dart';
import 'package:box_nova/modules/product/product_card.dart';
import 'package:box_nova/modules/product/product_make.dart';
import 'package:flutter/material.dart';


class ProductList extends StatefulWidget{
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  ProductType _productList = [];

  void _getProducts() async {
    try{
      ProductType products = await ProductModel.getProducts();
      setState(() {
        _productList = products;
      });
    }
    catch(e){
      print(e);
    }
  }

  void _findProducts( value ) async {
    try{
      ProductType products = await ProductModel.searchProducts(value);
      setState(() {
        _productList = products;
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Vista de productos'),
      ),
      body: Column(
        children: <Widget>[
          Commonsearch( handleFind: _findProducts, ),
          Expanded(child: ListView(
            children: _productList.map((product)=> ProductCard(product) ).toList()
          ),)
        ],

      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Crear nuevo producto",
        onPressed: () {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => ProductMake()));},
          // MaterialPageRoute(builder: (context) => CameraInitializer()));},
        child: Icon(Icons.add),
      ),
    );
  }
}

class BtnDelete extends StatelessWidget{

  void handleDelete( ){
    print("Bum muerto cuchillo pa matarte");
  }

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('¿Esta seguro de querer eliminar el usuario?'),
          content: const Text('Después de eliminado se borrara toda la información relacionada'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelado'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: (){
                handleDelete();
                Navigator.pop(context, 'Eliminado');
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
      style: flatButtonStyle,
      child: const Column(
        children: <Widget>[
          Icon(Icons.delete_outline, color: Colors.red,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text('Eliminar', selectionColor: Colors.red,),
        ],
      ),
    );
  }
}