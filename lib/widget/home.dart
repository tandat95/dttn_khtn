import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dttn_khtn/widget/user_list.dart';
import 'package:dttn_khtn/widget/chat_list.dart';
import 'package:dttn_khtn/widget/my_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.user, this.onSignOut})
      : super(key: key);
  final VoidCallback onSignOut;
  final String title;
  final FirebaseUser user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //widget.user.uid
    final List<Widget> _children = [
      new ListUser(),
      new ChatList(),
      new MyProfile(user: widget.user),
      new MyProfile(user: widget.user),
    ];
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.blueGrey,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              //primaryColor: Colors.red,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.white))),
          child: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
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
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  title: Text('Make money')
              )
            ],
          ),
      ),
      body: _children[_currentIndex],
    );
  }
}
