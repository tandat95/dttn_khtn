import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dttn_khtn/widget/user_list.dart';
import 'package:dttn_khtn/widget/placeholder_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.onSignOut}) : super(key: key);
  final VoidCallback onSignOut;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex =0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final List<Widget> _children = [
    new ListUser(),
    new PlaceholderWidget(Colors.red, "Message"),
    new PlaceholderWidget(Colors.blue, "Profile"),
  ];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {

        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
  }
  void _incrementCounter() {
    //Navigator.of(context).pushNamed('main');
    setState(() {
      _counter++;
    });
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text(widget.title),
//        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.mail),
              title: new Text('Messages'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile')
            )
          ],
        ),
        body:  _children[_currentIndex],
      );
  }
}
