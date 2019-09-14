// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_questions.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$StackQuestionsSerializer
    implements Serializer<StackQuestions> {
  Serializer<Item> __itemSerializer;
  Serializer<Item> get _itemSerializer => __itemSerializer ??= ItemSerializer();
  @override
  Map<String, dynamic> toMap(StackQuestions model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'items',
        codeIterable(model.items, (val) => _itemSerializer.toMap(val as Item)));
    return ret;
  }

  @override
  StackQuestions fromMap(Map map) {
    if (map == null) return null;
    final obj = StackQuestions();
    obj.items = codeIterable<Item>(
        map['items'] as Iterable, (val) => _itemSerializer.fromMap(val as Map));
    return obj;
  }
}
