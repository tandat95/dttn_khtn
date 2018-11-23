import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dttn_khtn/loginAPI.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.onSignOut}) : super(key: key);
  final VoidCallback onSignOut;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("header"),
              decoration: BoxDecoration(
                  color:
              ),
            ),
            ListTile(
              title: Text('Trang chủ'),
              leading: Icon(
                Icons.home,
                color: Colors.blue[500],
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('Sign out'),
              leading: Icon(
                Icons.assignment_return,
                color: Colors.blue[500],
              ),
              onTap: (){
                Navigator.pop(context);
                widget.onSignOut();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}