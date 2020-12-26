import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(title: Text("Chats"),
    backgroundColor: colorMain(),
  );
}
TextStyle simpleTextStyle (){
  return TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
}

LinearGradient buildLinearGradient() {
  return new LinearGradient(
    colors: [Colors.green, Colors.lightBlueAccent],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.repeated,
  );
}

TextStyle miniTextStyle (){
  return TextStyle(
      color: Colors.black,
      fontSize: 12
  );
}
Color colorMain(){
  return Color(0xFF262AAA);
}

TextStyle mediumTextStyle (){
  return TextStyle(
      color: Colors.black,
      fontSize: 12
  );
}