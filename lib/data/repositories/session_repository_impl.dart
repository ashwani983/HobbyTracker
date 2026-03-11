import 'package:drift/drift.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/database.dart';

class SessionRepositoryImpl implements SessionRepository {
  final AppDatabase _db;

  SessionRepositoryImpl(this._db);

  @override
  Future<List<Session>> getSessionsByHobby(String hobbyId) async {
    try {
      final rows = await _db.getSessionsByHobby(hobbyId);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<Session>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final rows = await _db.getSessionsInRange(start, end);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<Session>> getRecentSessions(int limit) async {
    try {
      final rows = await _db.getRecentSessions(limit);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<int> getTotalDurationForHobbyInRange(
    String hobbyId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      return _db.getTotalDurationForHobbyInRange(hobbyId, start, end);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> createSession(Session session) async {
    try {
      await _db.insertSession(_toCompanion(session));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Session _toEntity(SessionTableData row) => Session(
        id: row.id,
        hobbyId: row.hobbyId,
        date: row.date,
        durationMinutes: row.durationMinutes,
        notes: row.notes,
        rating: row.rating,
        createdAt: row.createdAt,
      );

  SessionTableCompanion _toCompanion(Session s) => SessionTableCompanion(
        id: Value(s.id),
        hobbyId: Value(s.hobbyId),
        date: Value(s.date),
        durationMinutes: Value(s.durationMinutes),
        notes: Value(s.notes),
        rating: Value(s.rating),
        createdAt: Value(s.createdAt),
      );
}
