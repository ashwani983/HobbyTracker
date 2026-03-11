import '../entities/hobby.dart';
import '../repositories/hobby_repository.dart';

class GetActiveHobbies {
  final HobbyRepository _repository;

  GetActiveHobbies(this._repository);

  Future<List<Hobby>> call() async {
    return _repository.getActiveHobbies();
  }
}
