part of repositories;

mixin TagRepository {
  Future<Result<Tag>> registerTag({@required Tag tag});

  Future<Result<List<Tag>>> registerTags({@required List<Tag> tags});

  Future<Result<Tag>> updateTag({@required Tag tag});
}
