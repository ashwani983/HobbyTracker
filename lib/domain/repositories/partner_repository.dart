import '../entities/partner.dart';

abstract class PartnerRepository {
  Future<List<Partner>> getActivePartners();
  Future<String> sendRequest(String myUid, String myDisplayName);
  Future<void> acceptRequest(String inviteCode, String myUid, String myDisplayName);
  Future<PartnerStats> getPartnerStats(String partnerUid);
  Future<void> removePartner(String id, String myUid);
  Future<void> syncFromRemote(String myUid);
  Future<void> publishMyStats(String myUid, String displayName, int streak, int weeklyMinutes, int goalPercent);
}
