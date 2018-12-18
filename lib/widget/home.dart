import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dttn_khtn/widget/user_list.dart';
import 'package:dttn_khtn/widget/chat_list.dart';
import 'package:dttn_khtn/widget/my_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dttn_khtn/widget/make_money.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int _currentIndex;
  bool _unReadMes;
  static String id;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription<Event> _onNoteChangeSubscription;

  @override
  void initState() {
    super.initState();
    id = widget.user.uid;
    _onNoteChangeSubscription = notesReference.onValue.listen(_onNoteChanged);
    _currentIndex = TAB_INDEX;
    _unReadMes = TAB_INDEX != 1 && NEW_MES;
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
      //print('token: $token');
    });
  }

  DatabaseReference notesReference = FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(CURRENT_USER.uid)
      .child(UNREAD_MES);

  void _onNoteChanged(Event event) {
    NEW_MES = event.snapshot.value;
    _unReadMes = TAB_INDEX != 1 && NEW_MES;
    try {
      setState(() {
        _unReadMes = TAB_INDEX != 1 && NEW_MES;
      });
    } catch (Ex) {}
  }

  @override
  void dispose() {
    _onNoteChangeSubscription.cancel();
    super.dispose();
  }

  void onTabTapped(int index) {
//    notesReference.child('name').once().then((DataSnapshot snap){
//     print(snap.value);
//   });

    setState(() {
      _currentIndex = index;
      TAB_INDEX = index;
      if (index == 1) {
        _unReadMes = false;
        setUnReadMesStatus(CURRENT_USER.uid, false);
      }
    });
  }

  Widget setMesIcon() {
    if (_unReadMes) {
      return new Stack(children: <Widget>[
        new Icon(Icons.mail),
        new Positioned(
          // draw a red marble
          top: 0.0,
          right: 0.0,
          child:
              new Icon(Icons.brightness_1, size: 10.0, color: Colors.redAccent),
        )
      ]);
    }
    return new Icon(Icons.mail);
  }

  @override
  Widget build(BuildContext context) {
    //widget.user.uid
    final List<Widget> _children = [
      StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(CURRENT_USER.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SET_LOADING();
          }
          if (snapshot.data[FOLLOWING] == null) {
            Firestore.instance
                .collection('users')
                .document(CURRENT_USER.uid)
                .updateData({FOLLOWING: new List<String>()}).then((data) {
              setState(() {});
            });
          } else {
            for (int i = 0; i < snapshot.data[FOLLOWING].length; i++) {
              FOLLOWED_LIST.add(snapshot.data[FOLLOWING][i].toString());
            }
            return new ListUser();
          }
        },
      ),
      new ChatList(
        currentUserId: widget.user.uid,
      ),
      new MyProfile(user: widget.user),
      //new MakeMoney()
    ];
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            //primaryColor: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith()),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: setMesIcon(),
              title: new Text('Messages'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile')),
//              BottomNavigationBarItem(
//                  icon: Icon(Icons.attach_money),
//                  title: Text('Make money')
//              )
          ],
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}
