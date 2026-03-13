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
  String get recentSessions => 'हाल के सत्र';

  @override
  String get noDataYet => 'अभी कोई डेटा नहीं। शुरू करने के लिए एक शौक जोड़ें!';

  @override
  String get noHobbiesYet => 'अभी कोई शौक नहीं। एक जोड़ें!';

  @override
  String get noGoalsYet => 'अभी कोई लक्ष्य नहीं। एक सेट करें!';

  @override
  String get noSessionsYet => 'अभी कोई सत्र नहीं।';

  @override
  String get noSessionsLogged => 'अभी तक कोई सत्र दर्ज नहीं।';

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
  String get discard => 'हटाएं';

  @override
  String get later => 'बाद में';

  @override
  String get update => 'अपडेट';

  @override
  String get about => 'जानकारी';

  @override
  String get next => 'अगला';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get name => 'नाम';

  @override
  String get description => 'विवरण';

  @override
  String get category => 'श्रेणी';

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
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get required => 'आवश्यक';

  @override
  String get mustBePositive => 'एक सकारात्मक संख्या होनी चाहिए';

  @override
  String get hobby => 'शौक';

  @override
  String get type => 'प्रकार';

  @override
  String get targetMinutes => 'लक्ष्य (मिनट)';

  @override
  String get durationMinutesLabel => 'अवधि (मिनट)';

  @override
  String get notes => 'नोट्स';

  @override
  String get selectHobby => 'शौक चुनें';

  @override
  String get allTime => 'सभी समय';

  @override
  String get archive => 'संग्रह';

  @override
  String get running => '⏱ चल रहा है';

  @override
  String get paused => '⏸ रुका हुआ';

  @override
  String get toggleTheme => 'थीम बदलें';

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
  String goalDescription(String type, int minutes) {
    return '$type लक्ष्य — $minutes मिनट';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total अनलॉक';
  }

  @override
  String unlockedOn(String date) {
    return '$date को अनलॉक किया';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return 'अनलॉक करने के लिए $threshold $type तक पहुंचें';
  }

  @override
  String get sessionSaved => 'सत्र सहेजा गया!';

  @override
  String get sessionTooShort => 'सत्र सहेजने के लिए बहुत छोटा।';

  @override
  String get notesHint => 'आपने किस पर काम किया?';

  @override
  String get editGoal => 'लक्ष्य संपादित करें';

  @override
  String get updateGoal => 'लक्ष्य अपडेट करें';

  @override
  String get notificationPermissionDenied => 'सूचना अनुमति अस्वीकृत';

  @override
  String exportFailed(String error) {
    return 'निर्यात विफल: $error';
  }

  @override
  String get timePerHobby => 'प्रति शौक समय';

  @override
  String get distribution => 'वितरण';

  @override
  String get dailyActivity => 'दैनिक गतिविधि';

  @override
  String get bestDay => 'सर्वश्रेष्ठ दिन';

  @override
  String get mostActiveHobby => 'सबसे सक्रिय';

  @override
  String minutesOnDate(Object minutes, Object date) {
    return '$date को $minutesमि';
  }

  @override
  String minutesTotal(Object minutes) {
    return 'कुल $minutesमि';
  }

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
  String get autoSync => 'स्वचालित सिंक';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get signInToSync => 'क्लाउड सिंक सक्षम करने के लिए साइन इन करें';

  @override
  String get signInAndSync => 'साइन इन करें और डेटा सिंक करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

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
  String get onboardingBody1 =>
      'सत्र दर्ज करें, लक्ष्य निर्धारित करें और अपनी प्रगति देखें।';

  @override
  String get onboardingTitle2 => 'बैज और लय अर्जित करें';

  @override
  String get onboardingBody2 =>
      'उपलब्धियों, लय और माइलस्टोन बैज से प्रेरित रहें।';

  @override
  String get onboardingTitle3 => 'सिंक और निर्यात करें';

  @override
  String get onboardingBody3 =>
      'क्लाउड में बैकअप लें और CSV या PDF में डेटा निर्यात करें।';

  @override
  String get language => 'भाषा';

  @override
  String get week => 'सप्ताह';

  @override
  String get month => 'महीना';

  @override
  String get year => 'वर्ष';

  @override
  String get catSports => 'खेल';

  @override
  String get catMusic => 'संगीत';

  @override
  String get catArt => 'कला';

  @override
  String get catReading => 'पठन';

  @override
  String get catGaming => 'गेमिंग';

  @override
  String get catCooking => 'खाना बनाना';

  @override
  String get catFitness => 'फिटनेस';

  @override
  String get catPhotography => 'फोटोग्राफी';

  @override
  String get catWriting => 'लेखन';

  @override
  String get catOther => 'अन्य';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगल';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरु';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get daySun => 'रवि';

  @override
  String get everyDay => 'हर दिन';

  @override
  String get badge3DayStreak => '3 दिन की लय';

  @override
  String get badgeWeekWarrior => 'सप्ताह योद्धा';

  @override
  String get badgeMonthlyMaster => 'मासिक मास्टर';

  @override
  String get badgeCenturyClub => 'शतक क्लब';

  @override
  String get badgeFirstStep => 'पहला कदम';

  @override
  String get badgeGettingSerious => 'गंभीर हो रहे हैं';

  @override
  String get badgeDedicated => 'समर्पित';

  @override
  String get badgeCenturion => 'शतपति';

  @override
  String get badgeFirstHour => 'पहला घंटा';

  @override
  String get badgeTimeInvestor => 'समय निवेशक';

  @override
  String get badgeMasterOfTime => 'समय का मास्टर';

  @override
  String get badgeExplorer => 'खोजकर्ता';

  @override
  String get badgeAdventurer => 'साहसी';

  @override
  String get badgeRenaissance => 'पुनर्जागरण';

  @override
  String get streak => 'लगातार';

  @override
  String get totalTime => 'कुल समय';

  @override
  String get shareProgress => 'प्रगति साझा करें';

  @override
  String get shareBadge => 'बैज साझा करें';

  @override
  String shareHobbyText(Object hobbyName) {
    return 'Hobby Tracker पर मेरी $hobbyName प्रगति देखें! 🎯';
  }

  @override
  String shareBadgeText(Object badgeTitle, Object emoji) {
    return 'मैंने Hobby Tracker पर $badgeTitle बैज अर्जित किया! $emoji';
  }
}
