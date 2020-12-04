import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/widget_controll.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortTextEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool  isShowSnackbarUploaded = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFromScreen();
  }

  _uploadImageAndSaveInfo()async{
    setState(() {
      uploading = true;
    });

   String imageDownloadUrl = await _uploadItemImage(file);

   _saveItemInfo(imageDownloadUrl);
  }

  _saveItemInfo(imageDownloadUrl){

    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo" : _shortTextEditingController.text.trim(),
      "longDescription" : _descriptionTextEditingController.text.trim(),
      "price" : int.parse(_priceTextEditingController.text.trim()),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : imageDownloadUrl,
      "title" : _titleTextEditingController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortTextEditingController.clear();
      _titleTextEditingController.clear();

      isShowSnackbarUploaded = true;
    });
  }

  Future<String>_uploadItemImage(mFileImage)async{

    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  displayAdminUploadFromScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: buildLinearGradient()),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearFromInfo();
          },
        ),
        title: Text(
          "New Product",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: EcommerceApp.setFontFamily),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              uploading ? null :  _uploadImageAndSaveInfo();
            },
            child: Text(
              "Add",
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.pink,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: EcommerceApp.setFontFamily),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
             child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file))),
                ),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.green,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black45,),
                controller: _shortTextEditingController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 2.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),

                    hintText: "Short Info",
                    hintStyle: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black45,
                        fontFamily: EcommerceApp.setFontFamily),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.blueAccent),
          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.green,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle( color: Colors.black45,),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 3.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),

                    hintText: "Title",
                    hintStyle: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black45,
                        fontFamily: EcommerceApp.setFontFamily),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.blueAccent),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.green,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle( color: Colors.black45,),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 3.0)),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),
                    hintText: "Description",
                    hintStyle: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black45,
                        fontFamily: EcommerceApp.setFontFamily),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.blueAccent),
          ListTile(
            leading: Icon(
              Icons.local_fire_department,
              color: Colors.green,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle( color: Colors.black45,),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 3.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),

                    hintText: "Price",
                    hintStyle: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black45,
                        fontFamily: EcommerceApp.setFontFamily),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.blueAccent),
        ],
      ),
    );
  }

  displayAdminHomeScreen() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: buildLinearGradient()),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => AdminShiftOrders()));
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 18.0,
                  fontFamily: EcommerceApp.setFontFamily,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => SplashScreen()));
            },
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  clearFromInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortTextEditingController.clear();
    });
  }

  _takeImage() {
    return showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Chosse Image",
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: EcommerceApp.setFontFamily),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle( letterSpacing: 2.0,color: Colors.green, fontSize: 14.0),
                ),
                onPressed: () {
                  _capturePhotoWithCamera();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Select from gallery",
                  style: TextStyle( letterSpacing: 2.0,color: Colors.green, fontSize: 14.0),
                ),
                onPressed: () {
                  _pickPhotoFromGallery();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: EcommerceApp.setFontFamily),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      file = imageFile;
    });
  }

  Future<void> _pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  getAdminHomeScreenBody() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.black45,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Add New Items",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontFamily: EcommerceApp.setFontFamily),
                ),
                color: Colors.green,
                onPressed: () {
                  _takeImage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
