import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/itemQuantity.dart';
import 'package:e_shop/Store/authen_store_sidebar.dart';
import 'Notifications/local_notification_widget.dart';
import 'file:///E:/FlutterProject/Tutorial_Flutter_New/Provider_State/e_shop-master/lib/Notifications/push_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Config/config.dart';
import 'Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'Store/storehome.dart';
import 'Widgets/loadingWidget.dart';
import 'Widgets/widget_controll.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(
     EasyLocalization(
       child: MyApp(),
       saveLocale: true,
       path: "resource/langs",
       supportedLocales: [
         Locale('vi','VN'),
         Locale('en','EN'),
       ],
     )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=>CartItemCounter(),),
        ChangeNotifierProvider(create: (c)=>ItemQuantity(),),
        ChangeNotifierProvider(create: (c)=>AddressChanger(),),
        ChangeNotifierProvider(create: (c)=>TotalAmount(),),
      ],
      child: MaterialApp(
          title: 'e-Shop',
          debugShowCheckedModeBanner: false,
          /*Locale for multiples language*/
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   displaySplash();

  }

  displaySplash() {
    Timer(Duration(seconds: 3), () async {
      if (await EcommerceApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => AuthenStoreAndSideBarLayout());
          // MaterialPageRoute(builder: (_) => LocalNotificationWidget());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
     // Route route = MaterialPageRoute(builder: (_) => LocalNotificationWidget());
        Navigator.pushReplacement(context, route);
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: buildLinearGradient()
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png",height: 100.0,width: 100.0,),
              SizedBox(
                height: 20.0,
              ),
              linearProgress()
            ],
          ),
        ),
      ),
    );
  }
}
