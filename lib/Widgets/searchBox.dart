

import 'dart:ui';

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';


class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchProduct()));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: buildLinearGradient(),
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search,color: Colors.blueGrey,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Search here...",style: TextStyle(fontSize: 16.0,fontFamily: EcommerceApp.setFontFamily,color: Colors.grey),),
                  )
                ],
              ),
            ),
          ),
        ),
      );



  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


