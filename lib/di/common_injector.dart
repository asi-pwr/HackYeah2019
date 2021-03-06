import 'package:flutter1/common/bloc/chat_bloc.dart';
import 'package:flutter1/common/bloc/login_bloc.dart';
import 'package:flutter1/common/bloc/room_bloc.dart';
import 'package:inject/inject.dart';

import 'common_module.dart';
import 'package:flutter1/ui/app.dart';
import 'common_injector.inject.dart' as g;

@Injector(const [CommonModule])
abstract class CommonInjector {

  @provide
  App get app;

  static final create = g.CommonInjector$Injector.create;

  //Dynamic injectors
  @provide
  LoginBloc get loginBloc;

  @provide
  RoomBloc get roomBloc;
  
  @provide
  ChatBloc get chatBloc;
}