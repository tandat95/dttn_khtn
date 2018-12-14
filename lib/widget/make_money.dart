import 'package:flutter/material.dart';

class MakeMoney extends StatefulWidget {
  MakeMoney({
    Key key,
  }) : super(key: key);

  @override
  _MakeMoneyState createState() => new _MakeMoneyState();
}

enum FormType { login, register }

class _MakeMoneyState extends State<MakeMoney> {
  bool _enable = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Make money'),
        actions: <Widget>[
          Container(
            child: Switch(
              value: _enable,
              onChanged: (bool value) {
                setState(() {
                  _enable = !_enable;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.padded,
              activeColor: Colors.white,
            ),
          )
        ],
      ),
      //backgroundColor: Colors.grey[300],
      body: new SingleChildScrollView(
        child:
            new Container(padding: const EdgeInsets.all(16.0), child: Text('')),
      ),
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
