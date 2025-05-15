
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget{
  const ProductDetails({super.key, required this.products});
  final List products;

  Widget cardDetail( context, { src, details }){
    Widget cardImg() {
      if( src!= null ){
        return Image.network( src,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      }
      else { return Container( color: Colors.black12 ); }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4),
          child:
          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: getInfo(context, details)
              ),
            ),
            child:
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  cardImg(),
                  Center(
                    child: showInfo( context, details ),
                  )
                ],
              ),
            )
          )
        )
      ],
    );
  }

  Widget showInfo(context, details){
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: getInfo(context, details)
        ),
      ),
      // child: const Text('Ver detalle',
      //   style: TextStyle(
      //     backgroundColor: Colors.black12,
      //     color: Colors.white,
      //   )
      // ),
      child: const Icon(Icons.visibility_outlined),
    );
  }

  Widget getInfo( context, detail ){
    TextStyle? style = const TextStyle(fontWeight: FontWeight.bold);

    return
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child:
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Color', style: style ),
        Text('${detail["color"]}'),
        const SizedBox(height: 15),
        Text('Tamaño', style: style ),
        Text('${detail["size"]}'),
        const SizedBox(height: 15),
        Text('Cantidad', style: style ),
        Text('${detail["quantity"]}'),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = products
      .map( (detail) => cardDetail(context, src: detail["image"], details: detail) )
      .toList();

    return Center(
      child:
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: list,
      )
    );
  }
}