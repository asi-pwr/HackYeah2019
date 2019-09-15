import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
       .where('continuous', isEqualTo: true)
       .snapshots();
  }

  Stream<QuerySnapshot> questionStream(String roomId) {
    return _firestore.collection("room")
        .document(roomId)
        .collection("event")
        .where('continuous', isEqualTo: false)
        .snapshots();
  }

  void createNewEvent(String name, String roomId, bool continuous){
    _firestore.collection("room")
        .document(roomId)
        .collection("event")
        .document()
        .setData({
          'continuous': continuous,
          'type': 0,
          'minAccepted': -1,
          'authorId': _user.uid,
          'name': name,
          'responderList': List.from({{
            'uid':_user.uid,
            'name':_user.displayName,
            'imgUrl':_user.photoUrl
          }})
        });
  }

  void toggleTakingEvent(DocumentSnapshot item, String roomId, bool yes){
    var responders = item['responderList'] as List<dynamic>;
    var remove = false;
    var rmMap;

    for(final map in responders){
      if(map['uid'] == _user.uid){
        remove = true;
        rmMap = map;
        break;
      }
    }

    var newResponders = List<dynamic>.from(responders);

    if(remove){
      newResponders.remove(rmMap);
    } else {
      newResponders.add({
        'uid':_user.uid,
        'name':_user.displayName,
        'imgUrl':_user.photoUrl,
        'yes': yes
      });
    }

    _firestore.collection("room")
        .document(roomId)
        .collection("event")
        .document(item.documentID)
        .updateData({
      'responderList':newResponders
    });
  }
}