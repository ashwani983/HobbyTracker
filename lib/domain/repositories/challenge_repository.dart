import '../entities/challenge.dart';

abstract class ChallengeRepository {
  Future<List<Challenge>> getActiveChallenges();
  Future<Challenge?> getById(String id);
  Future<Challenge?> getByInviteCode(String code);
  Future<void> save(Challenge challenge);
  Future<void> deactivate(String id);
  Future<void> delete(String id);
  Future<void> syncFromRemote();
  Future<void> joinChallenge(String challengeId, String uid, String displayName);
  Future<void> leaveChallenge(String challengeId, String uid);
  Future<void> updateProgress(String challengeId, String uid, int totalMinutes);
  Stream<List<LeaderboardEntry>> leaderboardStream(String challengeId);
}
