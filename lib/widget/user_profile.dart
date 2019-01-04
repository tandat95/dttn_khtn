import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:dttn_khtn/model/user.dart';
import 'package:dttn_khtn/widget/chat.dart';

class _GroupInfo extends StatelessWidget {
  final DocumentSnapshot document;

  _GroupInfo({Key key, this.document}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  //MyProfileState parentWidget;

  List<String> _genders = <String>['--', 'Male', 'Female'];

  String _genderVal = '';

  User user() {
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

  Widget buildTextField(
      label, iconData, initVal, maxLength, maxLine) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        enabled: false,
        style: new TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            color: themeColor,
          ),
          labelText: label,
          labelStyle: TextStyle(color: themeColor),
          helperStyle: TextStyle(color: themeColor),
          enabledBorder:  OutlineInputBorder(
            borderSide:  BorderSide(color: themeColor, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        initialValue: initVal,
        autocorrect: false,
        maxLines: maxLine,
        maxLength: maxLength,
      ),
    );
  }

  List<Widget> _UserInfoForm() {
    return [
      buildTextField('Description',Icons.info, document['aboutMe'],null, 3),
      buildTextField('Email',Icons.email, document['email'],null, 1),
      buildTextField('Phone',Icons.phone, document['phoneNumber'],null, 1),
      buildTextField('Age',Icons.cake, document['age'],null, 1),
      buildTextField('Gender',Icons.people, document['gender'],null, 1)
    ];
  }

  List<Widget> _GameInfoForm() {
    return [
      buildTextField('Nick LOL', Icons.games, document['lolName'],  null, 1),
      buildTextField('Nick PUPG', Icons.games, document['pupgName'],  null, 1),
      buildTextField('Nick Rules Of Survival', Icons.games, document['rosName'], null, 1),
      buildTextField('Nick Strike of Kings (LQMB)', Icons.games, document['sokName'], null, 1),
      buildTextField('Nick FIFA Online', Icons.games, document['fifaName'],  null, 1),
    ];
  }

  Widget cardContainer(IconData groupIcon, String tittle, List<Widget> childs) {
    return Card(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: new Column(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Icon(
                      groupIcon,
                      color: themeColor,
                      size: 20,
                    ),
                    Text(
                      ' ' + tittle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                height: 30,
                padding: EdgeInsets.all(10),
              ),
              new Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
  const UserProfile({
    Key key,
    @required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  UserProfileState createState() => UserProfileState(this.userId);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class UserProfileState extends State<UserProfile> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  final String userId;
  File imageFile;
  bool isLoading;
  User _userInfo = new User(); //model/user.dart
  _GroupInfo _groupInfo;

  //int _numFollow;
  bool _followed;

  UserProfileState(@required this.userId);

  initState() {
    super.initState();
    isLoading = false;
    _followed = FOLLOWED_LIST.contains(userId);
    _userInfo.id = userId;
//    LoginAPI.currentUser().then((user) {
//      setState(() {
//
//        //_numFollow = widget.document[FOLLOWER];
//      });
//    });
  }

  Widget buildAvatar(BuildContext context, DocumentSnapshot document) {
    return CachedNetworkImage(
      placeholder: Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        decoration: BoxDecoration(
          color: subColor2,
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

  void onFollowClick(String userId, int numFollow) async {
    if (!_followed) {
      numFollow = numFollow != null ? numFollow + 1 : 1;

      FOLLOWED_LIST.add(userId);
    } else {
      numFollow = numFollow != null ? numFollow - 1 : 0;
      FOLLOWED_LIST.remove(userId);
    }
    setState(() {
      _followed = !_followed;
    });
     FIRESTORE
        .collection('users')
        .document(userId)
        .updateData({FOLLOWER: numFollow});
    print(FOLLOWED_LIST);
     FIRESTORE
        .collection('users')
        .document(CURRENT_USER.uid)
        .updateData({FOLLOWING: FOLLOWED_LIST});
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        decoration: BoxDecoration(
          color: subColor2,
        ),
      );
    }
    return StreamBuilder(
      stream:
      FIRESTORE.collection('users').document(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: RefreshProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          );
        }
        var doc = snapshot.data;
        return Theme(
          data: ThemeData(
            brightness: Brightness.light,
            primarySwatch: themeColor,
            platform: Theme.of(context).platform,
          ),
          child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(
                    _followed ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () => onFollowClick(_userInfo.id, doc[FOLLOWER]),
                  mini: true,
                  backgroundColor: themeColor,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Chat(
                                  peerId: doc.documentID,
                                  peerAvatar: doc['photoUrl'],
                                  toPushId: doc['pushId'],
                                  title: doc['nickName'],
                                )));
                  },
                  heroTag: null,
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  mini: true,
                  backgroundColor: themeColor,
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: _appBarHeight,
                  pinned: _appBarBehavior == AppBarBehavior.pinned,
                  floating: _appBarBehavior == AppBarBehavior.floating ||
                      _appBarBehavior == AppBarBehavior.snapping,
                  snap: _appBarBehavior == AppBarBehavior.snapping,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(doc['nickName']),
                    centerTitle: false,
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: doc['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, -0.4),
                              colors: <Color>[
                                Color(0x60000000),
                                Color(0x00000000)
                              ],
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
                    new SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Container(
                          child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      doc[FOLLOWER] != null
                                          ? doc[FOLLOWER].toString()
                                          : '0',
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: themeColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Follower',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                VerticalDivider(
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                        doc[FOLLOWING] != null
                                            ? doc[FOLLOWING].length.toString()
                                            : '0',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: themeColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      'Following',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center),
                          //color: Colors.black26,
                        )),
                    _GroupInfo(document: doc)
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
