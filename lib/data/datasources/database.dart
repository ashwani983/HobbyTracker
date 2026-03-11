import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class HobbyTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get iconName => text()();
  IntColumn get color => integer()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SessionTable extends Table {
  TextColumn get id => text()();
  TextColumn get hobbyId => text().references(HobbyTable, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get durationMinutes => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get rating => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class GoalTable extends Table {
  TextColumn get id => text()();
  TextColumn get hobbyId => text().references(HobbyTable, #id)();
  TextColumn get type => text()();
  IntColumn get targetDurationMinutes => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [HobbyTable, SessionTable, GoalTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // -- Hobby queries --

  Future<List<HobbyTableData>> getActiveHobbies() =>
      (select(hobbyTable)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<HobbyTableData?> getHobbyById(String id) =>
      (select(hobbyTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> insertHobby(HobbyTableCompanion hobby) =>
      into(hobbyTable).insert(hobby);

  Future<void> updateHobbyRow(HobbyTableCompanion hobby) =>
      (update(hobbyTable)..where((t) => t.id.equals(hobby.id.value)))
          .write(hobby);

  Future<void> archiveHobby(String id) =>
      (update(hobbyTable)..where((t) => t.id.equals(id)))
          .write(const HobbyTableCompanion(isArchived: Value(true)));

  // -- Session queries --

  Future<List<SessionTableData>> getSessionsByHobby(String hobbyId) =>
      (select(sessionTable)
            ..where((t) => t.hobbyId.equals(hobbyId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<SessionTableData>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(sessionTable)
            ..where((t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(end)))
          .get();

  Future<List<SessionTableData>> getRecentSessions(int limit) =>
      (select(sessionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(limit))
          .get();

  Future<int> getTotalDurationForHobbyInRange(
    String hobbyId,
    DateTime start,
    DateTime end,
  ) async {
    final query = selectOnly(sessionTable)
      ..addColumns([sessionTable.durationMinutes.sum()])
      ..where(sessionTable.hobbyId.equals(hobbyId) &
          sessionTable.date.isBiggerOrEqualValue(start) &
          sessionTable.date.isSmallerOrEqualValue(end));
    final result = await query.getSingle();
    return result.read(sessionTable.durationMinutes.sum()) ?? 0;
  }

  Future<void> insertSession(SessionTableCompanion session) =>
      into(sessionTable).insert(session);

  // -- Goal queries --

  Future<List<GoalTableData>> getActiveGoals() =>
      (select(goalTable)..where((t) => t.isActive.equals(true))).get();

  Future<List<GoalTableData>> getGoalsByHobby(String hobbyId) =>
      (select(goalTable)..where((t) => t.hobbyId.equals(hobbyId))).get();

  Future<void> insertGoal(GoalTableCompanion goal) =>
      into(goalTable).insert(goal);

  Future<void> deactivateGoal(String id) =>
      (update(goalTable)..where((t) => t.id.equals(id)))
          .write(const GoalTableCompanion(isActive: Value(false)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hobby_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
