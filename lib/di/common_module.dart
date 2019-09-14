import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter1/common/bloc/login_bloc.dart';
import 'package:flutter1/common/bloc/main_bloc.dart';
import 'package:flutter1/common/bloc/room_bloc.dart';
import 'package:flutter1/common/repository/continuous_events_repository.dart';
import 'package:inject/inject.dart';

import 'package:flutter1/common/network/jaguar_factory.dart';
import 'package:flutter1/common/network/service/stack_service.dart';
import 'package:flutter1/common/repository/stack_questions_repository.dart';
import 'package:flutter1/common/bloc/stack_questions_bloc.dart';
import 'package:flutter1/common/network/rest_io_client.dart';

@module
class CommonModule {

  @provide
  RestIOClient restIoClient() => RestIOClient(
      HttpClient()
        ..connectionTimeout = const Duration(seconds: 10)
        ..idleTimeout = const Duration(seconds: 10)
  );

  @provide
  @singleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;

  @provide
  @singleton
  Firestore firestore() => Firestore.instance;

  @provide
  @singleton
  JaguarFactory jaguarFactory(RestIOClient restIOClient) =>
      JaguarFactory(restIOClient);

  @provide
  @singleton
  StackService stackService(JaguarFactory jaguarFactory) =>
      jaguarFactory.buildStackService();

  @provide
  @singleton
  StackQuestionsRepository stackQuestionsRepository(StackService stackService) =>
      StackQuestionsRepository(stackService);

  @provide
  ContinuousEventsRepository continuousEventsRepository(
      Firestore firestore, FirebaseAuth firebaseAuth) =>
      ContinuousEventsRepository(firestore, firebaseAuth);

  @provide
  StackQuestionsBloc stackQuestionsBloc(StackQuestionsRepository repository) =>
      StackQuestionsBloc(repository);

  @provide
  LoginBloc loginBloc(FirebaseAuth firebaseAuth) => LoginBloc(firebaseAuth);

  @provide
  RoomBloc roomBloc(ContinuousEventsRepository continuousEventsRepository) =>
      RoomBloc(continuousEventsRepository);

  @provide
  MainBloc mainBloc() => MainBloc(FirebaseMessaging()); //todo
}