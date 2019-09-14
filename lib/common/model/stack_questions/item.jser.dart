// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ItemSerializer implements Serializer<Item> {
  Serializer<Owner> __ownerSerializer;
  Serializer<Owner> get _ownerSerializer =>
      __ownerSerializer ??= OwnerSerializer();
  @override
  Map<String, dynamic> toMap(Item model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'question_id', model.id);
    setMapValue(ret, 'owner', _ownerSerializer.toMap(model.owner));
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'link', model.link);
    setMapValue(ret, 'question_id', model.questionId);
    setMapValue(ret, 'view_count', model.viewCount);
    setMapValue(ret, 'score', model.score);
    setMapValue(ret, 'tags', codeIterable(model.tags, (val) => val as String));
    setMapValue(ret, 'creation_date', model.creationDate);
    return ret;
  }

  @override
  Item fromMap(Map map) {
    if (map == null) return null;
    final obj = Item();
    obj.id = map['question_id'] as int;
    obj.owner = _ownerSerializer.fromMap(map['owner'] as Map);
    obj.title = map['title'] as String;
    obj.link = map['link'] as String;
    obj.questionId = map['question_id'] as int;
    obj.viewCount = map['view_count'] as int;
    obj.score = map['score'] as int;
    obj.tags =
        codeIterable<String>(map['tags'] as Iterable, (val) => val as String);
    obj.creationDate = map['creation_date'] as int;
    return obj;
  }
}
