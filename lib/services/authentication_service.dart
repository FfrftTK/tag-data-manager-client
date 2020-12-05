import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tag_data_manager_client/repositories/authentication_repository.dart';
import 'package:tag_data_manager_client/utils/utils.dart';

class AuthenticationService with AuthenticationRepository {
  const AuthenticationService({
    @required this.dioClient,
  });

  final AppDioClient dioClient;

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
          'passwordRaw': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final token = response.headers.map['authorization'][0];
      dioClient.options.headers['Authorization'] = token;

      return Result.success(token);
    } on Exception catch (e) {
      return const Result.failure(NetworkExceptions.badRequest());
    }
  }
}
