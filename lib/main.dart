import 'package:flutter/material.dart';
import 'package:dttn_khtn/root_page.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final Firestore firestore = Firestore.instance;
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  FIRESTORE = firestore;
  SHARED_PREFERRENT = await SharedPreferences.getInstance();
  int color = SHARED_PREFERRENT.get(THEME_COLOR);
  if (color != null) {
    themeColor = MaterialColor(
        int.parse(color.toRadixString(16), radix: 16), <int, Color>{
      50: Color(0xFFA4A4BF),
      100: Color(0xFFA4A4BF),
      200: Color(0xFFA4A4BF),
      300: Color(0xFF9191B3),
      400: Color(0xFF7F7FA6),
      500: Color(0xFF181861),
      600: Color(0xFF6D6D99),
      700: Color(0xFF5B5B8D),
      800: Color(0xFF494980),
      900: Color(0xFF181861),
    });
  }
  runApp(new MyApp());
}
//void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Color primarySwatch;

  @override
  void initState() {
    primarySwatch = themeColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',
      theme: new ThemeData(primarySwatch: primarySwatch),
      home: new RootPage(),
    );
  }
}
