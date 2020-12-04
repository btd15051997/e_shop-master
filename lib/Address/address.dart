import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Orders/placeOrderPayment.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;

  Address({Key key, this.totalAmount}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: EcommerceApp.setFontFamily,
                      fontSize: 20.0),
                ),
              ),
            ),
            Consumer<AddressChanger>(
              builder: (context, address, c) {
                return Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                        builder: (context, snapshot) {
                      return !snapshot.hasData
                         ? Center(
                             child: circularProgress(),
                           )
                         : snapshot.data.documents.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressId: snapshot
                                        .data.documents[index].documentID,
                                    totalAmount: widget.totalAmount,
                                    model: AddressModel.fromJson(
                                        snapshot.data.documents[index].data),
                                  );
                                },
                                itemCount: snapshot.data.documents.length,
                                shrinkWrap: true,
                              );
                  },
                ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => AddAddress()));
          },
          label: Text("Add New Address"),
          backgroundColor: Colors.green,
          icon: Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.add_location, color: Colors.white),
            Text("No shipment address has been saved."),
            Text(
                "Please add your shipment Address so that we can deliver product."),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.addressId,
      this.totalAmount,
      this.value})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

TextStyle textStyle (){
  return TextStyle(letterSpacing: 1.5,fontSize: 18.0,fontFamily: EcommerceApp.setFontFamily);
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        borderOnForeground: true,
        elevation: 5.0,
        child: Column(
          children: [
            Row(
              children: [
                Radio(

                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.redAccent,
                  onChanged: (val) {

                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);

                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            KeyText(
                              msg: "Name: ",
                            ),
                            Text(widget.model.name,style: textStyle()),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Phone Number: ",
                            ),
                            Text(widget.model.phoneNumber,style: textStyle()),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Flat Number: ",
                            ),
                            Text(widget.model.flatNumber,style: textStyle()),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "City: ",
                            ),
                            Text(widget.model.city,style: textStyle()),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "State: ",
                            ),
                            Text(widget.model.state,style: textStyle()),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Pin Code: ",
                            ),
                            Text(widget.model.pincode,style: textStyle()),
                          ]),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Procced",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => PaymentPage(
                                    addressId: widget.addressId,
                                    totalAmount: widget.totalAmount,
                                  )));
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
          fontSize: 18.0,
          color: Colors.pinkAccent,
          letterSpacing: 2.5,
          fontFamily: EcommerceApp.setFontFamily,
          fontWeight: FontWeight.bold),
    );
  }
}
