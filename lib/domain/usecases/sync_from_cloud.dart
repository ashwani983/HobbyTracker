import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/goal.dart';
import '../entities/goal_type.dart';
import '../entities/hobby.dart';
import '../entities/session.dart';
import '../repositories/goal_repository.dart';
import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';

class SyncFromCloud {
  final HobbyRepository _hobbyRepo;
  final SessionRepository _sessionRepo;
  final GoalRepository _goalRepo;

  SyncFromCloud(this._hobbyRepo, this._sessionRepo, this._goalRepo);

  Future<void> call(String userId) async {
    final db = FirebaseFirestore.instance;
    final root = db.collection('users').doc(userId);

    // Sync hobbies
    final hobbySnap = await root.collection('hobbies').get();
    for (final doc in hobbySnap.docs) {
      final d = doc.data();
      final hobby = Hobby(
        id: doc.id,
        name: d['name'] as String,
        description: d['description'] as String?,
        category: d['category'] as String,
        iconName: d['iconName'] as String,
        color: d['color'] as int,
        createdAt: DateTime.parse(d['createdAt'] as String),
        isArchived: d['isArchived'] as bool? ?? false,
      );
      final existing = await _hobbyRepo.getHobbyById(doc.id);
      if (existing == null) {
        await _hobbyRepo.createHobby(hobby);
      } else {
        await _hobbyRepo.updateHobby(hobby);
      }
    }

    // Sync sessions
    final sessionSnap = await root.collection('sessions').get();
    final localSessions = await _sessionRepo.getSessionsInRange(
      DateTime(2000),
      DateTime.now().add(const Duration(days: 1)),
    );
    final localIds = {for (final s in localSessions) s.id};
    for (final doc in sessionSnap.docs) {
      if (localIds.contains(doc.id)) continue;
      final d = doc.data();
      await _sessionRepo.createSession(Session(
        id: doc.id,
        hobbyId: d['hobbyId'] as String,
        date: DateTime.parse(d['date'] as String),
        durationMinutes: d['durationMinutes'] as int,
        notes: d['notes'] as String?,
        rating: d['rating'] as int?,
        createdAt: DateTime.parse(d['createdAt'] as String),
      ));
    }

    // Sync goals
    final goalSnap = await root.collection('goals').get();
    final localGoals = await _goalRepo.getActiveGoals();
    final localGoalIds = {for (final g in localGoals) g.id};
    for (final doc in goalSnap.docs) {
      if (localGoalIds.contains(doc.id)) continue;
      final d = doc.data();
      await _goalRepo.createGoal(Goal(
        id: doc.id,
        hobbyId: d['hobbyId'] as String,
        type: GoalType.values.byName(d['type'] as String),
        targetDurationMinutes: d['targetDurationMinutes'] as int,
        startDate: DateTime.parse(d['startDate'] as String),
        endDate: DateTime.parse(d['endDate'] as String),
        isActive: d['isActive'] as bool? ?? true,
      ));
    }
  }
}
