import 'package:box_nova/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailGeneral extends StatefulWidget{
  DetailGeneral({ super.key, required this.sentDetails });

  final Function sentDetails;

  @override
  _DetailGeneralState createState() => _DetailGeneralState();
}

class _DetailGeneralState extends State<DetailGeneral>{

  List<Widget?> _detail = [];
  Map<int,Map> _detailSend = {};
  int _indexCountSend = 0;

  List<GlobalKey<FormState>> _formKeys = [];

  @override
  void dispose(){
    print("______________________");
    print("hola estoy saliendo");
    print("______________________");

    widget.sentDetails( _detailSend.values.where( (x)=> x != null ).toList() );

    super.dispose();
  }

  void handleUploadImage( XFile iamge ){

  }

  void handleImage() async {
    XFile? image;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Imagen'),
        content: const Text('¿De que forma quieres ingresar la imagen?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                image = await picker.pickImage(source: ImageSource.camera);
                print(image);
                ProductModel.uploadImage( image! );
              } catch (e) {
                print(e);
              }
            }, 
            child: const Tooltip(
              message: "Tomar foto",
              child: Icon(Icons.camera)
            )
          ),
          TextButton(
            onPressed: () async {
              try {
                image = await picker.pickImage(source: ImageSource.gallery);
                ProductModel.uploadImage( image! );
              } catch (e) {
                print(e);
              }
            }, 
            child: const Tooltip(
              message: "Tomar foto",
              child: Icon(Icons.image)
            )
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text('Cerrar', style: TextStyle(color: Colors.red),),
            ),
        ],
      )
    );
  }

  Widget viewDetail( _key ){
    int index = _indexCountSend;

    _detailSend[index] = {};

    setState(() {
      _indexCountSend = index + 1;
    });

    String? _validSimple( value ){
      if( value == null || value.length == 0 ){
        return "Ingrese el campo";
      }
      return null;
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  _detailSend[index]!["color"] = value;
                },
                validator: _validSimple,
                decoration: const InputDecoration(
                  labelText: "Color",
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  _detailSend[index]!["size"] = value;
                },
                validator: _validSimple,
                decoration: const InputDecoration(
                  labelText: "Talla",
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  _detailSend[index]!["quantity"] = value;
                },
                validator: _validSimple,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                ),
              ),
              Divider(height: 10,),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: handleImage,
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.grey,),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _detailSend.remove(index);
                        _detail[index] = null;
                      });
                    },
                    child: const Icon(Icons.delete_outline, color: Colors.red,),
                  ),
                ],
              )
            ],
          )
        ),
        
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles generales"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: _detail.whereType<Widget>().toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Agregar detalle",
        onPressed: (){
          //create a new key instance
          GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          
          if (_indexCountSend == 0 || _detail.where((x) => x != null).length == 0) {
            setState(() {
              _formKeys.add(_formKey);
              _detail.add(viewDetail(_formKey));
            });
          }
          else if( _formKeys[_indexCountSend-1].currentState!.validate() ) {
            _formKeys[_indexCountSend-1].currentState!.save();

            setState(() {
              _formKeys.add(_formKey);
              _detail.add(viewDetail(_formKey));
            });
          }

        },
        child: const Icon(Icons.add),
      )
    );
  }
}
