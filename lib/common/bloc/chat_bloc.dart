import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/common/bloc/base_bloc.dart';
import 'package:flutter1/common/repository/continuous_messages_repository.dart';

class ChatBloc extends BaseBloc {
  ContinuousMessagesRepository _continuousMessagesRepository;

  String _roomId;

  ChatBloc(this._continuousMessagesRepository);

  Stream<QuerySnapshot> continuousMessagesStream() =>
      _continuousMessagesRepository.chatStream(_roomId);
}
