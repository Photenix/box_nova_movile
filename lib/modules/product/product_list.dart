import 'dart:math';

import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/camera_user.dart';
import 'package:box_nova/modules/product/product_make.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';


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
      body: ListView(
        children: _productList.map((product)=> ProductCard(product) ).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, 
          // MaterialPageRoute(builder: (context) => ProductMake()));},
          MaterialPageRoute(builder: (context) => CameraInitializer()));},
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map product;
  String id = "";
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  
  Color editColor = Color.fromARGB(255, 253, 228, 0);

  ProductCard(this.product, { super.key }){
    print( product );
    id = product["_id"];
    previewImage();
  }


  Widget classificationIcon( String classification ){
    if( classification == "Male" ){
      return const Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Axis.horizontal,
        children: <Widget>[
          Icon(Icons.male, size: 20),
          Icon(Icons.man, size: 20)
        ],
      );
    }
    else if( classification == "Female" ){
      return const Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Axis.horizontal,
        children: <Widget>[
          Icon(Icons.female, size: 20,),
          Icon(Icons.woman, size: 20)
        ],
      );
    }
    else return const Icon(Icons.no_adult_content, size: 20);
  }

  Widget previewInfo(){

    final titleStyle = TextStyle(fontWeight: FontWeight.w500);

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text('Precio: ', style: titleStyle,),
        Text('${NumberFormat.simpleCurrency(decimalDigits: 0).format(product["price"])}'),
        SizedBox(width: 8.0),
        Wrap(
          children: [
            Text('Categoría: ', style: titleStyle,),
            Text('${product["category"]}'),
          ],
        ),
        SizedBox(width: 8.0),
        Wrap(
          children: [
            Text('Clasificación: ', style: titleStyle,),
            classificationIcon( product["classification"] ),
          ],
        )
      ],
    );
  }

  Widget previewImage(){
    for (var element in product["details"]) {
      if( element?["image"] != null ){
        return CircleAvatar( backgroundImage: NetworkImage(element["image"]) );
      }
    }

    var ram = Random();

    int b = ram.nextInt(130);
    b += 125;
    int g = ram.nextInt(130);
    g += 125;
    int r = ram.nextInt(130);
    r += 125;

    return CircleAvatar( child: Text(product["name"][0].toString().toUpperCase()), backgroundColor: Color.fromARGB(b, g, r, 255), );
  }

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: ExpansionTileCard(
        key: cardA,
        baseColor: const Color.fromARGB(31, 180, 180, 180),
        leading: previewImage(),
        title: Text( product["name"], style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        subtitle: previewInfo(),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                """Hi there, I'm a drop-in replacement for Flutter's ExpansionTile.

Use me any time you think your app could benefit from being just a bit more Material.

These buttons control the next card down!""",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            buttonHeight: 52.0,
            buttonMinWidth: 90.0,
            children: <Widget>[
              TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  cardA.currentState?.expand();
                },
                child: Column(
                  children: <Widget>[
                    Icon(Icons.edit_outlined, color: editColor),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text('Editar',),
                  ],
                ),
              ),
              // TextButton(
              //   style: flatButtonStyle,
              //   onPressed: () {
              //     cardA.currentState?.collapse();
              //   },
              //   child: const Column(
              //     children: <Widget>[
              //       Icon(Icons.arrow_upward),
              //       Padding(
              //         padding: EdgeInsets.symmetric(vertical: 2.0),
              //       ),
              //       Text('Close'),
              //     ],
              //   ),
              // ),
              TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  cardA.currentState?.toggleExpansion();
                },
                child: const Column(
                  children: <Widget>[
                    Icon(Icons.delete_outline, color: Colors.red,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text('Eliminar', selectionColor: Colors.red,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}