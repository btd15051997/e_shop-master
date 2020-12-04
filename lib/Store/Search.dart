import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/customAppBar.dart';

class SearchService {}

class SearchProduct extends StatefulWidget with NavigationStates {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap)
          {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                  )
                : Center(child: Text("No data available",style: TextStyle(fontSize: 22.0,fontFamily: EcommerceApp.setFontFamily),));
          },
        ),
      ),
    );
  }

  searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: BoxDecoration(gradient: buildLinearGradient()),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: TextField(
                onChanged: (val) {
                  startSearching(val);
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Search here...",hintStyle: TextStyle(fontFamily: EcommerceApp.setFontFamily)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = Firestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}

Widget buildResultCard(data) {
  return Card();
}
