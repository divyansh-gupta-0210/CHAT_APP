import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'CHAT APP',
      style: TextStyle(
          color: Color(0xFFF1E6FF),
          fontWeight: FontWeight.bold,
          letterSpacing: 10.0),
    ),
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 17
  );
}