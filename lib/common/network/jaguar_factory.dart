import 'package:inject/inject.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'package:flutter1/common/network/service/stack_service.dart';
import 'package:flutter1/common/model/stack_questions/stack_questions.dart';
import 'package:flutter1/common/network/rest_io_client.dart';

class JaguarFactory {

  @provide
  JaguarFactory(RestIOClient restIOClient){
    globalClient = restIOClient;
  }

  StackService buildStackService() {
    var repo = JsonRepo()..add(StackQuestionsSerializer());
    return StackService(route(StackService.baseUrl))
      ..jsonConverter = repo;
  }
}