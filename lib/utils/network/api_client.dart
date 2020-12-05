import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tag_data_manager_client/utils/utils.dart';

class ApiClient {
  factory ApiClient() {
    // ignore: join_return_with_assignment
    _instance ??= ApiClient._();

    return _instance;
  }
  ApiClient._();

  static ApiClient _instance;

  Future<Result<T>> sendRequest<T>({
    @required Future<Response<Map<String, dynamic>>> request,
    @required T Function(Map<String, dynamic>) jsonDecodeCallback,
  }) async {
    try {
      return await request
          .then((value) => Result.success(jsonDecodeCallback(value.data)));
    } on Exception {
      return const Result.failure(NetworkExceptions.badRequest());
    }
  }
}
