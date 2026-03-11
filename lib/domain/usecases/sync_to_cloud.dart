import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/goal_repository.dart';

class SyncToCloud {
  final HobbyRepository _hobbyRepo;
  final SessionRepository _sessionRepo;
  final GoalRepository _goalRepo;

  SyncToCloud(this._hobbyRepo, this._sessionRepo, this._goalRepo);

  Future<void> call(String userId) async {
    final db = FirebaseFirestore.instance;
    final root = db.collection('users').doc(userId);

    final hobbies = await _hobbyRepo.getActiveHobbies();
    for (final h in hobbies) {
      await root.collection('hobbies').doc(h.id).set({
        'name': h.name,
        'description': h.description,
        'category': h.category,
        'iconName': h.iconName,
        'color': h.color,
        'createdAt': h.createdAt.toIso8601String(),
        'isArchived': h.isArchived,
      }, SetOptions(merge: true));
    }

    final now = DateTime.now();
    final sessions = await _sessionRepo.getSessionsInRange(
      DateTime(2000),
      now.add(const Duration(days: 1)),
    );
    for (final s in sessions) {
      await root.collection('sessions').doc(s.id).set({
        'hobbyId': s.hobbyId,
        'date': s.date.toIso8601String(),
        'durationMinutes': s.durationMinutes,
        'notes': s.notes,
        'rating': s.rating,
        'createdAt': s.createdAt.toIso8601String(),
      }, SetOptions(merge: true));
    }

    final goals = await _goalRepo.getActiveGoals();
    for (final g in goals) {
      await root.collection('goals').doc(g.id).set({
        'hobbyId': g.hobbyId,
        'type': g.type.name,
        'targetDurationMinutes': g.targetDurationMinutes,
        'startDate': g.startDate.toIso8601String(),
        'endDate': g.endDate.toIso8601String(),
        'isActive': g.isActive,
      }, SetOptions(merge: true));
    }
  }
}
