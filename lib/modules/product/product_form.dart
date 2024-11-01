import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/common_message.dart';
import 'package:box_nova/modules/product/product_detail_form.dart';
import 'package:box_nova/modules/product/product_list.dart';
import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';


class ProductForm extends StatefulWidget {
  ProductForm({ super.key, this.productInfo, this.id });

  final productInfo;
  final String? id;

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  List _details = [];

  String _titleText = "Crear un producto";
  String _buttonText = "Crear nuevo producto";

  Map<String, dynamic> _product = {};

  int totalProduct = 0;

  void _sentDetails( List newDetail ){
    int seeNumber = 0;
    setState(() {
      _details = newDetail;
      _details.forEach((e){
        int x = int.tryParse(e["quantity"]) ?? 0;
        seeNumber += x;
      });
      totalProduct = seeNumber;
      _controller.text = totalProduct.toString();
      _product["totalQuantity"] = totalProduct;
    });
  }

  String? isValid ( value ) {
    if( value.isEmpty ) return "Ingrese el campo";
    return null;
  }

  // TODO: Fix problem with de other things
  Widget _input( String title, String keyName, 
    { String? initVal, TextInputType? keyType, bool disable = false} ){

    return TextFormField(
      initialValue: initVal,
      onChanged: (value) {
        setState(() {
          _product[keyName] = value;
        });
      },
      validator: isValid,
      keyboardType: keyType,
      decoration: InputDecoration(
        labelText: title,
      ),
      readOnly: disable,
    );
  }

  @override
  void initState() {
    _controller.text = totalProduct.toString();
    setState(() {
      _product["totalQuantity"] = totalProduct;
      _product["classification"] = "Female";
      _product["category"] = "Camisa";
    });

    if( widget.id != null ){
      // print( widget.productInfo );
      setState(() {  
        _product = widget.productInfo;

        _details = widget.productInfo["details"];
        
        totalProduct = _product["totalQuantity"];
        _controller.text = totalProduct.toString();

        _titleText = "Modificar producto";
        _buttonText = "Modificar";
        // print(_product);
      });
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titleText),
      ),
      body:
      SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(  
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _input("Nombre de producto", "name", initVal: _product["name"]),
              const SizedBox(height: 18,),
              _input("Precio", "price", 
                keyType: TextInputType.number, 
                initVal: _product["price"] == null ?null :_product["price"].toString()
              ),
              const SizedBox(height: 18,),
              TextFormField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _product["totalQuantity"] = value;
                  });
                },
                validator: isValid,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cantidad",
                ),
                readOnly: true,
              ),
              const SizedBox(height: 18,),

              const SizedBox(height: 18,),
              const Text("Clasificación",),
              const SizedBox(height: 8,),
              CustomRadioButton(
                enableShape: true,
                shapeRadius: 20,
                // horizontal: true,
                elevation: 0,
                // absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: const [
                  'Niño',
                  'Niña',
                  'Hombre',
                  'Mujer',
                  "Unisex"
                ],
                buttonValues: const [
                  "Girl",
                  "Boy",
                  "Male",
                  "Female",
                  "Unisex",
                ],
                defaultSelected: _product["classification"],
                buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)
                ),
                radioButtonValue: (value) {
                  setState(() {
                    _product["classification"] = value;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 18,),
              const Text("Categoría",),
              const SizedBox(height: 8,),
              DropdownButtonFormField(
                onChanged: (value){
                  setState(() {
                    _product["category"] = value;
                  });
                },
                value: _product["category"],
                icon: const Icon(Icons.abc),
                padding: const EdgeInsets.all(2),
                items: const [
                  DropdownMenuItem(value: "Camisa", child: Text("Camisa")),
                  DropdownMenuItem(value: "Camiseta", child: Text("Camiseta")),
                  DropdownMenuItem(value: "Vestido", child: Text("Vestido")),
                ],
              ),
              const SizedBox(height: 18,),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Tienes ${_details.length} detalles"),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(context: context, 
                      builder: (BuildContext context) => Dialog.fullscreen(
                        child: DetailGeneral( sentDetails: _sentDetails, listDetails: _details, id: widget.id ?? "",))
                      );
                    },
                    child: const Text('Agregar detalle'),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () async {
                  if( _formKey.currentState!.validate() ){
                    // print('Form submitted');
                    setState(() {
                      _product["details"] = _details;
                      _product["status"] = true;
                    });
                    print( _product );

                    if( widget.id == null ){
                      await ProductModel.createProduct( _product );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
                    }
                    else{
                      setState(() {
                        _product.remove("_id");
                      });
                      bool status = await ProductModel.updateProduct( _product, widget.id );
                      if( status ){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
                      }
                      else {
                        bottomMessage(context, "No se ha podido actualizar");
                      }
                    }
                    
                    // _formKey.currentState!.reset();
                  }
                },
                child: Text(_buttonText),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}


