import 'common_injector.dart' as _i1;
import 'common_module.dart' as _i2;
import '../common/network/jaguar_factory.dart' as _i3;
import '../common/network/service/stack_service.dart' as _i4;
import '../common/repository/stack_questions_repository.dart' as _i5;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'dart:async' as _i7;
import '../ui/app.dart' as _i8;
import '../common/bloc/stack_questions_bloc.dart' as _i9;
import '../common/network/rest_io_client.dart' as _i10;
import '../common/bloc/login_bloc.dart' as _i11;

class CommonInjector$Injector implements _i1.CommonInjector {
  CommonInjector$Injector._(this._commonModule);

  final _i2.CommonModule _commonModule;

  _i3.JaguarFactory _singletonJaguarFactory;

  _i4.StackService _singletonStackService;

  _i5.StackQuestionsRepository _singletonStackQuestionsRepository;

  _i6.FirebaseAuth _singletonFirebaseAuth;

  static _i7.Future<_i1.CommonInjector> create(
      _i2.CommonModule commonModule) async {
    final injector = CommonInjector$Injector._(commonModule);

    return injector;
  }

  _i8.App _createApp() => _i8.App();
  _i9.StackQuestionsBloc _createStackQuestionsBloc() =>
      _commonModule.stackQuestionsBloc(_createStackQuestionsRepository());
  _i5.StackQuestionsRepository _createStackQuestionsRepository() =>
      _singletonStackQuestionsRepository ??=
          _commonModule.stackQuestionsRepository(_createStackService());
  _i4.StackService _createStackService() => _singletonStackService ??=
      _commonModule.stackService(_createJaguarFactory());
  _i3.JaguarFactory _createJaguarFactory() => _singletonJaguarFactory ??=
      _commonModule.jaguarFactory(_createRestIOClient());
  _i10.RestIOClient _createRestIOClient() => _commonModule.restIoClient();
  _i11.LoginBloc _createLoginBloc() =>
      _commonModule.loginBloc(_createFirebaseAuth());
  _i6.FirebaseAuth _createFirebaseAuth() =>
      _singletonFirebaseAuth ??= _commonModule.firebaseAuth();
  @override
  _i8.App get app => _createApp();
  @override
  _i9.StackQuestionsBloc get stackQuestionsBloc => _createStackQuestionsBloc();
  @override
  _i11.LoginBloc get loginBloc => _createLoginBloc();
}
