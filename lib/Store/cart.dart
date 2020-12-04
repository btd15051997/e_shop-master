import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget with NavigationStates {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayResult(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your Cart is Empty");
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (c) => Address(
                          totalAmount: totalAmount,
                        )));
          }
        },
        label: Text(
          "Check Out",
          style: TextStyle(
              color: Colors.white, fontFamily: EcommerceApp.setFontFamily),
        ),
        backgroundColor: Colors.green,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: " +
                                r"$" +
                                "${amountProvider.totalAmount.toString()}",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20.0,
                                letterSpacing: 2.0,
                                fontFamily: EcommerceApp.setFontFamily),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginBuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price + totalAmount;
                              } else {
                                totalAmount = model.price + totalAmount;
                              }

                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPersistentFrameCallback((t) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayResult(totalAmount);
                                });
                              }
                              return sourceInfo(model, context,
                                  removeCartFunction: () =>
                                      removeItemFromCart(model.shortInfo));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.green,
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon),
              Text("Cart is empty"),
              Text("Start adding items to your Cart."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromCart(String shortInfoAsId) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempCartList,
    }).then((value) {
      setState(() {

        Fluttertoast.showToast(msg: "Item Removed Successfully.");
        EcommerceApp.sharedPreferences
            .setStringList(EcommerceApp.userCartList, tempCartList);

        Provider.of<CartItemCounter>(context, listen: false).displayResult();

        print("total AMount: $totalAmount");

      });
    });
  }
}
