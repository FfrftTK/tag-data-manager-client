part of repositories;

mixin UserRepository {
  Future<Result<User>> registerUser({
    @required User user,
    @required String password,
  });

  Future<Result<User>> findUserByName({@required String name});
}
