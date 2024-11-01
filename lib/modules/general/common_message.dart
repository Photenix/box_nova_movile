import 'package:flutter/material.dart';

void bottomMessage ( context, String message ) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar( 
      content: Text( message , textAlign: TextAlign.center,)
    )
  );
}