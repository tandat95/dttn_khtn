import 'package:flutter/material.dart';
import 'primary_button.dart';
import 'package:dttn_khtn/loginAPI.dart';
import 'common/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/user.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.onSignIn}) : super(key: key);
  final String title;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(String type) async {
//    User user = new User("","","","fuk5icTo2OM:APA91bHpXJwoaDlyQoowg42OLNwty8W1rUQmXXq5XHCEnpBFm2qVNS1k2mGb2ZuaR6081piYAhk0QYbbubng5qBv0G-ZsiYHiszDbnFz75louAfB93_GuQn5t8pnMLaU69mo0glA4MjD");
//    LoginAPI.sendNotification(user);
    switch (type){
      case GGLOGIN:
        LoginAPI.signInWithGoogle()
            .then((user) =>LoginAPI.saveUserToFirebase(user));

        break;
      case EMAILLOGIN:
        if (validateAndSave()) {
          try {
            FirebaseUser user = _formType == FormType.login
                ? await LoginAPI.emailLogin(_email, _password)
                : await LoginAPI.createUser(_email, _password);
            var userId = user.uid;
            setState(() {
              _authHint = 'Signed In\n\nUser id: $userId';
            });
            widget.onSignIn();
          }
          catch (e) {
            setState(() {
              _authHint = 'Sign In Error\n\n${e.toString()}';
            });
          }
        } else {
          setState(() {
            _authHint = '';
          });
        }
        break;
      case EMAILREG:

        break;
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(child: new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),
      padded(child: new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          new PrimaryButton(
              key: new Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed:()=> validateAndSubmit(EMAILLOGIN)
          ),
          new FlatButton(
              key: new Key('need-account'),
              child: new Text("Need an account? Register"),
              onPressed: moveToRegister
          ),
          new PrimaryButton(
              key: new Key('ggLogin'),
              text: 'Login with Google',
              height: 44.0,
              onPressed:()=> validateAndSubmit(GGLOGIN)
          ),
        ];
      case FormType.register:
        return [
          new PrimaryButton(
              key: new Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed:()=> validateAndSubmit(EMAILLOGIN)
          ),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text("Have an account? Login"),
              onPressed: moveToLogin
          ),
        ];
    }
    return null;
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: new SingleChildScrollView(child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(),
                                    )
                                )
                            ),
                          ])
                  ),
                  hintText()
                ]
            )
        ))
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}

