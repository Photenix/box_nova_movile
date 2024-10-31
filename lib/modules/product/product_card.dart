import 'dart:math';

import 'package:box_nova/modules/product/product_details.dart';
import 'package:box_nova/modules/product/product_list.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';

enum cardOptions { edit, delete, state }

class ProductCard extends StatelessWidget {
  final Map product;
  String id = "";
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

  
  Color editColor = Color.fromARGB(255, 253, 228, 0);

  ProductCard(this.product, { super.key }){
    // print( product );
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
        ),
        SizedBox(width: 8.0),
        Wrap(
          children: [
            Text('Stock: ', style: titleStyle,),
            Text('${product["totalQuantity"]}'),
          ],
        ),
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
    int b = ram.nextInt(130); b += 125;
    int g = ram.nextInt(130); g += 125;
    int r = ram.nextInt(130); r += 125;
    return CircleAvatar( child: Text(product["name"][0].toString().toUpperCase()), backgroundColor: Color.fromARGB(b, g, r, 255), );
  }


  void handleOptions( option ){
    if( option == cardOptions.edit ){
      print("venga lo edito bebe");
    }
    else if( option == cardOptions.delete ){
      print("Bum muerto cuchillo pa matarte");
    }
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
              child: ProductDetails( products: product["details"],),
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
                  // cardA.currentState?.expand();
                  handleOptions( cardOptions.edit );
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
              BtnDelete()
            ],
          ),
        ],
      ),
    );
  }
}
