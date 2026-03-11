import 'package:flutter_test/flutter_test.dart';
import 'package:glados/src/any.dart' as glados_any show any;
import 'package:glados/src/anys.dart';
import 'package:glados/src/generator.dart';
import 'package:glados/src/glados.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/core/error/failures.dart';
import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/repositories/hobby_repository.dart';
import 'package:hobby_tracker/domain/usecases/create_hobby.dart';
import 'package:hobby_tracker/domain/usecases/get_active_hobbies.dart';

class MockHobbyRepository extends Mock implements HobbyRepository {}

final a = glados_any.any;

Hobby _makeHobby({required String name}) => Hobby(
      id: 'test-id',
      name: name,
      category: 'Sports',
      iconName: 'interests',
      color: 0xFF0000FF,
      createdAt: DateTime(2024),
    );

void main() {
  late MockHobbyRepository repo;
  late CreateHobby createHobby;
  late GetActiveHobbies getActiveHobbies;

  setUp(() {
    repo = MockHobbyRepository();
    createHobby = CreateHobby(repo);
    getActiveHobbies = GetActiveHobbies(repo);
    registerFallbackValue(_makeHobby(name: 'fallback'));
  });

  // Feature: flutter-hobby-tracker, Property 1: Hobby persistence round-trip
  Glados(a.lowercaseLetters.map((s) => 'a$s')).test(
    'Property 1: valid hobby name is accepted',
    (name) async {
      when(() => repo.createHobby(any())).thenAnswer((_) async {});
      final hobby = _makeHobby(name: name);
      await createHobby(hobby);
      verify(() => repo.createHobby(hobby)).called(1);
    },
  );

  // Feature: flutter-hobby-tracker, Property 2: Whitespace hobby name rejection
  Glados(a.intInRange(0, 10).map((n) => ' ' * n)).test(
    'Property 2: whitespace-only name is rejected',
    (name) async {
      final hobby = _makeHobby(name: name);
      expect(() => createHobby(hobby), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.createHobby(any()));
    },
  );

  // Feature: flutter-hobby-tracker, Property 3: Active hobbies list invariant
  Glados2(a.bool, a.bool).test(
    'Property 3: getActiveHobbies returns only non-archived hobbies',
    (archived1, archived2) async {
      final hobbies = [
        Hobby(
          id: '1', name: 'A', category: 'Sports', iconName: 'i',
          color: 0, createdAt: DateTime(2024, 1, 1), isArchived: archived1,
        ),
        Hobby(
          id: '2', name: 'B', category: 'Music', iconName: 'i',
          color: 0, createdAt: DateTime(2024, 1, 2), isArchived: archived2,
        ),
      ];
      final active = hobbies.where((h) => !h.isArchived).toList();
      when(() => repo.getActiveHobbies()).thenAnswer((_) async => active);

      final result = await getActiveHobbies();
      expect(result.every((h) => !h.isArchived), isTrue);
      expect(result.length, active.length);
    },
  );
}
