

import 'package:flutter/material.dart';

Color KmainColor = Colors.white;
Color KButtonColor =   Color(0xff3D56F0);
Color KtextColor = Colors.black;
Color kFieldBoarderColor = Colors.grey;




const indicator =  Center(
            child: CircularProgressIndicator(color: Colors.teal,),
          );


customSnackBar({
  required BuildContext context,
  required String  messsage,
}){

  return ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(messsage)));
}

