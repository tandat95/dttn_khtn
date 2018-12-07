import 'package:flutter/material.dart';
import 'package:dttn_khtn/root_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new RootPage(),
    );
  }
}

