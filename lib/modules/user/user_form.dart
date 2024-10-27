import 'package:box_nova/models/User.dart';
import 'package:box_nova/modules/user/user_list.dart';
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget{
  final Map<String,dynamic>? user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();

  Map<String,dynamic> newUser = {};

  UserForm({super.key, this.user}){
    if( user?["birthdate"] != null ){
      _dateController = TextEditingController(text: 
        UserModel.formatBirthDate( user?["birthdate"] )
      );
    }
  }

  Widget _input( title, realKey, { String? initValue } ){

    String? isValid ( value ) {
      if( value.isEmpty ) return "Ingrese el campo";
      return null;
    };

    return TextFormField(
      initialValue: initValue,
      scrollPadding: EdgeInsets.only(bottom: 4),
      onChanged: (value){
        newUser[realKey] = value;
      },
      validator: isValid,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  dynamic _messageState( context, message ){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar( content: Text(message,
        textAlign: TextAlign.center),
        duration: Duration(seconds: 2) )
    );
  }

  void _onSubmit( context ) async {
    if( _formKey.currentState!.validate() ){
      // Navigator.pop(context, user == null ? null : newUser);
      if( user != null ){
        if( newUser.keys.length > 0 ){
          // Update user
          bool isChanged = await UserModel.updateUser( user?["_id"], newUser );
          if( isChanged ){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserList()));
          }
          else{
            _messageState( context, 'Error, no se ha podido hacer el procedimiento');
          }
        }
        else{
          _messageState( context, 'No se tienen cambios');
        }
      }
      else{
        newUser["typeIdentifier"] = "CC";
        newUser["city"] = "Medellin";
        newUser["country"] = "Colombia";
        bool isChanged = await UserModel.createUser( newUser );
        if( isChanged ){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserList()));
        }
        else{
          _messageState( context, 'No se ha creado el usuario');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectedDate() async {
      DateTime dateNow = DateTime.now();
      if( user?["birthdate"] != null ){
        dateNow = DateTime.parse(user?["birthdate"]);
      }

      DateTime? _picked = await showDatePicker(
        context: context, 
        initialDate: dateNow,
        firstDate: DateTime(1890),
        lastDate: DateTime(2100)
      );

      if( _picked!= null ) {
        _dateController.text = UserModel.formatBirthDate(_picked.toString());
        newUser["birthdate"] = DateTime.parse(_picked.toString()).toIso8601String();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text( user == null ? 'Nuevo Usuario' : 'Actualizar Usuario'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: _input("Nombre", "firstName",initValue: user?["firstName"] ),
                  ),
                  SizedBox(width: 20,),
                  Flexible(
                    child: _input("Apellido", "lastName",initValue: user?["lastName"] ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: _input("Nombre de usuario", "username",initValue: user?["username"] ),
                  ),
                  SizedBox(width: 20,),
                  Flexible(
                    child: _input("Correo", "email", initValue: user?["email"] ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: _input("Documento de Identidad", "documentNumber",
                      initValue: user?["documentNumber"] ),
                  ),
                  SizedBox(width: 20,),
                  Flexible(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Cumpleaños",
                        // filled: true,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: (){_selectedDate();},
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(child: 
                    _input("Telefono", "phone", initValue: user?["phone"] ),
                  ),
                  SizedBox(width: 20,),
                  Flexible(child: 
                    _input("Dirección", "address", initValue: user?["address"] ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              Text("Tipo de usuario",),
              DropdownButtonFormField(
                onChanged: (value){
                  newUser["rol"] = value;
                },
                value: user == null ? "Client" : user?["rol"],
                icon: Icon(Icons.person),
                padding: EdgeInsets.all(2),
                items: [
                  DropdownMenuItem(value: "Admin", child: Text("Administrador")),
                  DropdownMenuItem(value: "Worker", child: Text("Empleado")),
                  DropdownMenuItem(value: "Client", child: Text("Cliente")),
                ],
              ),
              
              const SizedBox(height: 10),
              user == null
              ? TextFormField(
                obscureText: true,
                onChanged: (value){
                  newUser["password"] = value;
                },
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: Icon(Icons.lock),
                ),
              )
              : SizedBox(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  _onSubmit(context);
                },
                child: Text(user == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          )),
        )
      )
    );
  }
}