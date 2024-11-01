import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/common_message.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailGeneral extends StatefulWidget{
  DetailGeneral({ super.key, required Function this.sentDetails, required this.listDetails });

  final Function sentDetails;
  final List listDetails;

  @override
  _DetailGeneralState createState() => _DetailGeneralState();
}

class _DetailGeneralState extends State<DetailGeneral>{

  List<Widget?> _detail = [];
  Map<int,Map> _detailSend = {};
  int _indexCountSend = 0;

  List<GlobalKey<FormState>> _formKeys = [];

  /*
  @override
  void dispose(){
    print("______________________");
    print("hola estoy saliendo");
    print("______________________");

    super.dispose();
  }
  */

  void deleteCard( int index ){
    setState(() {
      _detailSend[index] = {};
      _detail[index] = null;
    });
  }

  void getInfoCard( i, info ){
    setState(() {
      _detailSend[i] = info;
    });
  }

  void saveDetails(){

    for (var i = 0; i < _detail.length; i++) {
      if( _detail[i] != null ){
        if( _formKeys[i].currentState!.validate() ) {
          _formKeys[i].currentState!.save();

          if( _detailSend[i]?["image"] == null || _detailSend[i]?["image"] == "" ){
            _detailSend[i]?.remove("image");
          }
        }
      }
    }

    print("______________________");
    List newList = _detailSend.values.where( (x)=> x.isEmpty == false ).toList();
    widget.sentDetails( newList );

    bottomMessage(context, "Cambios guardados");

    // print(_formKeys);

  }

  void changesProduct(){
    Map<int,Map> newMap = {};
    List<GlobalKey<FormState>> newFormKeys = [];
    List<Widget?> newDetail = [];

    for (var i = 0; i < widget.listDetails.length; i++) {
      GlobalKey<FormState> unicFormKey = GlobalKey<FormState>();
      newMap[i] = widget.listDetails[i];
      newFormKeys.add(unicFormKey);
      newDetail.add(
        ProductCardDetail(
          unicFormKey, i, deleteCard, getInfoCard,
          color: newMap[i]?["color"], size: newMap[i]?["size"], 
          quantity: newMap[i]?["quantity"].toString(), image: newMap[i]?["image"],
        )
      );
    }

    setState(() {
      //map
      _detailSend = newMap;
      //list form
      _formKeys = newFormKeys;
      //list widget
      _detail = newDetail;
      _indexCountSend = widget.listDetails.length;
    });
  }


  @override
  void initState(){
    if( widget.listDetails.length > 0 ){
      changesProduct();
    }

    super.initState();
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
          children: [
            //Se encarga de guarda los detalles que se hallan hecho
            TextButton(
              onPressed: saveDetails, child: Text("Guardar cambios")),
            Divider(height: 10,),
            ..._detail.whereType<Widget>().toList()
          ],
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
              _detail.add(ProductCardDetail( _formKey, _indexCountSend, deleteCard, getInfoCard ));
              _indexCountSend++;
            });
          }
          else if( _formKeys[_indexCountSend-1].currentState!.validate() ) {
            _formKeys[_indexCountSend-1].currentState!.save();

            setState(() {
              _formKeys.add(_formKey);
              _detail.add(ProductCardDetail( _formKey, _indexCountSend, deleteCard, getInfoCard ));
              _indexCountSend++;
            });
          }

        },
        child: const Icon(Icons.add),
      )
    );
  }
}


class ProductCardDetail extends StatefulWidget{
  ProductCardDetail(
    this.newKey, this.index, this.deleteMe, this.sendInfo,
    {
      super.key,
      this.color, this.size, this.quantity, this.image
    }
  );

  final GlobalKey<FormState> newKey;
  final int index;
  final Function deleteMe;
  final Function sendInfo;
  final String? color;
  final String? size;
  final String? quantity;
  final String? image;

  @override
  _ProductCardDetailState createState() => _ProductCardDetailState();
}

class _ProductCardDetailState extends State<ProductCardDetail> {

  String? _image;

  // int index = _indexCountSend;

  // _detailSend[index] = {};

  Map _detail = {
    "image": null,
    "color": null,
    "size": null,
    "quantity": null,
  };

  String? _validSimple( value ){
    if( value == null || value.length == 0 ){
      return "Ingrese el campo";
    }
    return null;
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
                String url = await ProductModel.uploadImage( image! );
                setState(() {
                  _detail["image"] = url;
                  _image = url;
                });
              } catch (e) {
                bottomMessage(context, "Error no se tienen permisos para usar la camara");
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
                String url = await ProductModel.uploadImage( image! );
                setState(() {
                  _detail["image"] = url;
                  _image = url;
                });
              } catch (e) {
                bottomMessage(context, "Error no se tienen permisos para buscar archivos");
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


  @override
  void initState() {
    if( widget.color != null ){

      setState( (){
        _detail["image"] = widget.image;
        _detail["color"] = widget.color;
        _detail["size"] = widget.size;
        _detail["quantity"] = widget.quantity;

        _image = widget.image;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: widget.newKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                    Column(
                      children: [
                        TextFormField(
                          initialValue: widget.color,
                          onChanged: (value) {
                            _detail["color"] = value;
                          },
                          validator: _validSimple,
                          decoration: const InputDecoration(
                            labelText: "Color",
                          ),
                        ),
                        TextFormField(
                          initialValue: widget.size,
                          onChanged: (value) {
                            _detail["size"] = value;
                          },
                          validator: _validSimple,
                          decoration: const InputDecoration(
                            labelText: "Talla",
                          ),
                        ),
                        TextFormField(
                          initialValue: widget.quantity,
                          onChanged: (value) {
                            _detail["quantity"] = value;
                          },
                          validator: _validSimple,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Cantidad",
                          ),
                          onSaved: (newValue) {
                            widget.sendInfo( widget.index, _detail );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      color: Colors.black45,
                      // Aquí puedes usar un Container para la imagen
                      child: Image.network(
                        _image ?? 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png', // Reemplaza con tu URL de imagen
                        fit: BoxFit.cover, // Ajusta la imagen para que ocupe todo el espacio
                      ),
                    ),
                  )
                  
                ],
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
                      widget.deleteMe(widget.index);
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
}