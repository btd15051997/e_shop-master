
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Store/authen_store_sidebar.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
import 'dart:async';
import 'dart:ui';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _emailTextEdittingController = TextEditingController();
  var _passwordTextEdittingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  _loginUser() async{
    showDialog(context: context,
    builder: (c){
      return LoadingAlertDialog(message: "Loging, Please file",);
    });

    await _auth.signInWithEmailAndPassword(
        email: _emailTextEdittingController.text.trim(),
        password: _passwordTextEdittingController.text.trim()).then((authUser) {
          firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });

    if(firebaseUser != null){
      _readData(firebaseUser).then((s){

        Navigator.pop(context);
        Route routeHome = MaterialPageRoute(builder: (c)=> AuthenStoreAndSideBarLayout());
        Navigator.pushReplacement(context, routeHome);

      });
    }
  }

  _readData(FirebaseUser fUser)async{

    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot) async {

      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID, dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      var carList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, carList);

    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
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
                    controller: _emailTextEdittingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEdittingController,
                    data: Icons.admin_panel_settings,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0,),
            ButtonTheme(
              height: 50.0,
              minWidth: _screenWidth * 0.4,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.greenAccent)),
                onPressed: () {
                  _emailTextEdittingController.text.isNotEmpty &&
                          _passwordTextEdittingController.text.isNotEmpty
                      ? _loginUser()
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
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: (Icon(
                Icons.people_alt_rounded,
                color: Colors.green,
              )),
              label: Text(
                "Login with Admin",
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
    );
  }
}
