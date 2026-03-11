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
  DateTimeColumn get updatedAt => dateTime().nullable()();
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
  TextColumn get photoPaths => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

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
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserBadgeTable extends Table {
  TextColumn get id => text()();
  TextColumn get badgeType => text()();
  TextColumn get hobbyId => text().nullable().references(HobbyTable, #id)();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReminderTable extends Table {
  TextColumn get id => text()();
  TextColumn get hobbyId => text().references(HobbyTable, #id)();
  TextColumn get time => text()();
  TextColumn get weekDays => text()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
    tables: [HobbyTable, SessionTable, GoalTable, UserBadgeTable, ReminderTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Add new columns to existing tables
            await m.addColumn(hobbyTable, hobbyTable.updatedAt);
            await m.addColumn(sessionTable, sessionTable.photoPaths);
            await m.addColumn(sessionTable, sessionTable.updatedAt);
            await m.addColumn(goalTable, goalTable.updatedAt);
            // Create new tables
            await m.createTable(userBadgeTable);
            await m.createTable(reminderTable);
          }
        },
      );

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
          .write(HobbyTableCompanion(
            isArchived: const Value(true),
            updatedAt: Value(DateTime.now()),
          ));

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

  Future<void> deleteSession(String id) =>
      (delete(sessionTable)..where((t) => t.id.equals(id))).go();

  // -- Goal queries --

  Future<List<GoalTableData>> getActiveGoals() =>
      (select(goalTable)..where((t) => t.isActive.equals(true))).get();

  Future<List<GoalTableData>> getGoalsByHobby(String hobbyId) =>
      (select(goalTable)..where((t) => t.hobbyId.equals(hobbyId))).get();

  Future<void> insertGoal(GoalTableCompanion goal) =>
      into(goalTable).insert(goal);

  Future<void> deactivateGoal(String id) =>
      (update(goalTable)..where((t) => t.id.equals(id)))
          .write(GoalTableCompanion(
            isActive: const Value(false),
            updatedAt: Value(DateTime.now()),
          ));

  Future<void> updateGoal(GoalTableCompanion goal, String id) =>
      (update(goalTable)..where((t) => t.id.equals(id))).write(goal);

  // -- Badge queries --

  Future<List<UserBadgeTableData>> getAllBadges() =>
      select(userBadgeTable).get();

  Future<void> insertBadge(UserBadgeTableCompanion badge) =>
      into(userBadgeTable).insert(badge);

  // -- Reminder queries --

  Future<List<ReminderTableData>> getRemindersByHobby(String hobbyId) =>
      (select(reminderTable)..where((t) => t.hobbyId.equals(hobbyId)))
          .get();

  Future<List<ReminderTableData>> getActiveReminders() =>
      (select(reminderTable)..where((t) => t.isActive.equals(true)))
          .get();

  Future<void> insertReminder(ReminderTableCompanion reminder) =>
      into(reminderTable).insert(reminder);

  Future<void> updateReminder(ReminderTableCompanion reminder) =>
      (update(reminderTable)
            ..where((t) => t.id.equals(reminder.id.value)))
          .write(reminder);

  Future<void> deleteReminder(String id) =>
      (delete(reminderTable)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hobby_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
