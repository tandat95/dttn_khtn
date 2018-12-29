import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const HORIZONTAL = 0;
const VERTICAL = 1;
const DIAGONAL_ASCENDING = 2;
const DIAGONAL_DESCENDING = 3;
const NAME = 'name';
const PHOTO_URL = 'photoUrl';
const PUSH_ID = 'pushId';
const USERS = 'users';
const USER_ID = 'userId';
const USER_NAME = 'userName';
const USER_LIST = 'userList';
const AVATAR_BASE_NAME = 'avatarImage';
const UNREAD_MES = 'unReadMes';
const FOLLOWING = 'following';
const FOLLOWER = 'follower';

const GGLOGIN = 'googleLogin';
const EMAILLOGIN = 'emailLogin';
const EMAILREG = 'emailReg';
const DEFAULT_PHOTO_URL = "https://firebasestorage.googleapis.com/v0/b/testnotification-29624.appspot.com/o/avatar_default.png?alt=media&token=d21ab19e-17a9-4746-bf57-edd1aca8916a";
const UNKNOW_USER = 'Unknow user';
const USER_NOT_EXIST = 'User not exist!';
const NOTHING_TO_SEND = 'Nothing to send!';

Firestore FIRESTORE;

int TAB_INDEX = 0;
bool NEW_MES = false;
List<String> FOLLOWED_LIST = new List();

FirebaseUser CURRENT_USER;

Color themeColor = Colors.blue;

final subColor1 = new Color(0xffaeaeae);
final subColor2 = new Color(0xffE8E8E8);

final titleColorH1 = new Color(0xFF333333);
final titleColorH2 = new Color(0xFF333333);

void setUnReadMesStatus(String userId, bool isRead) {
  if (CURRENT_USER != null) {
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(userId)
        .update({UNREAD_MES: isRead});
  }
}

Widget SET_LOADING (){
 return Center(
    child: RefreshProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
    ),
  );
}