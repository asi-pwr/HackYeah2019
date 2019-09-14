import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class UserDataRepository {
  FirebaseMessaging _firebaseMessaging;
  Firestore _firestore;

  UserDataRepository(this._firestore, this._firebaseMessaging);

  void saveUserData(FirebaseUser user){
    _firebaseMessaging.getToken().then((token) => _pushUserData(user, token));
  }

  void _pushUserData(FirebaseUser user, String token){
    _firestore.collection("user")
        .document(user.uid)
        .setData({
          'name': user.displayName,
          'pushToken': token,
          'userImg': user.photoUrl
        });
  }

  Observable<DocumentSnapshot> getUserData(String uid){
     return Observable<DocumentSnapshot>.fromFuture(
         _firestore.collection("user")
             .document(uid)
             .get(source: Source.serverAndCache));
  }
}
