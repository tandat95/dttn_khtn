import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dttn_khtn/model/user.dart';
import 'package:dttn_khtn/loginAPI.dart';

class _GroupInfo extends StatefulWidget {
  const _GroupInfo({Key key, @required this.user})
      : super(key: key);
  final User user;

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<_GroupInfo> {

  static final formKey = new GlobalKey<FormState>();
  MyProfileState parentWidget;

  List<String> _genders = <String>['', 'Male', 'Female'];
  String _genderVal = '';


  List<Widget> _UserInfoForm() {
    return [
      new TextFormField(
        key: new Key('username'),
        decoration: new InputDecoration(
          labelText: 'Username',
          icon: Icon(Icons.text_fields),
        ),
        initialValue: widget.user.userName,
        autocorrect: false,
        onSaved: (val) => widget.user.userName = val,
      ),
      new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(
          labelText: 'Email',
          icon: Icon(Icons.email),
        ),
        initialValue: widget.user.email,
        autocorrect: false,
        onSaved: (val) => widget.user.email = val,
      ),
      new TextFormField(
        key: new Key('phone'),
        keyboardType: TextInputType.number,
        initialValue: widget.user.phoneNumber,
        decoration: new InputDecoration(
          labelText: 'Phone number',
          icon: Icon(Icons.phone),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.phoneNumber = val,
      ),
      new TextFormField(
        key: new Key('age'),
        keyboardType: TextInputType.number,
        initialValue: widget.user.age,
        decoration: new InputDecoration(
          labelText: 'Age',
          icon: Icon(Icons.cake),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.age = val,
      ),
      new FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              icon: const Icon(Icons.people),
              labelText: 'Gender',
            ),
            isEmpty: _genderVal == '',
            //isFocused: true,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: widget.user.gender,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _genderVal = newValue;
                    widget.user.gender = newValue;
                    state.didChange(newValue);
                  });
                },
                items: _genders.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _GameInfoForm() {
    return [
      new TextFormField(
        key: new Key('lolname'),
        decoration: new InputDecoration(
          labelText: 'Nick "LOL"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        initialValue: widget.user.lolName,
        onSaved: (val) => widget.user.lolName = val,
      ),
      new TextFormField(
        key: new Key('pupgname'),
        initialValue: widget.user.pupgName,
        decoration: new InputDecoration(
          labelText: 'Nick "PUPG"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.pupgName = val,
      ),
      new TextFormField(
        key: new Key('rosname'),
        initialValue: widget.user.rosName,
        decoration: new InputDecoration(
          labelText: 'Nick "Rules Of Survival"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.rosName = val,
      ),
      new TextFormField(
        key: new Key('sokname'),
        initialValue: widget.user.sokName,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: 'Nick "Strike of Kings (LQMB)"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.sokName = val,
      ),
      new TextFormField(
        key: new Key('fifaname'),
        initialValue: widget.user.fifaName,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: 'Nick "Fifa online"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        onSaved: (val) => widget.user.fifaName = val,
      )
    ];
  }

  Widget cardContainer(IconData groupIcon, String tittle, List<Widget> childs) {
    return Card(
        margin: const EdgeInsets.all(16),
        child: new Column(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    groupIcon,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    tittle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              new Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: childs,
                  )),
            ]));
  }

  void onUpdate() async {
    var form = formKey.currentState;
    form.save();
    await Firestore.instance
        .collection('users')
        .document(widget.user.id)
        .updateData({
      'nickName': widget.user.userName,
      'lolName': widget.user.lolName,
      'gender': widget.user.gender,
      'phoneNumber': widget.user.phoneNumber,
      'email': widget.user.email,
      'age': widget.user.age,
      'pupgName': widget.user.pupgName,
      'rosName': widget.user.rosName,
      'fifaName': widget.user.fifaName,
      'sokName': widget.user.sokName,
    });
//    parentWidget.initState();
//    parentWidget.setState(() {
//      parentWidget.nickName = _userName;
//    });
    final snackBar = SnackBar(content: Text('Update successfully!'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            cardContainer(Icons.person, "User info", _UserInfoForm()),
            cardContainer(Icons.videogame_asset, "Game info", _GameInfoForm()),
            MaterialButton(
              onPressed: onUpdate,
              color: Colors.teal,
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget padded({Widget child}) {
  return new Padding(
    padding: EdgeInsets.symmetric(vertical: 0.0),
    child: child,
  );
}

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
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
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines
        .sublist(0, lines.length - 1)
        .map<Widget>((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
              icon: Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed)));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}

class MyProfile extends StatefulWidget {
  const MyProfile({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  static const String routeName = '/contacts';

  @override
  MyProfileState createState() => MyProfileState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class MyProfileState extends State<MyProfile> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  File imageFile;
  bool isLoading;
  User _userInfo = new User(); //model/user.dart

  FirebaseUser firebaseUser;
  initState()  {
    super.initState();
    isLoading = false;
     LoginAPI.currentUser().then((user) {
      setState(() {
        firebaseUser = user;
        _userInfo.id = user.uid;
      });
    });
  }
  Widget buildAvatar(BuildContext context, DocumentSnapshot document) {
    return CachedNetworkImage(
      placeholder: Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        decoration: BoxDecoration(
          color: greyColor2,
        ),
      ),
      errorWidget: Material(
        child: Image.asset(
          'images/avatar_empty.png',
          fit: BoxFit.cover,
        ),
        clipBehavior: Clip.hardEdge,
      ),
      imageUrl: document['photoUrl'],
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
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child(AVATAR_BASE_NAME + firebaseUser.uid);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      //update photoUrl
      final List<DocumentSnapshot> documents = result.documents;
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .updateData({
        'photoUrl': downloadUrl,
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
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    if(firebaseUser == null){
      return Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        decoration: BoxDecoration(
          color: greyColor2,
        ),
      );
    }
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating ||
                  _appBarBehavior == AppBarBehavior.snapping,
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
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<AppBarBehavior>>[
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.normal,
                            child: Text('App bar scrolls away')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.pinned,
                            child: Text('App bar stays put')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.floating,
                            child: Text('App bar floats')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.snapping,
                            child: Text('App bar snaps')),
                      ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .where('id', isEqualTo: firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(" ");
                    } else {
                      return Text(snapshot.data.documents[0]['nickName']);
                    }
                  },
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .where('id', isEqualTo: firebaseUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          );
                        } else {
                          return buildAvatar(
                              context, snapshot.data.documents[0]);
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
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .where('id', isEqualTo: firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      );
                    } else {
                      var data = snapshot.data.documents[0];
                      _userInfo.lolName = data['lolName'];
                      _userInfo.sokName = data['sokName'];
                      _userInfo.fifaName = data['fifaName'];
                      _userInfo.rosName = data['rosName'];
                      _userInfo.pupgName = data['pupgName'];
                      _userInfo.age = data['age'];
                      _userInfo.email = data['email'];
                      _userInfo.phoneNumber = data['phoneNumber'];
                      _userInfo.gender = data['gender'];
                      _userInfo.userName = data['nickName'];
                      return _GroupInfo(user: _userInfo);
                    }
                  },
                ),
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
