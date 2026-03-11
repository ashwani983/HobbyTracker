import 'package:drift/drift.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../datasources/database.dart';

class HobbyRepositoryImpl implements HobbyRepository {
  final AppDatabase _db;

  HobbyRepositoryImpl(this._db);

  @override
  Future<List<Hobby>> getActiveHobbies() async {
    try {
      final rows = await _db.getActiveHobbies();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<Hobby?> getHobbyById(String id) async {
    try {
      final row = await _db.getHobbyById(id);
      return row == null ? null : _toEntity(row);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> createHobby(Hobby hobby) async {
    try {
      await _db.insertHobby(_toCompanion(hobby));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> updateHobby(Hobby hobby) async {
    try {
      await _db.updateHobbyRow(_toCompanion(hobby));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> archiveHobby(String id) async {
    try {
      await _db.archiveHobby(id);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Hobby _toEntity(HobbyTableData row) => Hobby(
        id: row.id,
        name: row.name,
        description: row.description,
        category: row.category,
        iconName: row.iconName,
        color: row.color,
        createdAt: row.createdAt,
        isArchived: row.isArchived,
      );

  HobbyTableCompanion _toCompanion(Hobby h) => HobbyTableCompanion(
        id: Value(h.id),
        name: Value(h.name),
        description: Value(h.description),
        category: Value(h.category),
        iconName: Value(h.iconName),
        color: Value(h.color),
        createdAt: Value(h.createdAt),
        isArchived: Value(h.isArchived),
      );
}
