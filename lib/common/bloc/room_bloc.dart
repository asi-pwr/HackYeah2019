import 'package:firebase_auth/firebase_auth.dart';

import 'base_bloc.dart';

class RoomBloc extends BaseBloc {

  FirebaseAuth firebaseAuth;

  RoomBloc(this.firebaseAuth);
}