import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter1/common/repository/user_data_repository.dart';

import 'base_bloc.dart';

class LoginBloc extends BaseBloc {

  FirebaseAuth firebaseAuth;

  UserDataRepository _userDataRepository;

  LoginBloc(this.firebaseAuth, this._userDataRepository);

  void saveUserData(FirebaseUser user) => _userDataRepository.saveUserData(user);
}