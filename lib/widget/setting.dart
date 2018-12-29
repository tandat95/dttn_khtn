import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:dttn_khtn/loginAPI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:dttn_khtn/model/user.dart';
import 'package:dttn_khtn/widget/chat.dart';

class Setting extends StatefulWidget {
  final VoidCallback onSignout;

  const Setting({Key key,@required this.onSignout}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SettingState(this.onSignout);
}

class SettingState extends State<Setting> {
  final VoidCallback onSignout;
  Color customColor;

  SettingState(this.onSignout);
  @override
  void initState() {
    customColor = themeColor;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Exit"),
          content: new Text("Do you want to exit?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                LoginAPI.signOut();
                onSignout();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,
        title: Text("Setting"),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Theme color"),
            leading: Icon(
              Icons.palette,
              color: customColor,
            ),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Green'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.green;
                        themeColor = customColor;
                        //0xff4caf50
                        print(Colors.green);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Red'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.red;
                        themeColor = customColor;
                        //0xfff44336
                        print(Colors.red);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Blue'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.blue;
                        themeColor = customColor;
                        //0xff2196f3
                        print(Colors.blue);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Orange'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.deepOrange,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.deepOrange;
                        themeColor = customColor;
                        //0xffff5722
                        print(Colors.deepOrange);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Purple'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.deepPurple,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.deepPurple;
                        themeColor = customColor;
                        //0xff673ab7
                        print(Colors.deepPurple);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Teal'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.teal,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.teal;
                        themeColor = customColor;
                        //0xff009688
                        print(Colors.teal);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Pink'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.pink,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.pink;
                        themeColor = customColor;
                        //0xffe91e63
                        print(Colors.pink);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Cyan'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.cyan,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.cyan;
                        themeColor = customColor;
                        //0xff00bcd4
                        print(Colors.cyan);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Grey'),
                    leading: Icon(
                      Icons.brightness_1,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        customColor = Colors.grey;
                        themeColor = customColor;
                        //0xff9e9e9e
                        print(Colors.grey);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.input, color: customColor,),
            title: Text("Logout"),
            onTap: _showDialog
          )
        ],

      ),
    );
  }
}
