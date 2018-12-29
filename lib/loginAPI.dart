import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/constants.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAPI {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FirebaseUser firebaseUser;

  LoginAPI(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<FirebaseUser> signInWithGoogle() async {
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
    saveUserToFirebase(user);
    return user;
  }

  static Future<FirebaseUser> emailLogin(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    saveUserToFirebase(user);
    return user;
  }

  static Future<FirebaseUser> createUser(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    saveUserToFirebase(user);
    return user;
  }

  static Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user != null ? user : null;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_NAME);
    prefs.remove(PUSH_ID);
    prefs.remove(USER_ID);
  }

  static Future<void> saveUserToFirebase(FirebaseUser user) async {
    var token = await _firebaseMessaging.getToken();
    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result = await FIRESTORE
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        FIRESTORE.collection('users').document(user.uid).setData({
          'nickName': user.displayName != null ? user.displayName : user.email,
          'photoUrl': user.photoUrl != null ? user.photoUrl : DEFAULT_PHOTO_URL,
          'id': user.uid,
          'pushId': token,
          'follower': 0
        });
      } else {
        FIRESTORE
            .collection('users')
            .document(user.uid)
            .updateData({'pushId': token});
      }
    }

    var update = {
      'name': user.displayName,
      'photoUrl': user.photoUrl,
      'pushId': token,
      UNREAD_MES: false
    };
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_NAME, user.displayName);
    prefs.setString(PUSH_ID, token);
    prefs.setString(USER_ID, user.uid);
    return FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .update(update);
  }

  static Future<void> sendNotification(String toPushId, String fromPushId,
      String fromUid, String title, String text) async {
    var base = 'https://us-central1-testnotification-29624.cloudfunctions.net';
    String dataURL =
        '$base/sendNotification2?to=$toPushId&fromPushId=$fromPushId&fromId=$fromUid&title=$title&text=$text&type=invite';
    http.get(dataURL);
  }
}
