import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
            ),
            suffixIcon: Icon(
              data,
              color: Theme.of(context).primaryColor,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 18.0,
                letterSpacing: 2.5,
                color: Colors.redAccent,
                fontFamily: EcommerceApp.setFontFamily)),
      ),
    );
  }
}
