import 'package:flutter/material.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:dttn_khtn/loginAPI.dart';

class Setting extends StatefulWidget {
  final VoidCallback onSignout;

  const Setting({Key key, @required this.onSignout}) : super(key: key);
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

  void _logOutDialog() {
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
              child: new Text(
                "Yes",
                style: TextStyle(color: themeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                LoginAPI.signOut();
                onSignout();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: themeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeThemeDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Change theme"),
          content: new Text("Please restart the application to change full color!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ok",
                style: TextStyle(color: themeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildColorChoice(title, color, colorCode) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(title),
        leading: Icon(
          Icons.brightness_1,
          color:color,
        ),
        onTap: () {
          SHARED_PREFERRENT.setInt(THEME_COLOR, colorCode);
          setState(() {
            customColor = color;
            themeColor = customColor;
            //0xff4caf50
          });
          _changeThemeDialog();
        },
      ),
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
            title: Text("Theme"),
            leading: Icon(
              Icons.palette,
              color: customColor,
            ),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  buildColorChoice("Green",Colors.green,0xff4caf50),
                  buildColorChoice("Red",Colors.red,0xfff44336),
                  buildColorChoice("Blue",Colors.blue,0xff2196f3),
                  buildColorChoice("Orange",Colors.deepOrange,0xffff5722),
                  buildColorChoice("Purple",Colors.deepPurple,0xff673ab7),
                  buildColorChoice("Teal",Colors.teal,0xff009688),
                  buildColorChoice("Pink",Colors.pink,0xffe91e63),
                  buildColorChoice("Cyan",Colors.cyan,0xff00bcd4),
                  buildColorChoice("Grey",Colors.grey,0xff9e9e9e),
                ],
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Contact"),
            leading: Icon(
              Icons.mail,
              color: customColor,
            ),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Text("Email: ngotandat73@gmail.com")
                ],
              ),
            ],
          ),
          ListTile(
              leading: Icon(
                Icons.input,
                color: customColor,
              ),
              title: Text("Logout"),
              onTap: _logOutDialog)
        ],
      ),
    );
  }
}
