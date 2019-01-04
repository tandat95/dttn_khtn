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
import 'package:flutter_native_image/flutter_native_image.dart';

class _GroupInfo extends StatelessWidget {
  final User user;

  _GroupInfo({Key key, this.user}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  //MyProfileState parentWidget;

  List<String> _genders = <String>['--', 'Male', 'Female'];

  Widget buildTextField(
      label, iconData, initVal, onSave, inputType, maxLength, maxLine) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        style: new TextStyle(color: Colors.black),
        keyboardType: inputType,
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
        onSaved: onSave,
      ),
    );
  }

  List<Widget> _UserInfoForm() {
    return [
      buildTextField('Username', Icons.person, user.userName, (val) {
        user.userName = val;
      }, TextInputType.text, null, 1),
      buildTextField('Email', Icons.email, user.email, (val) {
        user.email = val;
      }, TextInputType.emailAddress, null, 1),
      buildTextField('Phone', Icons.phone, user.phoneNumber, (val) {
        user.phoneNumber = val;
      }, TextInputType.phone, null, 1),
      buildTextField('Age', Icons.cake, user.age, (val) {
        user.age = val;
      }, TextInputType.number, null, 1),
      Container(
        padding: const EdgeInsets.only(top: 16.0),
        child: new DropdownButtonFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.people,
              color: themeColor,
            ),
            labelText: 'Gender',
            labelStyle: TextStyle(color: themeColor),
            helperStyle: TextStyle(color: themeColor),
            enabledBorder:  OutlineInputBorder(
              borderSide:  BorderSide(color: themeColor, width: 0.5),
              borderRadius:  BorderRadius.all(Radius.circular(10.0)),
            ),
            border:  OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          value: user.gender,
          onChanged: (String newValue) {
            user.gender = newValue;
            //state.didChange(newValue);
          },
          items: _genders.map((String value) {
            return new DropdownMenuItem(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onSaved: (val) => user.gender = val,
        ),
      ),
      buildTextField('About you', Icons.info, user.desciption, (val) {
        user.desciption = val;
      }, TextInputType.multiline, 100, 3)
    ];
  }

  List<Widget> _GameInfoForm() {
    return [
      buildTextField('Nick LOL', Icons.games, user.lolName, (val) {
        user.lolName = val;
      }, TextInputType.text, null, 1),
      buildTextField('Nick PUPG', Icons.games, user.pupgName, (val) {
        user.pupgName = val;
      }, TextInputType.text, null, 1),
      buildTextField('Nick Rules Of Survival', Icons.games, user.rosName,
          (val) {
        user.rosName = val;
      }, TextInputType.text, null, 1),
      buildTextField('Nick Strike of Kings (LQMB)', Icons.games, user.sokName,
          (val) {
        user.sokName = val;
      }, TextInputType.text, null, 1),
      buildTextField('Nick FIFA Online', Icons.games, user.fifaName, (val) {
        user.fifaName = val;
      }, TextInputType.text, null, 1),
    ];
  }

  Widget cardContainer(IconData groupIcon, String tittle, List<Widget> childs) {
    return Card(
        margin: const EdgeInsets.all(16),
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

  void doUpdate(BuildContext context) async {
    var form = formKey.currentState;
    form.save();
    await FIRESTORE.collection('users').document(user.id).updateData({
      'nickName': user.userName,
      'lolName': user.lolName,
      'gender': user.gender,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'age': user.age,
      'pupgName': user.pupgName,
      'rosName': user.rosName,
      'fifaName': user.fifaName,
      'sokName': user.sokName,
      'aboutMe': user.desciption
    });
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
  _GroupInfo _groupInfo;

  initState() {
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
  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      int quality;
      if (imageFile.lengthSync() / 1000 < 1000) {
        quality = 20;
      } else if (imageFile.lengthSync() / 1000 < 3000) {
        quality = 15;
      } else if (imageFile.lengthSync() / 1000 < 6000) {
        quality = 10;
      } else {
        quality = 5;
      }

      File compressedFile = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: quality,
          percentage: 100);
      imageFile = compressedFile;
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
    final QuerySnapshot result = await FIRESTORE
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      //update photoUrl
      final List<DocumentSnapshot> documents = result.documents;
      FIRESTORE.collection('users').document(firebaseUser.uid).updateData({
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

  Widget buildFAB(bool isMyprofile) {
    IconData iconData = isMyprofile ? Icons.save : Icons.message;
    return FloatingActionButton(
      onPressed: () {
        if (isMyprofile) {
          if (_groupInfo != null) _groupInfo.doUpdate(context);
        }
      },
      child: Icon(
        iconData,
        color: Colors.white,
      ),
      backgroundColor: themeColor,
    );
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null) {
      return Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        decoration: BoxDecoration(
          color: subColor2,
        ),
      );
    }
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: themeColor,
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
//                PopupMenuButton<AppBarBehavior>(
//                  onSelected: (AppBarBehavior value) {
//                    setState(() {
//                      _appBarBehavior = value;
//                    });
//                  },

//                  itemBuilder: (BuildContext context) =>
//                      <PopupMenuItem<AppBarBehavior>>[
//                        const PopupMenuItem<AppBarBehavior>(
//                            value: AppBarBehavior.normal,
//                            child: Text('App bar scrolls away')),
//                        const PopupMenuItem<AppBarBehavior>(
//                            value: AppBarBehavior.pinned,
//                            child: Text('App bar stays put')),
//                        const PopupMenuItem<AppBarBehavior>(
//                            value: AppBarBehavior.floating,
//                            child: Text('App bar floats')),
//                        const PopupMenuItem<AppBarBehavior>(
//                            value: AppBarBehavior.snapping,
//                            child: Text('App bar snaps')),
//                      ],
//                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: StreamBuilder(
                  stream: FIRESTORE
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
                      stream: FIRESTORE
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
                  stream: FIRESTORE
                      .collection('users')
                      .where('id', isEqualTo: firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
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
                      _userInfo.desciption = data['aboutMe'];
                      _groupInfo = new _GroupInfo(user: _userInfo);
                      return Column(
                        children: <Widget>[
                          new SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: Container(
                                child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            data[FOLLOWER] != null
                                                ? data[FOLLOWER].toString()
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                      VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                              data[FOLLOWING] != null
                                                  ? data[FOLLOWING]
                                                      .length
                                                      .toString()
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      )
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center),
                                //color: Colors.black26,
                              )),
                          _groupInfo
                        ],
                      );
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
