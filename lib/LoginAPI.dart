import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAPI {

  Future<FirebaseUser> _signInWithGoogle();
  Future<void> _saveUserToFirebase(FirebaseUser user);

}
//class LoginAPI extends BaseAPI{
//  FirebaseAuth _auth = FirebaseAuth.instance;
//  GoogleSignIn _googleSignIn = GoogleSignIn();
//  FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();
//
//  Future<FirebaseUser> _signInWithGoogle() async {
//    var user = await _auth.currentUser();
//    if (user == null) {
//      GoogleSignInAccount googleUser = _googleSignIn.currentUser;
//      if (googleUser == null) {
//        googleUser = await _googleSignIn.signInSilently();
//        if (googleUser == null) {
//          googleUser = await _googleSignIn.signIn();
//        }
//      }
//      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//      user = await _auth.signInWithGoogle(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//      print("signed in as " + user.displayName);
//    }
//    return user;
//  }
//
//  Future<void> _saveUserToFirebase(FirebaseUser user) async {
//  print('saving user to firebase');
//  var token = await _firebaseMessaging.getToken();
//  var update = {
//  'name': user.displayName,
//  'photoUrl': user.photoUrl,
//  'pushId': token
//  };
//  return FirebaseDatabase.instance
//      .reference()
//      .child('users')
//      .child(user.uid)
//      .update(update);
//  }
//}

class LoginAPI {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser firebaseUser;

  LoginAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<LoginAPI> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(user.email != null);
    assert(user.displayName != null);

    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return LoginAPI(user);
  }
}
