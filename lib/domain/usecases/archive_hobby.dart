import '../repositories/hobby_repository.dart';

class ArchiveHobby {
  final HobbyRepository _repository;

  ArchiveHobby(this._repository);

  Future<void> call(String id) async {
    await _repository.archiveHobby(id);
  }
}
