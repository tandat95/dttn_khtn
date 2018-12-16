import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:dttn_khtn/widget/user_profile.dart';
class Choice {
  const Choice({this.title, this.icon, this.isPaid});

  final String title;
  final bool isPaid;
  final IconData icon;
}

class ListUser extends StatelessWidget {
  //bool isLoading = false;

  ListUser();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: themeColor,
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  TabBar(
                    isScrollable: true,
                    tabs: choices.map((Choice choice) {
                      return Tab(
                        text: choice.title,
                        //icon: Icon(choice.icon),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

//        appBar: AppBar(
//
//          //title: const Text('List player'),
//          bottom: TabBar(
//            isScrollable: true,
//            tabs: choices.map((Choice choice) {
//              return Tab(
//                text: choice.title,
//                //icon: Icon(choice.icon),
//              );
//            }).toList(),
//          ),
//        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: ChoiceCard(choice: choice),
            );
          }).toList(),
        ),
      ),
    );
  }
}

const List<Choice> choices = const <Choice>[
//  const Choice(title: 'Top', icon: Icons.star_border),
//  const Choice(title: 'All', icon: Icons.list),
//  const Choice(title: 'Online', icon: Icons.network_wifi),
  const Choice(title: 'All player', isPaid: false),
  const Choice(title: 'Followed', isPaid: true),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;
  final bool isLoading = false;

  Widget loadGenderIcon(DocumentSnapshot document) {
    String strGender = document['gender'];
    if (strGender == 'Male') {
      return Image.asset("images/ic_male.png");
    } else if (strGender == 'Female') {
      return Image.asset("images/ic_female.png");
    }
    return Text('--');
  }

  Widget buildGameInfo(DocumentSnapshot document) {
    var allGames = <String>[
      'lolName',
      'pupgName',
      'rosName',
      'sokName',
      'fifaName'
    ];
    var displayGame = <String>['LOL', 'PUPG', 'ROS', 'SOK (LQMB)', 'FIFA'];
    var listGame = <String>[];
    for (int i = 0; i < allGames.length; i++) {
      if (document[allGames[i]] != null && document[allGames[i]] != '') {
        listGame.add(displayGame[i]);
      }
    }
    String strGame = listGame.join(', ');
    return Container(
      child: Text(
        'Games: ${strGame ?? '--'}',
        style: TextStyle(color: primaryColor),
      ),
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: FlatButton(
        child:
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: CachedNetworkImage(
                    placeholder: Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                    imageUrl: document['photoUrl'],
                    width: 60.0,
                    height: 60.0,
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
                            '${document['nickName']}',
                            style: TextStyle(
                                color: titleColorH2,
                                //fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                        new Container(
                          child: Text(
                            '${document['aboutMe'] ?? '--'}',
                            style: TextStyle(color: subColor1),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        ),
                        buildGameInfo(document)
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
                loadGenderIcon(document),
              ],
            ),
            Divider(height: 5,)
          ],
        ),

        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new UserProfile(
                        document: document ,
                        followed: FOLLOWED_LIST.contains(document['id']),
                      )));
        },
        //color: subColor2,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        shape: RoundedRectangleBorder(),
      ),
     // margin: EdgeInsets.only(bottom: 3.0, left: 3.0, right: 3.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          // List
          Container(
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
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
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
          )
        ],
      ),
      onWillPop: () {},
    );
  }
}
