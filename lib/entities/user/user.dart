import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tag_data_manager_client/entities/tag/tag.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @required String name,
    @Default('') String description,
    String createdAt,
    String updatedAt,
    @Default([]) List<Tag> tags,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
