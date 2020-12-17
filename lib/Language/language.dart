
import 'package:e_shop/Language/model_item_language.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Language extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  bool change = true;
  ItemLanguage selectedUser;
  List<ItemLanguage> users = <ItemLanguage>[
    const ItemLanguage(
        'VietNam', Icon(Icons.android, color: const Color(0xFF167F67),)),
    const ItemLanguage(
        'English', Icon(Icons.flag, color: const Color(0xFF167F67),)),
    const ItemLanguage('Flutter',
        Icon(Icons.format_indent_decrease, color: const Color(0xFF167F67),)),
  ];

  @override
  Widget build(BuildContext context) {

    print("Hello Test Language "+context.locale.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr().toString()),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('hello'.tr().toString()),

            Column(
              children: [

                RaisedButton(
                    child: change ? Text("Click Change EN") : Text(
                        "Click Change VI"),
                    onPressed: () {
                      if (change) {
                        EasyLocalization
                            .of(context)
                            .locale = Locale('en', 'EN');
                        setState(() {
                          change = false;
                        });
                      }
                      else {
                        EasyLocalization
                            .of(context)
                            .locale = Locale('vi', 'VN');
                        setState(() {
                          change = true;
                        });
                      }
                    }),

                DropdownButton<ItemLanguage>(
                  hint: context.locale.toString().contains('en_EN')?Text('langs'.tr().toString()):Text('langs'.tr().toString()),
                  value: selectedUser,
                  onChanged: (ItemLanguage Value) {
                    setState(() {

                      selectedUser = Value;
                      switch(Value.name) {
                        case 'VietNam': {
                          EasyLocalization
                              .of(context)
                              .locale = Locale('vi', 'VN');
                        }
                        break;

                        case 'English': {
                          EasyLocalization
                              .of(context)
                              .locale = Locale('en', 'EN');
                        }
                        break;
                        default: {

                        }
                        break;
                      }

                    });
                  },

                  items: users.map((ItemLanguage user) {
                    return DropdownMenuItem<ItemLanguage>(
                      value: user,
                      child: Row(
                        children: <Widget>[
                          user.icon,
                          SizedBox(width: 10,),
                          Text(
                            user.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}