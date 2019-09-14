import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter1/common/model/event/UserResponder.dart';

class ContinuousEventsRepository {
  FirebaseAuth _firebaseAuth;
  Firestore _firestore;
  FirebaseUser _user;

  ContinuousEventsRepository(this._firestore, this._firebaseAuth){
    _firebaseAuth.currentUser().then((value){_user = value;});
  }

  Stream<QuerySnapshot> eventStream(String roomId) {
   return _firestore.collection("room")
       .document(roomId)
       .collection("event")
       .snapshots();
  }

  void createNewEvent(String name, String roomId){
    _firestore.collection("room")
        .document(roomId)
        .collection("event")
        .document()
        .setData({
          'authorId': _user.uid,
          'name': name,
          'responderList': List.from({name})
        });
  }
}