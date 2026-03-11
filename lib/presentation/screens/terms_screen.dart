import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/settings')),
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header('Hobby Tracker — Terms of Use'),
            Text('Last Updated: March 11, 2026 · Version 1.0\n'),
            _Section('1. Acceptance of Terms',
                'By downloading, installing, or using the Hobby Tracker application '
                    '("the App"), you agree to be bound by these Terms and Conditions. '
                    'If you do not agree, you must uninstall the App and discontinue use immediately.\n\n'
                    'We reserve the right to modify these Terms at any time. Continued use '
                    'after changes constitutes acceptance of the revised Terms.'),
            _Section('2. Description of Service',
                'Hobby Tracker is a personal productivity app that allows you to:\n\n'
                    '• Create and manage hobby profiles\n'
                    '• Log practice sessions with duration, notes, and ratings\n'
                    '• Track time with a built-in timer\n'
                    '• Set weekly and monthly goals\n'
                    '• View statistics and analytics\n'
                    '• Earn badges and track streaks\n'
                    '• Set reminders, attach photos, export data\n'
                    '• Optionally sync data to the cloud\n\n'
                    'The App is open-source under the MIT License.'),
            _Section('3. User Eligibility',
                '• You must be at least 13 years of age to use this App.\n'
                    '• If you are between 13 and 18, you must have parental or guardian consent.\n'
                    '• By using the App, you represent that you meet these requirements.'),
            _Section('4. User Data',
                'Local Data: All data is stored locally on your device using SQLite. '
                    'We do not have access to your locally stored data.\n\n'
                    'Cloud Sync (Optional): If enabled, data is stored on Firebase servers '
                    'operated by Google. You are responsible for securing your credentials.\n\n'
                    'Data Ownership: You retain full ownership of all data you create within the App.'),
            _Section('5. Privacy',
                'We do NOT collect, transmit, or store any personal information on our servers. '
                    'We do not use analytics, tracking, or advertising SDKs. '
                    'We do not sell, share, or distribute your data to any third parties.\n\n'
                    'Permissions requested:\n'
                    '• Storage — local database (required)\n'
                    '• Camera/Gallery — photo attachments (optional)\n'
                    '• Notifications — practice reminders (optional)\n'
                    '• Internet — cloud sync and update checking (optional)\n\n'
                    'GitHub API is contacted only to check for app updates. No personal data is sent.'),
            _Section('6. Acceptable Use',
                'You agree NOT to:\n\n'
                    '• Use the App for any unlawful purpose\n'
                    '• Attempt to reverse engineer beyond MIT License permissions\n'
                    '• Store illegal, harmful, or abusive content\n'
                    '• Attempt unauthorized access to connected systems\n'
                    '• Redistribute under different branding without attribution'),
            _Section('7. Intellectual Property',
                'The source code is licensed under the MIT License — you are free to use, '
                    'copy, modify, and distribute it subject to MIT conditions.\n\n'
                    'The name "Hobby Tracker" and app icon are the developer\'s property. '
                    'The MIT License does not grant trademark rights.\n\n'
                    'Third-party libraries (Flutter, Drift, BLoC, fl_chart, Firebase) are '
                    'governed by their respective licenses.'),
            _Section('8. Disclaimer of Warranties',
                'THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. '
                    'We do not warrant that the App will be uninterrupted, error-free, '
                    'or that data will not be lost or corrupted.'),
            _Section('9. Limitation of Liability',
                'We shall not be liable for any indirect, incidental, special, or '
                    'consequential damages including loss of data or profits. '
                    'Our total liability shall not exceed the amount paid for the App (\$0).'),
            _Section('10. Data Loss and Backup',
                'You are solely responsible for backing up your data. We recommend '
                    'enabling cloud sync or regularly exporting via CSV/PDF. '
                    'We are not responsible for data loss from device failure, '
                    'uninstallation, OS updates, or database corruption.'),
            _Section('11. Updates',
                'Updates are distributed via GitHub Releases. The App may notify you '
                    'of available updates (configurable in Settings). '
                    'We are not obligated to provide updates or support.'),
            _Section('12. Termination',
                'You may stop using the App at any time by uninstalling it. '
                    'Local data remains on your device until manually deleted. '
                    'Cloud data can be deleted via your Firebase account.'),
            _Section('13. Children\'s Privacy',
                'The App is not directed at children under 13. We do not knowingly '
                    'collect personal information from children under 13.'),
            _Section('14. Third-Party Services',
                '• Firebase Auth & Firestore (Google) — authentication and cloud storage\n'
                    '• GitHub API (Microsoft) — update checking\n\n'
                    'Use of these services is governed by their respective terms.'),
            _Section('15. Governing Law',
                'These Terms are governed by the laws of India. Disputes shall be '
                    'subject to the exclusive jurisdiction of courts in India.'),
            _Section('16. Contact',
                'For questions or concerns, open an issue at:\n'
                    'https://github.com/ashwani983/HobbyTracker/issues'),
            SizedBox(height: 24),
            Center(
              child: Text(
                'By using Hobby Tracker, you acknowledge that you have read, '
                'understood, and agree to these Terms and Conditions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section(this.title, this.body);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
}
