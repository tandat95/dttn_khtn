import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dttn_khtn/widget/chat.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:flutter/foundation.dart';

class ChatList extends StatefulWidget {
  final String currentUserId;

  ChatList({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => new _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isLoading = false;
  Color appbarColor;
  bool stateDel;
  List<String> listDel = [];
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Delete message', icon: Icons.delete),
    //const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    appbarColor = themeColor;
    stateDel = false;
  }

  String buildLastTime(messageDoc) {
    var time = messageDoc['timestamp'];
    if (time != null) {
      int delta =
          DateTime.now().millisecondsSinceEpoch - int.parse(time.toString());
      delta = (delta / 1000).floor();
      if (delta < 60) {
        if (delta < 0) delta = 0;
        return '$delta sec';
      } else if (delta / 60 < 60) {
        delta = (delta / 60).floor();
        return '$delta min';
      } else if (delta / 3600 < 24) {
        delta = (delta / 3600).floor();
        return '$delta hour';
      } else {
        var dateTime = new DateTime.fromMillisecondsSinceEpoch(int.parse(time));
        var day = dateTime.day;
        var month = dateTime.month;
        var year = dateTime.year;
        return '$day/$month/$year';
      }
    }
    return '';
  }

  Widget buildLastContent(messageDoc) {
    Color textColor = Colors.black26;
    if (messageDoc['unRead'] == true) {
      textColor = Colors.black87;
    }
    String content = messageDoc['lastContent'];
    if (content != null) {
      var type = messageDoc['type'];
      if (type == 0) {
        if (content.length > 25) content = content.substring(0, 25) + '...';
      } else if (type == 1) {
        content = 'image..';
      } else if (type == 2) {
        content = 'sticker..';
      }
    }
    return Text(
      content,
      style: TextStyle(
          color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  Widget buildTrailing(userId,messageDoc, mesId) {
    bool ckValue = false;
    if (!stateDel) {
      return Text(
        buildLastTime(messageDoc),
        style: TextStyle(fontSize: 12),
      );
    }
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: themeColor,
      ),
      onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Delete message"),
                content: new Text("Do you want to delete this conversation?"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Yes", style: TextStyle(color: themeColor),),
                    onPressed: () {
                      FIRESTORE
                          .collection("users")
                          .document(userId)
                          .collection('user_messages').document(mesId).delete().then((snap){
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("No", style: TextStyle(color: themeColor),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
      },
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot userDoc,
      DocumentSnapshot messageDoc) {
    var photoUrl =
        userDoc['photoUrl'] != null ? userDoc['photoUrl'] : DEFAULT_PHOTO_URL;
    var nickName =
        userDoc['nickName'] != null ? userDoc['nickName'] : UNKNOW_USER;
    return Container(
      child: ListTile(
        leading: Container(
          child: Material(
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
              imageUrl: photoUrl,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          ),
        ),
        title: new Container(
          child: Text(
            nickName,
            style: TextStyle(
                color: Colors.black87,
                //fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          alignment: Alignment.centerLeft,
          margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
        ),
        subtitle: new Container(
          child: buildLastContent(messageDoc),
          alignment: Alignment.centerLeft,
          margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        ),
        trailing: buildTrailing(widget.currentUserId,messageDoc, messageDoc.documentID),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new Chat(
                        peerId: userDoc.documentID,
                        peerAvatar: photoUrl,
                        toPushId: userDoc['pushId'],
                        title: userDoc['nickName'],
                      )));
        },
        onLongPress: () {
          setState(() {
            stateDel = true;
          });
        },
      ),
    );
  }

  List<Widget> buildAction() {
    if (stateDel) {
      return <Widget>[
        FlatButton(
          child: Text("OK", style: TextStyle(color: Colors.white),),
          onPressed: () {
            setState(() {
              stateDel = false;
            });
          },
        )
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(
          'Message',
        ),
        actions: buildAction(),
//        actions: <Widget>[
//          PopupMenuButton<Choice>(
//            itemBuilder: (BuildContext context) {
//              return choices.map((Choice choice) {
//                return PopupMenuItem<Choice>(
//                    value: choice,
//                    child: Row(
//                      children: <Widget>[
//                        Icon(
//                          choice.icon,
//                          color: themeColor,
//                        ),
//                        Container(
//                          width: 10.0,
//                        ),
//                        Text(
//                          choice.title,
//                          style: TextStyle(color: titleColorH2),
//                        ),
//                      ],
//                    ));
//              }).toList();
//            },
//          ),
//        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: FIRESTORE
                    .collection("users")
                    .document(widget.currentUserId)
                    .collection('user_messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
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
                      itemBuilder: (context, index) {
                        var messDoc = snapshot.data.documents[index];
                        return StreamBuilder(
                          stream: FIRESTORE
                              .collection('users')
                              .document(messDoc.documentID)
                              .snapshots(),
                          builder: (context, snaps) {
                            if (!snaps.hasData) {
                              return Center(
                                child: RefreshProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                              );
                            } else {
                              return buildItem(context, snaps.data, messDoc);
                            }
                          },
                        );
                      },
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
