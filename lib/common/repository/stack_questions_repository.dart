import 'package:rxdart/subjects.dart';
import 'package:inject/inject.dart';

import 'package:flutter1/common/network/service/stack_service.dart';
import 'repository_request_status.dart';
import 'package:flutter1/common/model/stack_questions/stack_questions.dart';

class StackQuestionsRepository {

  final StackService stackService;
  final questionsListStatusSubject = PublishSubject<RepositoryRequestStatus>();

  StackQuestions lastStackQuestions;
  String lastSearch;

  @provide
  StackQuestionsRepository(this.stackService);

  void getStackQuestionsList(String search) {
    questionsListStatusSubject.sink.add(RepositoryRequestStatus.PENDING);

    lastSearch = search;

    stackService.getStackQuestions("desc", "activity", "stackoverflow", search)
        .then((value) {
              lastStackQuestions = value;
              questionsListStatusSubject.sink.add(RepositoryRequestStatus.OK);
            }, onError: (e) =>
        questionsListStatusSubject.sink.add(RepositoryRequestStatus.ERROR));
  }

  void dispose() {
    questionsListStatusSubject.close();
  }
}
