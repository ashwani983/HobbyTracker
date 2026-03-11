import 'package:flutter_test/flutter_test.dart';
import 'package:glados/src/any.dart' as glados_any show any;
import 'package:glados/src/anys.dart';
import 'package:glados/src/generator.dart';
import 'package:glados/src/glados.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/core/error/failures.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/domain/repositories/session_repository.dart';
import 'package:hobby_tracker/domain/usecases/log_session.dart';
import 'package:hobby_tracker/domain/usecases/get_sessions_by_hobby.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

final a = glados_any.any;

Session _makeSession({int duration = 30, int? rating}) => Session(
      id: 'test-id',
      hobbyId: 'hobby-1',
      date: DateTime(2024),
      durationMinutes: duration,
      rating: rating,
      createdAt: DateTime(2024),
    );

void main() {
  late MockSessionRepository repo;
  late LogSession logSession;
  late GetSessionsByHobby getSessionsByHobby;

  setUp(() {
    repo = MockSessionRepository();
    logSession = LogSession(repo);
    getSessionsByHobby = GetSessionsByHobby(repo);
    registerFallbackValue(_makeSession());
  });

  // Feature: flutter-hobby-tracker, Property 4: Session persistence round-trip
  Glados(a.intInRange(1, 1000)).test(
    'Property 4: valid session with positive duration is accepted',
    (duration) async {
      when(() => repo.createSession(any())).thenAnswer((_) async {});
      final session = _makeSession(duration: duration);
      await logSession(session);
      verify(() => repo.createSession(session)).called(1);
    },
  );

  // Feature: flutter-hobby-tracker, Property 5: Non-positive session duration rejection
  Glados(a.intInRange(-100, 0)).test(
    'Property 5: non-positive duration is rejected',
    (duration) async {
      final session = _makeSession(duration: duration);
      expect(() => logSession(session), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.createSession(any()));
    },
  );

  // Feature: flutter-hobby-tracker, Property 6: Session rating out-of-range rejection
  Glados(a.intInRange(-10, 0)).test(
    'Property 6: rating below 1 is rejected',
    (rating) async {
      final session = _makeSession(duration: 30, rating: rating);
      expect(() => logSession(session), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.createSession(any()));
    },
  );

  Glados(a.intInRange(6, 20)).test(
    'Property 6: rating above 5 is rejected',
    (rating) async {
      final session = _makeSession(duration: 30, rating: rating);
      expect(() => logSession(session), throwsA(isA<ValidationFailure>()));
      verifyNever(() => repo.createSession(any()));
    },
  );

  // Feature: flutter-hobby-tracker, Property 7: Sessions sorted by date descending
  Glados(a.intInRange(2, 10)).test(
    'Property 7: sessions returned sorted by date descending',
    (count) async {
      final sessions = List.generate(
        count,
        (i) => Session(
          id: 'id-$i',
          hobbyId: 'hobby-1',
          date: DateTime(2024, 1, count - i),
          durationMinutes: 30,
          createdAt: DateTime(2024),
        ),
      );
      when(() => repo.getSessionsByHobby('hobby-1'))
          .thenAnswer((_) async => sessions);

      final result = await getSessionsByHobby('hobby-1');
      for (var i = 0; i < result.length - 1; i++) {
        expect(
          result[i].date.isAfter(result[i + 1].date) ||
              result[i].date.isAtSameMomentAs(result[i + 1].date),
          isTrue,
        );
      }
    },
  );
}
