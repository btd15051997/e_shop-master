import 'dart:ui';

import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';

class AuthenticScreen extends StatefulWidget with NavigationStates {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: buildLinearGradient()),
          ),
          title: Text(
            "E - Shop",
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: EcommerceApp.setFontFamily),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(
                fontSize: 22.0, fontFamily: EcommerceApp.setFontFamily),
            //For Selected tab
            unselectedLabelStyle: TextStyle(
                fontSize: 16.0, fontFamily: EcommerceApp.setFontFamily),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white54,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_cal,
                  color: Colors.white54,
                ),
                text: "Register",
              ),
            ],
            indicatorColor: Colors.greenAccent,
            indicatorWeight: 2.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(gradient: buildLinearGradient()),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0))),
            child: TabBarView(
              children: [
                Login(),
                Register(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
