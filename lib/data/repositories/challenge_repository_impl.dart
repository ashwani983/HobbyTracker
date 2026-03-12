import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../datasources/database.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  ChallengeRepositoryImpl(this._db, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _col => _firestore.collection('challenges');

  @override
  Future<List<Challenge>> getActiveChallenges() async {
    final rows = await _db.getActiveChallenges();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<Challenge?> getById(String id) async {
    final row = await _db.getChallengeById(id);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Challenge?> getByInviteCode(String code) async {
    // Check local first
    final row = await _db.getChallengeByInviteCode(code);
    if (row != null) return _fromRow(row);
    // Check Firestore
    final snap = await _col.where('inviteCode', isEqualTo: code).limit(1).get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    final c = Challenge.fromFirestore(doc.id, doc.data()! as Map<String, dynamic>);
    await _saveLocal(c);
    return c;
  }

  @override
  Future<void> save(Challenge c) async {
    // Save to Firestore
    await _col.doc(c.id).set(c.toFirestore());
    // Save locally
    await _saveLocal(c);
  }

  @override
  Future<void> deactivate(String id) async {
    await _col.doc(id).update({'isActive': false});
    final existing = await _db.getChallengeById(id);
    if (existing != null) {
      await _db.updateChallenge(ChallengeTableCompanion.insert(
        id: id,
        name: existing.name,
        category: existing.category,
        targetMinutes: existing.targetMinutes,
        startDate: existing.startDate,
        endDate: existing.endDate,
        inviteCode: existing.inviteCode,
        participantLimit: existing.participantLimit,
        creatorUid: existing.creatorUid,
        isActive: const Value(false),
      ));
    }
  }

  @override
  Future<void> delete(String id) async {
    // Delete from Firestore first (so other devices see it)
    final participants = await _col.doc(id).collection('participants').get();
    for (final doc in participants.docs) {
      await doc.reference.delete();
    }
    await _col.doc(id).delete();
    // Then delete locally
    await _db.deleteChallenge(id);
  }

  @override
  Future<void> syncFromRemote() async {
    final local = await _db.getActiveChallenges();
    if (local.isEmpty) return;
    final snap = await _col.get(const GetOptions(source: Source.server));
    final remoteIds = snap.docs.map((d) => d.id).toSet();
    for (final row in local) {
      if (!remoteIds.contains(row.id)) {
        await _db.deleteChallenge(row.id);
      }
    }
  }

  @override
  Future<void> joinChallenge(String challengeId, String uid, String displayName) async {
    await _col.doc(challengeId).collection('participants').doc(uid).set({
      'displayName': displayName,
      'totalMinutes': 0,
    });
  }

  @override
  Future<void> leaveChallenge(String challengeId, String uid) async {
    await _col.doc(challengeId).collection('participants').doc(uid).delete();
  }

  @override
  Future<void> updateProgress(String challengeId, String uid, int totalMinutes) async {
    await _col.doc(challengeId).collection('participants').doc(uid).update({
      'totalMinutes': totalMinutes,
    });
  }

  @override
  Stream<List<LeaderboardEntry>> leaderboardStream(String challengeId) {
    return _col
        .doc(challengeId)
        .collection('participants')
        .orderBy('totalMinutes', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => LeaderboardEntry(
                  uid: d.id,
                  displayName: d.data()['displayName'] as String? ?? '',
                  totalMinutes: d.data()['totalMinutes'] as int? ?? 0,
                ))
            .toList());
  }

  Future<void> _saveLocal(Challenge c) async {
    await _db.insertChallenge(ChallengeTableCompanion.insert(
      id: c.id,
      name: c.name,
      category: c.category,
      targetMinutes: c.targetMinutes,
      startDate: c.startDate,
      endDate: c.endDate,
      inviteCode: c.inviteCode,
      participantLimit: c.participantLimit,
      creatorUid: c.creatorUid,
      isActive: Value(c.isActive),
    ), mode: InsertMode.insertOrReplace);
  }

  Challenge _fromRow(ChallengeTableData r) => Challenge(
        id: r.id,
        name: r.name,
        category: r.category,
        targetMinutes: r.targetMinutes,
        startDate: r.startDate,
        endDate: r.endDate,
        inviteCode: r.inviteCode,
        participantLimit: r.participantLimit,
        creatorUid: r.creatorUid,
        isActive: r.isActive,
      );
}
