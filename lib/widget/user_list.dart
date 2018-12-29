import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dttn_khtn/common/constants.dart';
import 'package:dttn_khtn/widget/user_profile.dart';

class Choice {
  const Choice({this.title, this.icon, @required this.mode});

  final String title;
  final IconData icon;
  final String mode; // 'ALL', 'FOLLOWING'
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
                    indicatorColor: Colors.white,
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
  const Choice(title: 'All player', mode: 'ALL'),
  const Choice(title: 'Followed', mode: 'FOLLOWING'),
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
        style: TextStyle(color: themeColor),
      ),
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
      child: Container(
        //decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: Container(
          child: ListTile(
            leading: Material(
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
            title: new Container(
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
            subtitle: Column(
              children: <Widget>[
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
            trailing: loadGenderIcon(document),
            isThreeLine: true,

            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new UserProfile(
                        userId: document['id'],
                        //followed: FOLLOWED_LIST.contains(document['id']),
                      )));
            },
            //color: subColor2,
          ),
          // margin: EdgeInsets.only(bottom: 3.0, left: 3.0, right: 3.0),
        ),
      ),
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
              stream: FIRESTORE
                  .collection('users')
                  .orderBy(FOLLOWER, descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SET_LOADING();
                } else {
                  var documents = snapshot.data.documents;
                  if (choice.mode == "FOLLOWING") {
                    List<DocumentSnapshot> listDocument = new List();
                    for (int i = 0; i < documents.length; i++) {
                      if (FOLLOWED_LIST.contains(documents[i]['id'])) {
                        listDocument.add(documents[i]);
                      }
                    }
                    documents = listDocument;
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, documents[index]),
                    itemCount: choice.mode == "FOLLOWING"
                        ? FOLLOWED_LIST.length
                        : snapshot.data.documents.length,
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
