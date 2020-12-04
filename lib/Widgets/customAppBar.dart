import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: buildLinearGradient()),
      ),
      centerTitle: true,
      title: Text(
        "E-Shop",
        style: TextStyle(
            fontSize: 40.0, color: Colors.white, fontFamily: EcommerceApp.setFontFamily),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => CartPage()));
                },
              ),
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 5.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          "${counter.count.toString()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: EcommerceApp.setFontFamily),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );

  }

  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
