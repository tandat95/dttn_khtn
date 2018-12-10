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
import 'package:dttn_khtn/widget/chat.dart';

//class _GroupInfo extends StatefulWidget {
//  const _GroupInfo({Key key, @required this.user,@required this.isMyProfile})
//      : super(key: key);
//  final User user;
//  final bool isMyProfile;
//
//  @override
//  _GroupInfoState createState() => _GroupInfoState();
//}

class _GroupInfo extends StatelessWidget {
  final DocumentSnapshot document;
  _GroupInfo({Key key, this.document}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  //MyProfileState parentWidget;

  List<String> _genders = <String>['--', 'Male', 'Female'];

  String _genderVal = '';

  User user (){
    User _userInfo = new User();
    _userInfo.lolName = document['lolName'];
    _userInfo.sokName = document['sokName'];
    _userInfo.fifaName = document['fifaName'];
    _userInfo.rosName = document['rosName'];
    _userInfo.pupgName = document['pupgName'];
    _userInfo.age = document['age'];
    _userInfo.email = document['email'];
    _userInfo.phoneNumber = document['phoneNumber'];
    _userInfo.gender = document['gender'];
    _userInfo.userName = document['nickName'];
   return _userInfo;
  }

  List<Widget> _UserInfoForm() {
    return [
      new TextFormField(
        enabled: false,
        key: new Key('username'),
        decoration: new InputDecoration(
          labelText: 'Username',
          icon: Icon(Icons.text_fields),
        ),
        initialValue: document['nickName'],
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('email'),
        decoration: new InputDecoration(
          labelText: 'Email',
          icon: Icon(Icons.email),
        ),
        initialValue:document['email'],
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('phoneNumber'),
        keyboardType: TextInputType.number,
        initialValue: document['phoneNumber'],
        decoration: new InputDecoration(
          labelText: 'Phone number',
          icon: Icon(Icons.phone),
        ),
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('age'),
        keyboardType: TextInputType.number,
        initialValue: document['age'],
        decoration: new InputDecoration(
          labelText: 'Age',
          icon: Icon(Icons.cake),
        ),
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('Gender'),
        keyboardType: TextInputType.number,
        initialValue: document['gender'],
        decoration: new InputDecoration(
          labelText: 'Gender',
          icon: Icon(Icons.people),
        ),
        autocorrect: false,
      ),
    ];
  }

  List<Widget> _GameInfoForm() {
    return [
      new TextFormField(
        enabled: false,
        key: new Key('lolName'),
        decoration: new InputDecoration(
          labelText: 'Nick "LOL"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
        initialValue: document['lolName'],
      ),
      new TextFormField(
        enabled: false,
        key: new Key('pupgName'),
        initialValue: document['pupgName'],
        decoration: new InputDecoration(
          labelText: 'Nick "PUPG"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('rosName'),
        initialValue: document['rosName'],
        decoration: new InputDecoration(
          labelText: 'Nick "Rules Of Survival"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('sokName'),
        initialValue: document['sokName'],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: 'Nick "Strike of Kings (LQMB)"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
      ),
      new TextFormField(
        enabled: false,
        key: new Key('fifaName'),
        initialValue: document['fifaName'],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: 'Nick "Fifa online"',
          icon: Icon(Icons.games),
        ),
        autocorrect: false,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            cardContainer(Icons.person, "User info", _UserInfoForm()),
            cardContainer(Icons.videogame_asset, "Game info", _GameInfoForm()),
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

class UserProfile extends StatefulWidget {
  const UserProfile({Key key, this.document}) : super(key: key);
  final DocumentSnapshot document;
  static const String routeName = '/contacts';

  @override
  UserProfileState createState() => UserProfileState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class UserProfileState extends State<UserProfile> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  File imageFile;
  bool isLoading;
  User _userInfo = new User(); //model/user.dart
  _GroupInfo _groupInfo;

  initState() {
    super.initState();
    isLoading = false;
    LoginAPI.currentUser().then((user) {
      setState(() {
        _userInfo.id = widget.document['id'];
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

  Widget buildFAB(bool isMyprofile) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Chat(
                      peerId: widget.document.documentID,
                      peerAvatar: widget.document['photoUrl'],
                    )));
      },
      child: Icon(Icons.message),
    );
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    if (widget.document == null) {
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
        floatingActionButton: buildFAB(true),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating ||
                  _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              actions: <Widget>[
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
                title: Text(widget.document['nickName']) ,
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.document['photoUrl'],
                      fit: BoxFit.cover,
                    ),
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
              delegate: SliverChildListDelegate(
                  <Widget>[_GroupInfo(document: widget.document)]),
            ),
          ],
        ),
      ),
    );
  }
}
