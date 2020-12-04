import 'dart:ui';

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin{
  int quantityOfItems = 1;
  Animation delayedAnimation, childAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.bounceInOut)));

    _animationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context,child){
        return SafeArea(
          child: Scaffold(
            appBar: MyAppBar(),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Transform(
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0.0, 0.0),
                            child: Center(
                              child: Image.network(widget.itemModel.thumbnailUrl,height: screenSize.height/2,width: screenSize.width/2,),
                            ),
                          ),
                          Container(
                            color: Colors.grey[300],
                            child: SizedBox(
                              height: 1.0,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Title: "+ widget.itemModel.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    letterSpacing: 2.0,
                                    fontFamily: EcommerceApp.setFontFamily),
                              ),
                              SizedBox(height: 10.0,),

                              Text(
                                "Description: "+widget.itemModel.longDescription,
                                style: TextStyle(
                                    letterSpacing: 2.0,
                                    color: Colors.black54,
                                    fontSize: 14.0,
                                    fontFamily: EcommerceApp.setFontFamily),
                              ),
                              SizedBox(height: 10.0,),

                              Text(
                                r"Price: $"+widget.itemModel.price.toString(),
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontFamily: EcommerceApp.setFontFamily,
                                    fontSize: 15.0, color: Colors.redAccent),
                              ),
                              SizedBox(height: 10.0,),

                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: InkWell(
                            onTap: (){

                              checkItemInCart(widget.itemModel.shortInfo, context);

                            },
                            child: Container(
                              decoration: BoxDecoration(gradient: buildLinearGradient()),
                              width: MediaQuery.of(context).size.width - 40,
                              height: 50.0,
                              child: Center(
                                child: Text("Add to Cart",style: TextStyle(fontSize: 20.0,color: Colors.white,fontFamily: EcommerceApp.setFontFamily),),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

TextStyle boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: EcommerceApp.setFontFamily);
TextStyle largeTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    fontFamily: EcommerceApp.setFontFamily);
