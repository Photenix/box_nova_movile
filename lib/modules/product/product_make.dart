import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class ProductMake extends StatelessWidget{


  // TODO: Fix problem with de other things
  Widget _input( String title, {TextInputType? keyType, bool disable = false } ){
    return TextField(
      onChanged: (text) {
        // Update your text field state here
      },
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
      child: Center(  
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _input("Nombre de producto"),
              SizedBox(height: 18,),
              _input("Precio", keyType: TextInputType.number ),
              SizedBox(height: 18,),
              _input("Cantidad", keyType: TextInputType.number, disable: true ),
              SizedBox(height: 18,),
              _input("Precio", keyType: TextInputType.number ),
              SizedBox(height: 18,),

              SizedBox(height: 18,),
              CustomRadioButton(
                enableShape: true,
                shapeRadius: 20,
                horizontal: true,
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
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  // Call your function to process the text field input
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