import 'dart:async';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/sidebar_menu.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;

  // AuthMethods authMethods = new AuthMethods();

  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenedSink;

  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfoCurrentUser();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSidebarOpenedStreamController.stream;
    isSideBarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _animationController.dispose();
    isSideBarOpenedSink.close();
    isSidebarOpenedStreamController.close();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isSideBarOpenedSink.add(false);
      _animationController.reverse();
      print("Check 1");
    } else {
      print("Check 2");
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  String emailUser, nameUser, urlAvatar;

  _buildListileMenuSidebar() {
    return Container(
      decoration: BoxDecoration(
          gradient: buildLinearGradient(),
          borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Text(
          nameUser == "" ? "Name: User Empty!" : "Name : $nameUser",
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            fontFamily: EcommerceApp.setFontFamily,
          ),
        ),
        subtitle: Text(
          emailUser == "" ? "Email: User Empty!" : "Email : $emailUser",
          style: TextStyle(
              letterSpacing: 1.5,
              color: Colors.white54,
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              fontFamily: EcommerceApp.setFontFamily,
              fontWeight: FontWeight.bold),
        ),
        leading: CircleAvatar(
          backgroundImage: urlAvatar != null ? NetworkImage(urlAvatar):AssetImage('images/cash.png'),
          radius: 30,
        ),
      ),
    );
  }

  _getInfoCurrentUser()  async{
      nameUser = await EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
      emailUser = await EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail);
      urlAvatar = await EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 90,
          child: Container(
            margin: EdgeInsets.only(right: 50.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      color: Colors.lightBlueAccent,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                _buildListileMenuSidebar(),
                                /*Widget tạo đường kẽ*/
                                Divider(
                                  height: 50,
                                  thickness: 0.5,
                                  color: Colors.white,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                MenuSideBarItem(
                                  icon: Icons.home,
                                  title: "Home",
                                  onTap: () {
                                    BlocProvider.of<SideBarNavigationBloc>(
                                        context).add(
                                        NavigationEvent.HomeStoreClickedEvent);
                                    onIconPressed();
                                  },
                                ),
                                MenuSideBarItem(
                                  icon: Icons.person,
                                  title: "My Order",

                                  onTap: () {

                                    BlocProvider.of<SideBarNavigationBloc>(
                                        context).add(
                                        NavigationEvent.MyOrdersClickedEvent);
                                    onIconPressed();

                                  },

                                ),
                                MenuSideBarItem(
                                  icon: Icons.card_travel_sharp,
                                  title: "My Cart",
                                  onTap: () {

                                    BlocProvider.of<SideBarNavigationBloc>(
                                        context).add(
                                        NavigationEvent.CartPageClickedEvent);
                                    onIconPressed();

                                  },
                                ),
                                MenuSideBarItem(
                                  icon: Icons.search,
                                  title: "Search",
                                  onTap: () {
                                    BlocProvider.of<SideBarNavigationBloc>(
                                        context).add(
                                        NavigationEvent.SearchClickedEvent);
                                    onIconPressed();
                                  },
                                ),
                                MenuSideBarItem(
                                  icon: Icons.card_giftcard,
                                  title: "Add New Address",
                                ),
                                Divider(
                                  height: 50,
                                  thickness: 0.5,
                                  color: Colors.white,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    EcommerceApp.auth.signOut().then((value) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (c) =>
                                              AuthenticScreen()));
                                    });
                                    onIconPressed();
                                  },
                                  child: MenuSideBarItem(
                                    icon: Icons.exit_to_app,
                                    title: "Logout",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "By : DatBT",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ))
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment(0, 0.8),
                  child: GestureDetector(
                    onTap: () {
                      onIconPressed();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        width: 35.0,
                        height: 110.0,
                        alignment: Alignment.center,
                        color: Colors.lightBlueAccent,
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                      ),
                    ),
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

/* //Điểm control, tới điểm end :quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)*/
class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print("width : ${size.width} + height : ${size.height}");
/*
    var path = Path();
    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(size.width/4, size.height, size.width/2, size.height);
    path.quadraticBezierTo(size.width - (size.width/4), size.height, size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height - (size.height - 20));
    path.quadraticBezierTo(size.width - (size.width/4), 0.0, size.width/2, 0.0);
    path.quadraticBezierTo(size.width/4, 0.0, 0.0, size.height - (size.height - 20));
*/
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
