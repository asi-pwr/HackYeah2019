import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'item.dart';

part 'stack_questions.jser.dart';

@GenSerializer()
class StackQuestionsSerializer extends Serializer<StackQuestions> with _$StackQuestionsSerializer {
}

class StackQuestions {
  List<Item> items;
}