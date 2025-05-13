import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/CommonSearch.dart';
import 'package:box_nova/modules/product/product_card.dart';
import 'package:box_nova/modules/product/product_form.dart';
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
      // floatingActionButton: FloatingActionButton(
      //   tooltip: "Crear nuevo producto",
      //   onPressed: () {
      //     Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => ProductForm()));},
      //     // MaterialPageRoute(builder: (context) => CameraInitializer()));},
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

