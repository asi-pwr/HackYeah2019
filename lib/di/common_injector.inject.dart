import 'common_injector.dart' as _i1;
import 'common_module.dart' as _i2;
import '../common/network/jaguar_factory.dart' as _i3;
import '../common/network/service/stack_service.dart' as _i4;
import '../common/repository/stack_questions_repository.dart' as _i5;
import 'dart:async' as _i6;
import '../ui/app.dart' as _i7;
import '../common/bloc/stack_questions_bloc.dart' as _i8;
import '../common/network/rest_io_client.dart' as _i9;

class CommonInjector$Injector implements _i1.CommonInjector {
  CommonInjector$Injector._(this._commonModule);

  final _i2.CommonModule _commonModule;

  _i3.JaguarFactory _singletonJaguarFactory;

  _i4.StackService _singletonStackService;

  _i5.StackQuestionsRepository _singletonStackQuestionsRepository;

  static _i6.Future<_i1.CommonInjector> create(
      _i2.CommonModule commonModule) async {
    final injector = CommonInjector$Injector._(commonModule);

    return injector;
  }

  _i7.App _createApp() => _i7.App();
  _i8.StackQuestionsBloc _createStackQuestionsBloc() =>
      _commonModule.stackQuestionsBloc(_createStackQuestionsRepository());
  _i5.StackQuestionsRepository _createStackQuestionsRepository() =>
      _singletonStackQuestionsRepository ??=
          _commonModule.stackQuestionsRepository(_createStackService());
  _i4.StackService _createStackService() => _singletonStackService ??=
      _commonModule.stackService(_createJaguarFactory());
  _i3.JaguarFactory _createJaguarFactory() => _singletonJaguarFactory ??=
      _commonModule.jaguarFactory(_createRestIOClient());
  _i9.RestIOClient _createRestIOClient() => _commonModule.restIoClient();
  @override
  _i7.App get app => _createApp();
  @override
  _i8.StackQuestionsBloc get stackQuestionsBloc => _createStackQuestionsBloc();
}
