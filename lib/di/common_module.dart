import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter1/common/bloc/chat_bloc.dart';
import 'package:flutter1/common/bloc/login_bloc.dart';
import 'package:flutter1/common/bloc/room_bloc.dart';
import 'package:flutter1/common/repository/continuous_messages_repository.dart';
import 'package:flutter1/common/repository/continuous_events_repository.dart';
import 'package:flutter1/common/repository/user_data_repository.dart';
import 'package:inject/inject.dart';

import 'package:flutter1/common/network/jaguar_factory.dart';
import 'package:flutter1/common/network/service/stack_service.dart';
import 'package:flutter1/common/network/rest_io_client.dart';

@module
class CommonModule {
  @provide
  RestIOClient restIoClient() => RestIOClient(HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..idleTimeout = const Duration(seconds: 10));

  @provide
  @singleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;

  @provide
  @singleton
  Firestore firestore() => Firestore.instance;

  @provide
  @singleton
  FirebaseMessaging firebaseMessaging() => FirebaseMessaging();

  @provide
  @singleton
  JaguarFactory jaguarFactory(RestIOClient restIOClient) =>
      JaguarFactory(restIOClient);

  @provide
  @singleton
  StackService stackService(JaguarFactory jaguarFactory) =>
      jaguarFactory.buildStackService();

  @provide
  ContinuousEventsRepository continuousEventsRepository(
          Firestore firestore, FirebaseAuth firebaseAuth) =>
      ContinuousEventsRepository(firestore, firebaseAuth);

  @provide
  ContinuousMessagesRepository continuousMessagesRepository(
      Firestore firestore, FirebaseAuth firebaseAuth) =>
      ContinuousMessagesRepository(firestore, firebaseAuth);

  @provide
  UserDataRepository userDataRepository(
          Firestore firestore, FirebaseMessaging firebaseMessaging) =>
      UserDataRepository(firestore, firebaseMessaging);

  @provide
  LoginBloc loginBloc(
          FirebaseAuth firebaseAuth, UserDataRepository userDataRepository) =>
      LoginBloc(firebaseAuth, userDataRepository);

  @provide
  ChatBloc chatBloc(
          ContinuousMessagesRepository continuousMessagesRepository) =>
      ChatBloc(continuousMessagesRepository);

  @provide
  RoomBloc roomBloc(ContinuousEventsRepository continuousEventsRepository,
      FirebaseMessaging firebaseMessaging, FirebaseAuth firebaseAuth) =>
      RoomBloc(continuousEventsRepository, firebaseMessaging, firebaseAuth);
}
