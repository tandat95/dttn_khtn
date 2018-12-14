import 'package:flutter/material.dart';
import 'login.dart';
import 'widget/home.dart';
import 'package:dttn_khtn/loginAPI.dart';
import 'package:dttn_khtn/widget/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  FirebaseUser firebaseUser = null;
  initState() {
    super.initState();
    LoginAPI.currentUser().then((user) {
      setState(() {
        authStatus = user != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        firebaseUser = user;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Login',
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return FutureBuilder(
          future: LoginAPI.currentUser(),
            builder: (context, snapshot) {
          return snapshot.connectionState ==
              ConnectionState.done
              ? new MyHomePage(
            title: 'Home', user: snapshot.data,onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
          ):Container();
        });

    }
  }
}