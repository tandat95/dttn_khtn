import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class _GroupInfo extends StatelessWidget{
  final String groupTitle;
  final List<Widget> children;
  const _GroupInfo({Key key,@required this.groupTitle, this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.all(16.0),
                  child: new Form(
                      //key: formKey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: ([
                          Text(groupTitle,
                            style: TextStyle(

                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //children: children,
                          )
                        ]),
                      )
                  )
              ),
            ])
      );
  }
}
class _InfoField extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return null;
  }
}
class _ContactCategory extends StatelessWidget {
  const _ContactCategory({ Key key, this.icon, this.children }) : super(key: key);
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)
              ),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({ Key key, this.icon, this.lines, this.tooltip, this.onPressed })
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines.sublist(0, lines.length - 1).map<Widget>((String line) => Text(line)).toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren
          )
      )
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
              icon: Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed
          )
      ));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}

class ContactsDemo extends StatefulWidget {
  const ContactsDemo({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  static const String routeName = '/contacts';



  @override
  ContactsDemoState createState() => ContactsDemoState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactsDemoState extends State<ContactsDemo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  File imageFile;
  bool isLoading;
  String nickName;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    nickName = widget.user.displayName;
  }

  Widget buildAvatar  (BuildContext context, DocumentSnapshot document) {
    return Image.network(
      document['photoUrl'],
      fit: BoxFit.cover,
    );
  }
  //get image from gallery
  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      updateAvatar();
    }
  }

  Future updateAvatar() async {
    //upload new avatar and get link download
    StorageReference reference = FirebaseStorage.instance.ref().child(AVATAR_IMAGE_NAME);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: widget.user.uid).getDocuments();
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      //update photoUrl
      final List<DocumentSnapshot> documents = result.documents;
      Firestore.instance.collection('users').document(widget.user.uid).updateData({
        'photoUrl':downloadUrl,
      });
      setState(() {
        isLoading = false;
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      //Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                    getImage();
//                    _scaffoldKey.currentState.showSnackBar(const SnackBar(
//                        content: Text("Editing isn't supported in this screen.")
//                    ));
                  },
                ),
                PopupMenuButton<AppBarBehavior>(
                  onSelected: (AppBarBehavior value) {
                    setState(() {
                      _appBarBehavior = value;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuItem<AppBarBehavior>>[
                    const PopupMenuItem<AppBarBehavior>(
                        value: AppBarBehavior.normal,
                        child: Text('App bar scrolls away')
                    ),
                    const PopupMenuItem<AppBarBehavior>(
                        value: AppBarBehavior.pinned,
                        child: Text('App bar stays put')
                    ),
                    const PopupMenuItem<AppBarBehavior>(
                        value: AppBarBehavior.floating,
                        child: Text('App bar floats')
                    ),
                    const PopupMenuItem<AppBarBehavior>(
                        value: AppBarBehavior.snapping,
                        child: Text('App bar snaps')
                    ),
                  ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(nickName),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                      StreamBuilder(
                        stream: Firestore.instance.collection('users').where('id', isEqualTo:widget.user.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                            );
                          } else {
                            return buildAvatar(context, snapshot.data.documents[0]);
                          }
                        },
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[Color(0x60000000), Color(0x00000000)],
                          ),
                        ),
                      ),
                      buildLoading()
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: _GroupInfo(groupTitle: "User info"),
                ),
                _GroupInfo(groupTitle: "Game",)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}




//import 'package:flutter/material.dart';
//import 'package:dttn_khtn/common/constants.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class MyProfile extends StatelessWidget {
//  MyProfile ({Key key, this.userId}) : super(key: key);
//  final String userId;
//  Widget buildAvarta  (BuildContext context, DocumentSnapshot document) {
//    return new Container(
//      child: Column(
//        children: <Widget>[
//          CachedNetworkImage(
//            placeholder: Container(
//              child: CircularProgressIndicator(
//                strokeWidth: 1.0,
//                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
//              ),
//              width: 50.0,
//              height: 50.0,
//              padding: EdgeInsets.all(15.0),
//            ),
//            imageUrl: document['photoUrl'],
//            width: MediaQuery.of(context).size.width,
//            height: 200.0,
//            fit: BoxFit.cover,
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    Column builStatusCard(String label, String value) {
//      Color color = Theme.of(context).primaryColor;
//
//      return Column(
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Text(
//            label,
//            style: TextStyle(
//              fontSize: 12.0,
//              fontWeight: FontWeight.bold,
//            )
//          ),
//          Text(
//            value,
//              style: TextStyle(
//                fontSize: 12.0,
//                fontWeight: FontWeight.bold,
//                color: color,
//              )
//          )
//        ],
//      );
//    }
//    return new Scaffold(
////      appBar: new AppBar(
////        title: new Text(
////          'Profile',
////          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
////        ),
////        centerTitle: true,
////      ),
//      body:
//      CustomScrollView(
//        slivers: <Widget>[
//          const SliverAppBar(
//            pinned: true,
//            expandedHeight: 250.0,
//            flexibleSpace: FlexibleSpaceBar(
//              title: Text('Demo'),
//            ),
//          ),
//          SliverGrid(
//            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//              maxCrossAxisExtent: 200.0,
//              mainAxisSpacing: 10.0,
//              crossAxisSpacing: 10.0,
//              childAspectRatio: 4.0,
//            ),
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                return Container(
//                  alignment: Alignment.center,
//                  color: Colors.teal[100 * (index % 9)],
//                  child: Text('grid item $index'),
//                );
//              },
//              childCount: 20,
//            ),
//          ),
//          SliverFixedExtentList(
//            itemExtent: 50.0,
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                return Container(
//                  alignment: Alignment.center,
//                  color: Colors.lightBlue[100 * (index % 9)],
//                  child: Text('list item $index'),
//                );
//              },
//            ),
//          ),
//        ],
//      )
////          Stack(
////            overflow: Overflow.visible,
////            alignment: Alignment.center,
////            children: <Widget>[
////              // background image and bottom contents
////              Column(
////                children: <Widget>[
////                  Container(
////                    height: 200.0,
////                    color: Colors.orange,
////                    child: Container(
////                      child: StreamBuilder(
////                        stream: Firestore.instance.collection('users').where('id', isEqualTo:userId ).snapshots(),
////                        builder: (context, snapshot) {
////                          if (!snapshot.hasData) {
////                            return Center(
////                              child: CircularProgressIndicator(
////                                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
////                              ),
////                            );
////                          } else {
////                            return buildAvarta(context, snapshot.data.documents[0]);
////                          }
////                        },
////                      ),
////                    ),
////                  ),
////                  Expanded(
////                    child: Container(
////                      color: Colors.white,
////                      child: Center(
////                          child: Column(
////                            children: <Widget>[
////                              Text('Content goes here'),
////                              Text('Content goes here'),
////                              Text('Content goes here'),
////                              Text('Content goes here'),
////
////                            ],
////                          )
////                      ),
////                    ),
////                  )
////                ],
////              ),
////              // Profile image
////              Positioned(
////                  top: 170.0, // (background container size) - (circle height / 2)
////                  child:SizedBox(
////                    height: 60,
////                    width: 300.0,
////                    child: Card(
////                      child: Row(
////                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                        children: [
////                          builStatusCard('LIKE', '10'),
////                          builStatusCard('FOLLOW', '20'),
////                          builStatusCard('DISLIKE', '30'),
////                        ],
////                      ),
////                    ),
////                  )
////              )
////            ],
////          ),
//    );
//  }
//}