import 'package:flutter/foundation.dart';
import 'package:tag_data_manager_client/utils/utils.dart';

mixin AuthenticationRepository {
  Future<Result<String>> login({
    @required String username,
    @required String password,
  });
}
