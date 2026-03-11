// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हॉबी ट्रैकर';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get hobbies => 'शौक';

  @override
  String get timer => 'टाइमर';

  @override
  String get goals => 'लक्ष्य';

  @override
  String get stats => 'आँकड़े';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get activeHobbies => 'सक्रिय शौक';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get dayStreak => 'दिन की लय';

  @override
  String get noDataYet => 'अभी कोई डेटा नहीं। शुरू करने के लिए एक शौक जोड़ें!';

  @override
  String get noHobbiesYet => 'अभी कोई शौक नहीं। एक जोड़ें!';

  @override
  String get noGoalsYet => 'अभी कोई लक्ष्य नहीं। एक सेट करें!';

  @override
  String get noSessionsYet => 'अभी कोई सत्र नहीं।';

  @override
  String get noSessionsLogged => 'कोई सत्र दर्ज नहीं।';

  @override
  String get noDataForPeriod => 'इस अवधि के लिए कोई डेटा नहीं।';

  @override
  String get addHobbyFirst => 'पहले एक शौक जोड़ें।';

  @override
  String get addHobbyFirstTimer =>
      'टाइमर का उपयोग करने के लिए पहले एक शौक जोड़ें।';

  @override
  String get addHobby => 'शौक जोड़ें';

  @override
  String get editHobby => 'शौक संपादित करें';

  @override
  String get hobbyDetail => 'शौक विवरण';

  @override
  String get addGoal => 'लक्ष्य जोड़ें';

  @override
  String get createGoal => 'लक्ष्य बनाएं';

  @override
  String get logSession => 'सत्र दर्ज करें';

  @override
  String get saveSession => 'सत्र सहेजें';

  @override
  String get saveSessionQuestion => 'सत्र सहेजें?';

  @override
  String get create => 'बनाएं';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get skip => 'छोड़ें';

  @override
  String get start => 'शुरू';

  @override
  String get stop => 'रोकें';

  @override
  String get pause => 'विराम';

  @override
  String get resume => 'जारी रखें';

  @override
  String get reset => 'रीसेट';

  @override
  String get discard => 'त्यागें';

  @override
  String get later => 'बाद में';

  @override
  String get update => 'अपडेट';

  @override
  String get about => 'जानकारी';

  @override
  String get color => 'रंग';

  @override
  String get date => 'तारीख';

  @override
  String get startDate => 'आरंभ तिथि';

  @override
  String get endDate => 'समाप्ति तिथि';

  @override
  String get endDateError => 'समाप्ति तिथि आरंभ तिथि के बाद होनी चाहिए';

  @override
  String get ratingOptional => 'रेटिंग (वैकल्पिक)';

  @override
  String get sessions => 'सत्र';

  @override
  String get reminders => 'रिमाइंडर';

  @override
  String get noRemindersSet => 'कोई रिमाइंडर नहीं। जोड़ने के लिए + दबाएं।';

  @override
  String get selectDays => 'दिन चुनें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String photosCount(int count) {
    return 'फ़ोटो ($count/5)';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String durationHoursMinutes(int hours, int mins) {
    return '$hoursघं $minsमि';
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
    return '$days दिन की लय';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return '$minutes मिनट का सत्र सहेजें?';
  }

  @override
  String get sessionSaved => 'सत्र सहेजा गया!';

  @override
  String get sessionTooShort => 'सत्र बहुत छोटा है।';

  @override
  String get notificationPermissionDenied => 'सूचना अनुमति अस्वीकृत';

  @override
  String exportFailed(String error) {
    return 'निर्यात विफल: $error';
  }

  @override
  String get timePerHobby => 'शौक के अनुसार समय';

  @override
  String get distribution => 'वितरण';

  @override
  String get dailyActivity => 'दैनिक गतिविधि';

  @override
  String get theme => 'थीम';

  @override
  String get badges => 'बैज';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get exportCsv => 'CSV निर्यात';

  @override
  String get exportPdf => 'PDF निर्यात';

  @override
  String get csvOrPdf => 'CSV या PDF';

  @override
  String get cloudSync => 'क्लाउड सिंक';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncing => 'सिंक हो रहा है...';

  @override
  String get syncComplete => '✓ सिंक पूर्ण';

  @override
  String get autoSync => 'ऑटो सिंक';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get signInToSync => 'सिंक के लिए साइन इन करें';

  @override
  String get signInAndSync => 'साइन इन करें और डेटा सिंक करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get checkForUpdates => 'अपडेट जांचें';

  @override
  String get checking => 'जांच रहा है...';

  @override
  String updateAvailable(String version) {
    return 'अपडेट $version उपलब्ध';
  }

  @override
  String versionAvailable(String version) {
    return '$version उपलब्ध';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '$emoji बैज अनलॉक!';
  }

  @override
  String youEarnedBadge(String title) {
    return 'आपने \"$title\" अर्जित किया!';
  }

  @override
  String get awesome => 'शानदार!';

  @override
  String get onboardingTitle1 => 'अपने शौक ट्रैक करें';

  @override
  String get onboardingTitle2 => 'बैज और लय अर्जित करें';

  @override
  String get onboardingTitle3 => 'सिंक और निर्यात करें';

  @override
  String get language => 'भाषा';
}
