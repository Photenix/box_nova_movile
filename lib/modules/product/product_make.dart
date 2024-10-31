import 'package:box_nova/modules/product/product_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class ProductMake extends StatelessWidget{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List details = [];

  void sentDetails( List newDetail ){
    details = newDetail;
  }

  // TODO: Fix problem with de other things
  Widget _input( String title, {TextInputType? keyType, bool disable = false } ){

    String? isValid ( value ) {
      if( value.isEmpty ) return "Ingrese el campo";
      return null;
    };

    return TextFormField(
      onChanged: (text) {
        // Update your text field state here
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crear un producto'),
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
              _input("Nombre de producto"),
              const SizedBox(height: 18,),
              _input("Precio", keyType: TextInputType.number ),
              const SizedBox(height: 18,),
              _input("Cantidad", keyType: TextInputType.number, disable: true ),
              const SizedBox(height: 18,),
              _input("Precio", keyType: TextInputType.number ),
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
                defaultSelected: "Female",
                buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)
                ),
                radioButtonValue: (value) {
                  print(value);
                },
                selectedColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 18,),
              const Text("Categoría",),
              const SizedBox(height: 8,),
              DropdownButtonFormField(
                onChanged: (value){
                  // newUser["rol"] = value;
                },
                value: "Camisa",
                icon: const Icon(Icons.abc),
                padding: const EdgeInsets.all(2),
                items: const [
                  DropdownMenuItem(value: "Camisa", child: Text("Camisa")),
                  DropdownMenuItem(value: "Camiseta", child: Text("Camiseta")),
                  DropdownMenuItem(value: "Vestido", child: Text("Vestido")),
                ],
              ),
              const SizedBox(height: 18,),
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context, 
                  builder: (BuildContext context) => Dialog.fullscreen(
                    child: DetailGeneral( sentDetails: sentDetails,))
                  );
                },
                child: const Text('Agregar detalle'),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if( _formKey.currentState!.validate() ){
                    print('Form submitted');
                    // _formKey.currentState!.reset();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}


