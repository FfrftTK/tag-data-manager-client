part of repositories;

mixin AuthenticationRepository {
  Future<Result<String>> login({
    @required String username,
    @required String password,
  });
}
