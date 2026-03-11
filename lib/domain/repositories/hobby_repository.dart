import '../entities/hobby.dart';

abstract class HobbyRepository {
  Future<List<Hobby>> getActiveHobbies();
  Future<Hobby?> getHobbyById(String id);
  Future<void> createHobby(Hobby hobby);
  Future<void> updateHobby(Hobby hobby);
  Future<void> archiveHobby(String id);
}
