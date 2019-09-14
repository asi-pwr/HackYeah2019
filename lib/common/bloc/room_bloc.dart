import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/common/repository/continuous_events_repository.dart';

import 'base_bloc.dart';

class RoomBloc extends BaseBloc {

  ContinuousEventsRepository _continuousEventsRepository;

  String _roomId;

  set roomId(String id){
    _roomId = id;
  }

  RoomBloc(this._continuousEventsRepository);

  Stream<QuerySnapshot> continuousEventsStream() =>
      _continuousEventsRepository.eventStream(_roomId);

  void createNewContinuousEvent(String name) =>
      _continuousEventsRepository.createNewEvent(name, _roomId);
}