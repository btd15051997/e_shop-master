import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({Key key, this.itemCount, this.data, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (counter == 0) {
          counter = counter + 1;
          Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetails(orderID : orderID)));
        }
      },

      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 200.0,
        child: ListView.builder(
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c,index){
              ItemModel model = ItemModel.fromJson(data[index].data);
              return sourceOrderInfo(model, context);
          },

        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context, {Color background}) {
  width = MediaQuery.of(context).size.width;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
 
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.only(topRight: Radius.circular(25.0)),
    ),
    height: 190.0,
    width: width,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              border: Border.all(color: Colors.lightBlueAccent)),
          child: Image.network(
            model.thumbnailUrl,
            height: 100.0,
            width: 100.0,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        model.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            letterSpacing: 2.0,
                            fontFamily: EcommerceApp.setFontFamily),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        model.shortInfo,
                        style: TextStyle(
                            letterSpacing: 2.0,
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontFamily: EcommerceApp.setFontFamily),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     /* Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(
                          children: [
                            Text(
                              r"Origional Price: $",
                              style: TextStyle(
                                  fontFamily: EcommerceApp.setFontFamily,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12.0,
                                  color: Colors.grey),
                            ),
                            Text(
                              "${model.price + model.price}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: EcommerceApp.setFontFamily,
                                  fontSize: 12.0,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),*/
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              r"Total Price: ",
                              style: TextStyle(
                                  fontFamily: EcommerceApp.setFontFamily,
                                  fontSize: 14.0,
                                  color: Colors.black),
                            ),
                            Text(
                              r"$",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 16.0),
                            ),
                            Text(
                              "${model.price}",
                              style: TextStyle(
                                  fontFamily: EcommerceApp.setFontFamily,
                                  fontSize: 15.0,
                                  color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Flexible(
                child: Container(),
              ),

              /*to implement the cart item add/remove feature*/
            ],
          ),
        ),
      ],
    ),
  );
}
