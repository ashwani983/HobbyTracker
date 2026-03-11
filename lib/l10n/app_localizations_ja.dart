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
  String get recentSessions => '最近のセッション';

  @override
  String get noDataYet => 'データがありません。趣味を追加して始めましょう！';

  @override
  String get noHobbiesYet => '趣味がありません。追加しましょう！';

  @override
  String get noGoalsYet => '目標がありません。設定しましょう！';

  @override
  String get noSessionsYet => 'セッションがありません。';

  @override
  String get noSessionsLogged => 'セッションが記録されていません。';

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
  String get next => '次へ';

  @override
  String get getStarted => '始める';

  @override
  String get name => '名前';

  @override
  String get description => '説明';

  @override
  String get category => 'カテゴリ';

  @override
  String get color => '色';

  @override
  String get date => '日付';

  @override
  String get startDate => '開始日';

  @override
  String get endDate => '終了日';

  @override
  String get endDateError => '終了日は開始日より後でなければなりません';

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
  String get nameRequired => '名前は必須です';

  @override
  String get required => '必須';

  @override
  String get mustBePositive => '正の数でなければなりません';

  @override
  String get hobby => '趣味';

  @override
  String get type => 'タイプ';

  @override
  String get targetMinutes => '目標（分）';

  @override
  String get durationMinutesLabel => '時間（分）';

  @override
  String get notes => 'メモ';

  @override
  String get selectHobby => '趣味を選択';

  @override
  String get allTime => '全期間';

  @override
  String get archive => 'アーカイブ';

  @override
  String get running => '⏱ 実行中';

  @override
  String get paused => '⏸ 一時停止中';

  @override
  String get toggleTheme => 'テーマ切替';

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
  String goalDescription(String type, int minutes) {
    return '$type目標 — $minutes分';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total 解除済み';
  }

  @override
  String unlockedOn(String date) {
    return '$dateに解除';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return '$threshold $typeに到達して解除';
  }

  @override
  String get sessionSaved => 'セッションを保存しました！';

  @override
  String get sessionTooShort => 'セッションが短すぎて保存できません。';

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
  String get dailyActivity => '日別アクティビティ';

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
  String get signInToSync => 'サインインしてクラウド同期を有効にする';

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
    return '$emoji バッジ解除！';
  }

  @override
  String youEarnedBadge(String title) {
    return '「$title」を獲得しました！';
  }

  @override
  String get awesome => 'すごい！';

  @override
  String get onboardingTitle1 => '趣味を追跡';

  @override
  String get onboardingBody1 => 'セッションを記録し、目標を設定し、成長を見守りましょう。';

  @override
  String get onboardingTitle2 => 'バッジと連続記録を獲得';

  @override
  String get onboardingBody2 => '実績、連続記録、マイルストーンバッジでモチベーションを維持。';

  @override
  String get onboardingTitle3 => '同期とエクスポート';

  @override
  String get onboardingBody3 => 'クラウドにバックアップし、CSVやPDFでデータをエクスポート。';

  @override
  String get language => '言語';

  @override
  String get week => '週';

  @override
  String get month => '月';

  @override
  String get year => '年';

  @override
  String get catSports => 'スポーツ';

  @override
  String get catMusic => '音楽';

  @override
  String get catArt => 'アート';

  @override
  String get catReading => '読書';

  @override
  String get catGaming => 'ゲーム';

  @override
  String get catCooking => '料理';

  @override
  String get catFitness => 'フィットネス';

  @override
  String get catPhotography => '写真';

  @override
  String get catWriting => '執筆';

  @override
  String get catOther => 'その他';

  @override
  String get dayMon => '月';

  @override
  String get dayTue => '火';

  @override
  String get dayWed => '水';

  @override
  String get dayThu => '木';

  @override
  String get dayFri => '金';

  @override
  String get daySat => '土';

  @override
  String get daySun => '日';

  @override
  String get everyDay => '毎日';

  @override
  String get badge3DayStreak => '3日連続';

  @override
  String get badgeWeekWarrior => '週間戦士';

  @override
  String get badgeMonthlyMaster => '月間マスター';

  @override
  String get badgeCenturyClub => 'センチュリークラブ';

  @override
  String get badgeFirstStep => '最初の一歩';

  @override
  String get badgeGettingSerious => '本気モード';

  @override
  String get badgeDedicated => '献身的';

  @override
  String get badgeCenturion => '百人隊長';

  @override
  String get badgeFirstHour => '最初の1時間';

  @override
  String get badgeTimeInvestor => '時間投資家';

  @override
  String get badgeMasterOfTime => '時の達人';

  @override
  String get badgeExplorer => '探検家';

  @override
  String get badgeAdventurer => '冒険家';

  @override
  String get badgeRenaissance => 'ルネサンス';

  @override
  String get streak => '連続';

  @override
  String get totalTime => '合計時間';

  @override
  String get shareProgress => '進捗を共有';

  @override
  String get shareBadge => 'バッジを共有';

  @override
  String shareHobbyText(Object hobbyName) {
    return 'Hobby Trackerでの$hobbyNameの進捗をチェック！🎯';
  }

  @override
  String shareBadgeText(Object badgeTitle, Object emoji) {
    return 'Hobby Trackerで$badgeTitleバッジを獲得しました！$emoji';
  }
}
