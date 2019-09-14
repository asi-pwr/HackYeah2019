// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_service.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$StackServiceClient implements ApiClient {
  final String basePath = "";
  Future<StackQuestions> getStackQuestions(
      String order, String sort, String site, String tagged) async {
    var req = base.get
        .path(basePath)
        .path("/questions")
        .query("order", order)
        .query("sort", sort)
        .query("site", site)
        .query("tagged", tagged);
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
