import 'package:flutter/material.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatelessWidget {
  MyProfile ({Key key, this.userId}) : super(key: key);
  final String userId;
  Widget buildItems  (BuildContext context, DocumentSnapshot document) {
   DocumentReference a = Firestore.instance.document('users');

    return new Container(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            placeholder: Container(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
              width: 50.0,
              height: 50.0,
              padding: EdgeInsets.all(15.0),
            ),
            imageUrl: document['photoUrl'],
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Profile',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              );
            } else {
              return buildItems(context, snapshot.data.documents[userId]);
            }
          },
        ),
      ),
    );
  }
}