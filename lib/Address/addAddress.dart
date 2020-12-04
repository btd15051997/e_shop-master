import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  _addAddressToServer(context) {
    if (cName.text.isEmpty ||
        cPhoneNumber.text.isEmpty ||
        cFlatHomeNumber.text.isEmpty ||
        cCity.text.isEmpty ||
        cState.text.isEmpty ||
        cPinCode.text.isEmpty) {
      _showSnackBar(context, "Please enter all information in the form!");
    } else {
      if (formKey.currentState.validate()) {
        final model = AddressModel(
          name: cName.text.trim(),
          state: cState.text.trim(),
          pincode: cPinCode.text,
          phoneNumber: cPhoneNumber.text,
          flatNumber: cFlatHomeNumber.text,
          city: cCity.text.trim(),
        ).toJson();
        /*Add to firestore*/
        EcommerceApp.firestore
            .collection(EcommerceApp.collectionUser)
            .document(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .collection(EcommerceApp.subCollectionAddress)
            .document(DateTime.now().millisecondsSinceEpoch.toString())
            .setData(model)
            .then((value) {
          _showSnackBar(context, "New Address added successfully");
          formKey.currentState.reset();
        });
      }
    }
  }

  _showSnackBar(context, String msg) {
    final snack = SnackBar(content: Text(msg.toString()));
    scaffoldKey.currentState.showSnackBar(snack);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _addAddressToServer(context);
          },
          label: Text("Done"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add New Address",
                      style: TextStyle(
                          fontFamily: EcommerceApp.setFontFamily,
                          color: Colors.black,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: cName,
                        data: Icons.person,
                        hintText: "Name",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: cPhoneNumber,
                        data: Icons.phone_android,
                        hintText: "Phone Number",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: cFlatHomeNumber,
                        data: Icons.phone,
                        hintText: "Flat Number / House Number",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: cCity,
                        data: Icons.blur_circular,
                        hintText: "City",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: cState,
                        data: Icons.account_balance,
                        hintText: "State / Country",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: cPinCode,
                        data: Icons.blur_circular,
                        hintText: "Code Pin",
                        isObsecure: false,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 18.0, fontFamily: EcommerceApp.setFontFamily)),
        validator: (val) => val.isEmpty ? "Field can not de empty." : null,
      ),
    );
  }
}
