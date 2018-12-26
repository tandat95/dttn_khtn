import 'package:flutter/material.dart';
import 'package:dttn_khtn/root_page.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  final Firestore firestore = Firestore.instance;
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  FIRESTORE = firestore;
  runApp(new MyApp());
}
//void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',
      theme: new ThemeData(
        primarySwatch: themeColor,
      ),
      home: new RootPage(),
    );
  }
}

