import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';

class MenuSideBarItem extends StatefulWidget {
  IconData icon;
  String title;
  Function onTap;
  MenuSideBarItem({this.icon,this.title,this.onTap});
  @override
  _MenuSideBarItemState createState() => _MenuSideBarItemState();
}

class _MenuSideBarItemState extends State<MenuSideBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: Colors.pink,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  fontFamily: EcommerceApp.setFontFamily,
                  fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
