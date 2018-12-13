import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dttn_khtn/widget/chat.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
class ChatList extends StatefulWidget {
  final String currentUserId;

  ChatList({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => new _ChatListState();
}

class _ChatListState extends State<ChatList> {
//  MainScreenState({Key key, @required this.currentUserId});
//
//  final String currentUserId;

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  Widget buildItem(BuildContext context, DocumentSnapshot document) {

   DocumentReference docRef = Firestore.instance
       .collection('users')
       .document(document.documentID);

   docRef.get().then((doc){
       var data = doc.data;
       return Container(
         child: FlatButton(
           child: Row(
             children: <Widget>[
               Material(
                 child: CachedNetworkImage(
                   placeholder: Container(
                     child: CircularProgressIndicator(
                       strokeWidth: 1.0,
                       valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                     ),
                     width: 50.0,
                     height: 50.0,
                     padding: EdgeInsets.all(15.0),
                   ),
                   imageUrl: 'https://firebasestorage.googleapis.com/v0/b/testnotification-29624.appspot.com/o/avatarImage7fL5SCXCXgVQ1b0BwjQoHg6zKt13?alt=media&token=be5f5db7-6600-4d8a-8efb-374f85ce6d77',
                   width: 50.0,
                   height: 50.0,
                   fit: BoxFit.cover,
                 ),
                 borderRadius: BorderRadius.all(Radius.circular(25.0)),
                 clipBehavior: Clip.hardEdge,
               ),
               new Flexible(
                 child: Container(
                   child: new Column(
                     children: <Widget>[
                       new Container(
                         child: Text(
                           "tdrireti",
                           style: TextStyle(
                               color: Colors.green,
                               fontWeight: FontWeight.bold,
                               fontSize: 16),
                         ),
                         alignment: Alignment.centerLeft,
                         margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                       ),
                       new Container(
                         child: Text(
                           'About me: ${data['aboutMe'] ?? 'Not available'}',
                           style: TextStyle(color: primaryColor),
                         ),
                         alignment: Alignment.centerLeft,
                         margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                       )
                     ],
                   ),
                   margin: EdgeInsets.only(left: 20.0),
                 ),
               ),
             ],
           ),
           onPressed: () {
             Navigator.push(
                 context,
                 new MaterialPageRoute(
                     builder: (context) => new Chat(
                       peerId: document.documentID,
                       peerAvatar: data['photoUrl'],
                     )));
           },
           color: greyColor2,
           padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
           shape: RoundedRectangleBorder(),
         ),
         margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
       );
   });
  }

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Message',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("users").document(widget.currentUserId).collection('user_messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(5.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
