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
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(),
    );
  }
}

//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: LoginPage(title: 'Đăng nhập'),
//      routes: <String, WidgetBuilder>{
//        'main': (BuildContext context) => MyHomePage(title: 'Tic Tac Toe'),
//      },
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
//
//  @override
//  void initState() {
//    super.initState();
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) {
//
//        print('on message $message');
//      },
//      onResume: (Map<String, dynamic> message) {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print('on launch $message');
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.getToken().then((token){
//      print(token);
//    });
//  }
//  void _incrementCounter() {
//    //Navigator.of(context).pushNamed('main');
//    setState(() {
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      drawer: Drawer(
//        child: ListView(
//          children: <Widget>[
//            DrawerHeader(
//              child: Text("header"),
//              decoration: BoxDecoration(
//                color: Colors.blue
//              ),
//            ),
//            ListTile(
//              title: Text('Teang chủ'),
//              leading: Icon(
//                Icons.home,
//                color: Colors.blue[500],
//              ),
//              onTap: (){
//                Navigator.pop(context);
//              },
//            ),
//            ListTile(
//              title: Text('AQI'),
//              leading: Icon(
//                Icons.cloud,
//                color: Colors.blue[500],
//              ),
//              onTap: (){
//                Navigator.pop(context);
//              },
//            ),
//            ListTile(
//              title: Text('WQI'),
//              leading: Icon(
//                Icons.local_drink,
//                color: Colors.blue[500],
//              ),
//              onTap: (){
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}

