import '../../core/error/failures.dart';
import '../entities/hobby.dart';
import '../repositories/hobby_repository.dart';

class CreateHobby {
  final HobbyRepository _repository;

  CreateHobby(this._repository);

  Future<void> call(Hobby hobby) async {
    if (hobby.name.trim().isEmpty) {
      throw const ValidationFailure('Hobby name cannot be empty');
    }
    await _repository.createHobby(hobby);
  }
}
