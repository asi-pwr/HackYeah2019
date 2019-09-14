import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class MainBloc extends BaseBloc {
  final FirebaseMessaging _firebaseMessaging;

  final _messageSubject = BehaviorSubject<Map<String, dynamic>>();
  Observable<Map<String, dynamic>> get messageStream => _messageSubject.stream;

  MainBloc(this._firebaseMessaging);

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