import 'package:firebase_auth/firebase_auth.dart';

import 'base_bloc.dart';

class LoginBloc extends BaseBloc {

  FirebaseAuth firebaseAuth;

  LoginBloc(this.firebaseAuth);
}