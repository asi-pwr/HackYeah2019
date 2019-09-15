import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContinuousMessagesRepository {
  FirebaseAuth _firebaseAuth;
  Firestore _firestore;
  FirebaseUser _user;

  ContinuousMessagesRepository(this._firestore, this._firebaseAuth) {
    _firebaseAuth.currentUser().then((value) {
      _user = value;
    });
  }

  Stream<QuerySnapshot> chatStream(String roomId) {
    return _firestore
        .collection("room")
        .document("globalRoom")
        .collection("chat")
        .snapshots();
  }

  Stream<QuerySnapshot> sendMessage(String roomId, content) {
    var docReference = _firestore
        .collection("room")
        .document(roomId)
        .collection("chat")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    _firestore.runTransaction((transaction) async {
      await transaction
          .set(docReference, {'userId': _user.uid, 'content': content, 'user': _user.displayName});
    });
  }
}
