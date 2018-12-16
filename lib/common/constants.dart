import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

const GGLOGIN = 'googleLogin';
const EMAILLOGIN = 'emailLogin';
const EMAILREG = 'emailReg';

int TAB_INDEX = 0;
bool NEW_MES = false;
List<String> FOLLOWED_LIST = new List();

FirebaseUser CURRENT_USER;

final MaterialColor primaryColor = Colors.deepOrange;
final MaterialColor themeColor = Colors.deepOrange;

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
