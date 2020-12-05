part of services;

class TagService with TagRepository {
  const TagService({
    @required this.dioClient,
  });

  final AppDioClient dioClient;

  static const pathPrefix = '/api/v1/tags';

  @override
  Future<Result<Tag>> registerTag({Tag tag}) async {
    return ApiClient().sendRequest(
      request: dioClient.post(
        '$pathPrefix',
        data: tag.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      ),
      jsonDecodeCallback: (json) => Tag.fromJson(json),
    );
  }

  @override
  // ignore: missing_return
  Future<Result<List<Tag>>> registerTags({List<Tag> tags}) {
//    return ApiClient().sendRequest(
//      request: dioClient.post(
//        '$pathPrefix',
//        data: tags.map((e) => e.toJson()).toList(),
//        options: Options(contentType: Headers.jsonContentType),
//      ),
//      jsonDecodeCallback: (jsonArray) => jsonArray.map((key, value) => null),
//    );
  }

  @override
  Future<Result<Tag>> updateTag({Tag tag}) {
    return ApiClient().sendRequest(
      request: dioClient.put(
        '$pathPrefix',
        data: tag.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      ),
      jsonDecodeCallback: (json) => Tag.fromJson(json),
    );
  }
}
