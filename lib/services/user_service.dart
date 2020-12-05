part of services;

class UserService with AuthenticationRepository, UserRepository {
  const UserService({
    @required this.dioClient,
  });

  final AppDioClient dioClient;

  static const pathPrefix = '/api/v1/users';

  @override
  Future<Result<String>> login({
    @required String username,
    @required String password,
  }) async {
    try {
      final response = await dioClient.post(
        '/login',
        data: {
          'name': username,
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final token = response.headers.map['authorization'][0];
      dioClient.options.headers['Authorization'] = token;

      return Result.success(token);
    } on Exception {
      return const Result.failure(NetworkExceptions.badRequest());
    }
  }

  @override
  Future<Result<User>> registerUser({
    @required User user,
    @required String password,
  }) {
    final json = user.toJson()
      ..putIfAbsent('password', () => password)
      ..remove('createdAt')
      ..remove('updatedAt');
    return ApiClient().sendRequest(
      request: dioClient.post(
        '$pathPrefix/signUp',
        data: json,
        options: Options(contentType: Headers.jsonContentType),
      ),
      jsonDecodeCallback: (json) => User.fromJson(json),
    );
  }

  @override
  Future<Result<User>> findUserByName({@required String name}) {
//    final
    return ApiClient().sendRequest(
      request: dioClient.get('$pathPrefix/$name'),
      jsonDecodeCallback: (json) => User.fromJson(json),
    );
  }
}
