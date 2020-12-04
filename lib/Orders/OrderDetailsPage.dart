import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Address/address.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../main.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }

              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                r"$ " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: EcommerceApp.setFontFamily),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text("Order ID: " + getOrderId,
                                style: TextStyle(
                                    fontFamily: EcommerceApp.setFontFamily)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                                "Ordered at: " +
                                    DateFormat("dd MMM, yyyy - hh:mm aa")
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    dataMap["orderTime"]))),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: EcommerceApp.setFontFamily)),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                itemCount: dataSnapshot.data.documents.length,
                                data: dataSnapshot.data.documents,
                              )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),

                          FutureBuilder<DocumentSnapshot>(
                              future: EcommerceApp.firestore
                              .collection(EcommerceApp.collectionUser)
                              .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                              .collection(EcommerceApp.subCollectionAddress)
                              .document(dataMap[EcommerceApp.addressID]).get(),
                              builder: (c,snap){
                                return snap.hasData
                                    ? ShippingDetails(model: AddressModel.fromJson(snap.data.data),)
                                    :Center(child: circularProgress(),);
                              })

                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      height: 40.0,
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Text(
            "Order Placed" + msg,
            style: TextStyle(
                color: Colors.white, fontFamily: EcommerceApp.setFontFamily),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.green,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          child: Text(
            "Shipment Details",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
                fontFamily: EcommerceApp.setFontFamily),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name: ",
                ),
                Text(model.name, style: textStyle()),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number: ",
                ),
                Text(model.phoneNumber, style: textStyle()),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number: ",
                ),
                Text(model.flatNumber, style: textStyle()),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City: ",
                ),
                Text(model.city, style: textStyle()),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State: ",
                ),
                Text(model.state, style: textStyle()),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin Code: ",
                ),
                Text(model.pincode, style: textStyle()),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmeduserOrderReceived(context, getOrderId);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: Text(
                    "Confirmed || Items Received",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: EcommerceApp.setFontFamily),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmeduserOrderReceived(BuildContext context, String nOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(nOrderId)
        .delete()
        .whenComplete(() {
      getOrderId = "";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => SplashScreen()));
    });

    Fluttertoast.showToast(msg: "Order has been Received. Confirmed");
  }
}
