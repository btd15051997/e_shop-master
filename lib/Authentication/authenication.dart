import 'dart:ui';
import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Language/model_item_language.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthenticScreen extends StatefulWidget with NavigationStates {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  ItemLanguage selectedUser;
  List<ItemLanguage> users = <ItemLanguage>[
    const ItemLanguage(
        'VN',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const ItemLanguage(
        'EN',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
    const ItemLanguage(
        'Flutter',
        Icon(
          Icons.format_indent_decrease,
          color: const Color(0xFF167F67),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white70, borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<ItemLanguage>(
                hint: context.locale.toString().contains('en_EN')
                    ? Text('langs'.tr().toString())
                    : Text('langs'.tr().toString()),
                value: selectedUser,
                onChanged: (ItemLanguage Value) {
                  setState(() {
                    selectedUser = Value;
                    switch (Value.name) {
                      case 'VN':
                        {
                          EasyLocalization.of(context).locale =
                              Locale('vi', 'VN');
                        }
                        break;

                      case 'EN':
                        {
                          EasyLocalization.of(context).locale =
                              Locale('en', 'EN');
                        }
                        break;
                      default:
                        {}
                        break;
                    }
                  });
                },
                items: users.map((ItemLanguage user) {
                  return DropdownMenuItem<ItemLanguage>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        user.icon,
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: buildLinearGradient()),
          ),
          title: Text(
            "BTD - Shop",
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: EcommerceApp.setFontFamily),
          ),
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
