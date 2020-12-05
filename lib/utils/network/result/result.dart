import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tag_data_manager_client/utils/network/error/network_exceptions.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(NetworkExceptions error) = Failure<T>;
}
