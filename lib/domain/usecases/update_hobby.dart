import '../../core/error/failures.dart';
import '../entities/hobby.dart';
import '../repositories/hobby_repository.dart';

class UpdateHobby {
  final HobbyRepository _repository;

  UpdateHobby(this._repository);

  Future<void> call(Hobby hobby) async {
    if (hobby.name.trim().isEmpty) {
      throw const ValidationFailure('Hobby name cannot be empty');
    }
    await _repository.updateHobby(hobby);
  }
}
