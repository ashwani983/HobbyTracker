// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '趣味トラッカー';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get hobbies => '趣味';

  @override
  String get timer => 'タイマー';

  @override
  String get goals => '目標';

  @override
  String get stats => '統計';

  @override
  String get settings => '設定';

  @override
  String get activeHobbies => 'アクティブな趣味';

  @override
  String get thisWeek => '今週';

  @override
  String get dayStreak => '連続日数';

  @override
  String get noDataYet => 'データがありません。趣味を追加して始めましょう！';

  @override
  String get noHobbiesYet => '趣味がありません。追加しましょう！';

  @override
  String get noGoalsYet => '目標がありません。設定しましょう！';

  @override
  String get noSessionsYet => 'セッションがありません。';

  @override
  String get noSessionsLogged => '記録されたセッションがありません。';

  @override
  String get noDataForPeriod => 'この期間のデータがありません。';

  @override
  String get addHobbyFirst => 'まず趣味を追加してください。';

  @override
  String get addHobbyFirstTimer => 'タイマーを使うには、まず趣味を追加してください。';

  @override
  String get addHobby => '趣味を追加';

  @override
  String get editHobby => '趣味を編集';

  @override
  String get hobbyDetail => '趣味の詳細';

  @override
  String get addGoal => '目標を追加';

  @override
  String get createGoal => '目標を作成';

  @override
  String get logSession => 'セッションを記録';

  @override
  String get saveSession => 'セッションを保存';

  @override
  String get saveSessionQuestion => 'セッションを保存しますか？';

  @override
  String get create => '作成';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get skip => 'スキップ';

  @override
  String get start => '開始';

  @override
  String get stop => '停止';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get reset => 'リセット';

  @override
  String get discard => '破棄';

  @override
  String get later => '後で';

  @override
  String get update => '更新';

  @override
  String get about => 'アプリについて';

  @override
  String get color => '色';

  @override
  String get date => '日付';

  @override
  String get startDate => '開始日';

  @override
  String get endDate => '終了日';

  @override
  String get endDateError => '終了日は開始日より後にしてください';

  @override
  String get ratingOptional => '評価（任意）';

  @override
  String get sessions => 'セッション';

  @override
  String get reminders => 'リマインダー';

  @override
  String get noRemindersSet => 'リマインダーがありません。+をタップして追加。';

  @override
  String get selectDays => '曜日を選択';

  @override
  String get camera => 'カメラ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String photosCount(int count) {
    return '写真 ($count/5)';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String durationHoursMinutes(int hours, int mins) {
    return '$hours時間$mins分';
  }

  @override
  String ratingStars(int rating) {
    return '⭐ $rating';
  }

  @override
  String streakDays(int days) {
    return '🔥 $days';
  }

  @override
  String dayStreakCount(int days) {
    return '$days日連続';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return '$minutes分のセッションを保存しますか？';
  }

  @override
  String get sessionSaved => 'セッションを保存しました！';

  @override
  String get sessionTooShort => 'セッションが短すぎます。';

  @override
  String get notificationPermissionDenied => '通知の許可が拒否されました';

  @override
  String exportFailed(String error) {
    return 'エクスポート失敗: $error';
  }

  @override
  String get timePerHobby => '趣味ごとの時間';

  @override
  String get distribution => '分布';

  @override
  String get dailyActivity => '日々の活動';

  @override
  String get theme => 'テーマ';

  @override
  String get badges => 'バッジ';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get exportCsv => 'CSVエクスポート';

  @override
  String get exportPdf => 'PDFエクスポート';

  @override
  String get csvOrPdf => 'CSVまたはPDF';

  @override
  String get cloudSync => 'クラウド同期';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncing => '同期中...';

  @override
  String get syncComplete => '✓ 同期完了';

  @override
  String get autoSync => '自動同期';

  @override
  String get signInWithGoogle => 'Googleでサインイン';

  @override
  String get signInToSync => '同期するにはサインインしてください';

  @override
  String get signInAndSync => 'サインインしてデータを同期';

  @override
  String get signOut => 'サインアウト';

  @override
  String get user => 'ユーザー';

  @override
  String get termsAndConditions => '利用規約';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get checking => '確認中...';

  @override
  String updateAvailable(String version) {
    return 'アップデート $version が利用可能';
  }

  @override
  String versionAvailable(String version) {
    return '$version が利用可能';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '$emoji バッジ獲得！';
  }

  @override
  String youEarnedBadge(String title) {
    return '「$title」を獲得しました！';
  }

  @override
  String get awesome => 'すごい！';

  @override
  String get onboardingTitle1 => '趣味を追跡しよう';

  @override
  String get onboardingTitle2 => 'バッジと連続記録を獲得';

  @override
  String get onboardingTitle3 => '同期とエクスポート';

  @override
  String get language => '言語';
}
