import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: buildLinearGradient()),
        ),
        title: Text(
          "E - Shop Admin",
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: EcommerceApp.setFontFamily),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  var _emailIDTextEdittingController = TextEditingController();
  var _passwordTextEdittingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  _loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshop) {
      snapshop.documents.forEach((result) {
        if (result.data["id"] != _emailIDTextEdittingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your id is not correct"),
          ));
        } else if (result.data["password"] !=
            _passwordTextEdittingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your password is not correct"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Wellcome Dear Admin, " + result.data["name"]),
          ));
          setState(() {
            _emailIDTextEdittingController.text = "";
            _passwordTextEdittingController.text = "";
          });

          Navigator.pop(context);
          Route routeHome = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, routeHome);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(gradient: buildLinearGradient()),
        child: Container(
          height: _screenHeight,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0))),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "images/login.png",
                  height: 200.0,
                  width: 200.0,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailIDTextEdittingController,
                      data: Icons.person,
                      hintText: "ID Admin",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEdittingController,
                      data: Icons.email,
                      hintText: "Password Admin",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              ButtonTheme(
                height: 50.0,
                minWidth: _screenWidth * 0.4,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.greenAccent)),
                  onPressed: () {
                    _emailIDTextEdittingController.text.isNotEmpty &&
                            _passwordTextEdittingController.text.isNotEmpty
                        ? _loginAdmin()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: "Please write email and password",
                              );
                            });
                  },
                  color: Colors.green,
                  child: Text(
                    "Sign In Admin",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthenticScreen())),
                icon: (Icon(
                  Icons.people_alt_rounded,
                  color: Colors.pink,
                )),
                label: Text(
                  "I'am not Admin",
                  style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 3.0,
                      fontFamily: EcommerceApp.setFontFamily,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
