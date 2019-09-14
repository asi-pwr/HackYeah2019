import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter1/common/repository/continuous_events_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class RoomBloc extends BaseBloc {
  final FirebaseMessaging _firebaseMessaging;
  final ContinuousEventsRepository _continuousEventsRepository;

  String _roomId;

  set roomId(String id){
    _roomId = id;
  }

  final _messageSubject = BehaviorSubject<Map<String, dynamic>>();
  Observable<Map<String, dynamic>> get messageStream => _messageSubject.stream;

  RoomBloc(this._continuousEventsRepository, this._firebaseMessaging);

  Stream<QuerySnapshot> continuousEventsStream() =>
      _continuousEventsRepository.eventStream(_roomId);

  void createNewContinuousEvent(String name) =>
      _continuousEventsRepository.createNewEvent(name, _roomId);

  void toggleTakingEvent(DocumentSnapshot item) =>
      _continuousEventsRepository.toggleTakingEvent(item, _roomId);

  void initNotifications(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _messageSubject.sink.add(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageSubject.close();
  }
}