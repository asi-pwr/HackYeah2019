import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'owner.dart';

part 'item.jser.dart';

@GenSerializer()
class ItemSerializer extends Serializer<Item> with _$ItemSerializer {
}

class Item {
  @Alias("question_id")
  int id;
  Owner owner;
  String title;
  String link;
  @Alias("question_id")
  int questionId;
  @Alias("view_count")
  int viewCount;
  int score;
  List<String> tags;
  @Alias("creation_date")
  int creationDate;
}