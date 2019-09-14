import 'package:flutter1/common/model/stack_questions/stack_questions.dart';
import 'package:flutter1/common/repository/repository_request_status.dart';
import 'package:flutter1/common/rx/rx_response.dart';
import 'package:flutter1/common/rx/rx_response_builder.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';
import 'package:flutter1/common/repository/stack_questions_repository.dart';

class StackQuestionsBloc extends BaseBloc {

  final StackQuestionsRepository _stackQuestionsRepository;
  final _questionSubject = BehaviorSubject<RxResponse<StackQuestions>>();

  Observable<RxResponse<StackQuestions>> get questionStream => _questionSubject.stream;

  String lastSearch() => _stackQuestionsRepository.lastSearch;

  StackQuestionsBloc(this._stackQuestionsRepository) {
    compositeSubscription.add(
        _stackQuestionsRepository.questionsListStatusSubject.stream.listen(
        _handleNewStackQuestionStatus,
        onError: (e) => _questionSubject.sink.add(
            RxResponseBuilder<StackQuestions>().error(e))));
  }

  void _handleNewStackQuestionStatus(RepositoryRequestStatus status){
    switch(status){
      case RepositoryRequestStatus.IDLE:
        break;
      case RepositoryRequestStatus.PENDING:
        _questionSubject.sink.add(RxResponseBuilder<StackQuestions>().pending());
        break;
      case RepositoryRequestStatus.OK:
        _questionSubject.sink.add(RxResponseBuilder<StackQuestions>().success(
            _stackQuestionsRepository.lastStackQuestions));
        break;
      case RepositoryRequestStatus.ERROR:
        _questionSubject.sink.add(RxResponseBuilder<StackQuestions>().error(
            new Exception("Error msg")));
        break;
    }
  }

  void requestStackQuestions({String search, bool forceUpdate = false}){
    if(!forceUpdate && _stackQuestionsRepository.lastStackQuestions != null){
      _questionSubject.sink.add(RxResponseBuilder<StackQuestions>().success(
          _stackQuestionsRepository.lastStackQuestions));
    }
    else {
      _stackQuestionsRepository.getStackQuestionsList(search
          ?? _stackQuestionsRepository.lastSearch
          ?? "Flutter");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _questionSubject.close();
  }
}