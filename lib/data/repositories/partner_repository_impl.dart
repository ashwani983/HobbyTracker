import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/partner.dart';
import '../../domain/repositories/partner_repository.dart';
import '../datasources/database.dart';

class PartnerRepositoryImpl implements PartnerRepository {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  PartnerRepositoryImpl(this._db, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _requests => _firestore.collection('partner_requests');

  DocumentReference _userDoc(String uid) => _firestore.collection('users').doc(uid);

  @override
  Future<List<Partner>> getActivePartners() async {
    final rows = await _db.getActivePartners();
    return rows
        .map((r) => Partner(
              id: r.id,
              partnerUid: r.partnerUid,
              partnerDisplayName: r.partnerDisplayName,
              linkedAt: r.linkedAt,
              isActive: r.isActive,
            ))
        .toList();
  }

  @override
  Future<String> sendRequest(String myUid, String myDisplayName) async {
    final code = _generateCode();
    await _requests.doc(code).set({
      'fromUid': myUid,
      'fromDisplayName': myDisplayName,
      'expiresAt': DateTime.now().add(const Duration(hours: 48)).toIso8601String(),
    });
    return code;
  }

  @override
  Future<void> acceptRequest(String inviteCode, String myUid, String myDisplayName) async {
    final doc = await _requests.doc(inviteCode).get();
    if (!doc.exists) throw Exception('Invalid invite code');
    final data = doc.data()! as Map<String, dynamic>;
    final expires = DateTime.parse(data['expiresAt'] as String);
    if (DateTime.now().isAfter(expires)) throw Exception('Invite code expired');

    final fromUid = data['fromUid'] as String;
    final fromName = data['fromDisplayName'] as String;
    if (fromUid == myUid) throw Exception('Cannot partner with yourself');

    // Check 5-partner limit for both users
    final myPartners = await _userDoc(myUid).collection('partners').get();
    if (myPartners.docs.length >= 5) throw Exception('You have reached the 5-partner limit');
    final theirPartners = await _userDoc(fromUid).collection('partners').get();
    if (theirPartners.docs.length >= 5) throw Exception('Partner has reached the 5-partner limit');

    // Create bidirectional link
    final now = DateTime.now().toIso8601String();
    await _userDoc(myUid).collection('partners').doc(fromUid).set({
      'partnerUid': fromUid,
      'partnerDisplayName': fromName,
      'linkedAt': now,
      'isActive': true,
    });
    await _userDoc(fromUid).collection('partners').doc(myUid).set({
      'partnerUid': myUid,
      'partnerDisplayName': myDisplayName,
      'linkedAt': now,
      'isActive': true,
    });

    // Save locally
    await _saveLocal(Partner(
      id: fromUid,
      partnerUid: fromUid,
      partnerDisplayName: fromName,
      linkedAt: DateTime.now(),
    ));

    // Delete the request
    await _requests.doc(inviteCode).delete();
  }

  @override
  Future<PartnerStats> getPartnerStats(String partnerUid) async {
    final doc = await _userDoc(partnerUid).collection('shared_stats').doc('current').get();
    if (!doc.exists) {
      return PartnerStats(partnerUid: partnerUid, displayName: '');
    }
    final data = doc.data()!;
    return PartnerStats(
      partnerUid: partnerUid,
      displayName: data['displayName'] as String? ?? '',
      currentStreak: data['currentStreak'] as int? ?? 0,
      weeklyMinutes: data['weeklyMinutes'] as int? ?? 0,
      goalCompletionPercent: data['goalCompletionPercent'] as int? ?? 0,
    );
  }

  @override
  Future<void> removePartner(String id, String myUid) async {
    // Remove locally
    await _db.deletePartner(id);
    // Remove bidirectional Firestore link
    try {
      await _userDoc(myUid).collection('partners').doc(id).delete();
      await _userDoc(id).collection('partners').doc(myUid).delete();
    } catch (_) {}
  }

  @override
  Future<void> syncFromRemote(String myUid) async {
    final snap = await _userDoc(myUid)
        .collection('partners')
        .get(const GetOptions(source: Source.server));
    final remoteIds = <String>{};
    for (final doc in snap.docs) {
      remoteIds.add(doc.id);
      final p = Partner.fromFirestore(doc.id, doc.data());
      await _saveLocal(p);
    }
    // Remove local partners not in remote
    final local = await _db.getActivePartners();
    for (final row in local) {
      if (!remoteIds.contains(row.id)) {
        await _db.deletePartner(row.id);
      }
    }
  }

  Future<void> _saveLocal(Partner p) async {
    await _db.insertPartner(
      PartnerTableCompanion.insert(
        id: p.id,
        partnerUid: p.partnerUid,
        partnerDisplayName: p.partnerDisplayName,
        linkedAt: p.linkedAt,
        isActive: Value(p.isActive),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<void> publishMyStats(String myUid, String displayName, int streak, int weeklyMinutes, int goalPercent) async {
    await _userDoc(myUid).collection('shared_stats').doc('current').set({
      'displayName': displayName,
      'currentStreak': streak,
      'weeklyMinutes': weeklyMinutes,
      'goalCompletionPercent': goalPercent,
    });
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
