# Terms and Conditions

**Hobby Tracker — Terms of Use**
**Last Updated: March 11, 2026**
**Version: 1.0**

---

## 1. Acceptance of Terms

By downloading, installing, or using the Hobby Tracker application ("the App"), you ("User", "you") agree to be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, you must uninstall the App and discontinue use immediately.

These Terms constitute a legally binding agreement between you and the developer of Hobby Tracker ("we", "us", "our"). We reserve the right to modify these Terms at any time. Continued use of the App after changes constitutes acceptance of the revised Terms.

---

## 2. Description of Service

Hobby Tracker is a personal productivity application that allows users to:

- Create and manage hobby profiles with categories, descriptions, and color coding
- Log practice sessions with duration, notes, and ratings
- Track time spent on hobbies using a built-in timer
- Set weekly and monthly goals for hobby practice
- View statistics and analytics about hobby engagement
- Earn badges and track streaks for consistent practice (v2.0.0+)
- Set reminders for hobby practice (v2.0.0+)
- Attach photos to session logs (v2.0.0+)
- Export data in CSV and PDF formats (v2.0.0+)
- Optionally sync data to the cloud via Firebase (v2.0.0+)

The App is provided as an open-source project under the MIT License, hosted at https://github.com/ashwani983/HobbyTracker.

---

## 3. User Eligibility

- You must be at least 13 years of age to use this App.
- If you are between 13 and 18 years of age, you must have parental or guardian consent to use this App.
- By using the App, you represent and warrant that you meet these eligibility requirements.

---

## 4. User Account and Data

### 4.1 Local Data Storage

- The App stores all user data locally on your device using an SQLite database.
- You are solely responsible for maintaining the security of your device and the data stored on it.
- We do not have access to your locally stored data.

### 4.2 Cloud Sync (Optional, v2.0.0+)

- If you choose to enable cloud sync, your data will be stored on Firebase servers operated by Google.
- Cloud sync requires authentication via Google Sign-In or email/password.
- You are responsible for maintaining the confidentiality of your account credentials.
- We are not responsible for any unauthorized access to your cloud-synced data resulting from your failure to secure your credentials.

### 4.3 Data Ownership

- You retain full ownership of all data you create within the App, including hobby profiles, session logs, goals, photos, and any other user-generated content.
- We do not claim any intellectual property rights over your data.

---

## 5. Privacy and Data Collection

### 5.1 Data We Do NOT Collect

- We do not collect, transmit, or store any personal information on our servers.
- We do not use analytics, tracking, or advertising SDKs.
- We do not sell, share, or distribute your data to any third parties.
- We do not access your contacts, location, microphone, or any sensors beyond what is explicitly required for App functionality.

### 5.2 Device Permissions

The App may request the following permissions:

| Permission | Purpose | Required |
|-----------|---------|----------|
| Storage | Save and read the local database | Yes |
| Camera | Attach photos to session logs (v2.0.0+) | Optional |
| Photo Gallery | Select existing photos for session logs (v2.0.0+) | Optional |
| Notifications | Send hobby practice reminders (v2.0.0+) | Optional |
| Internet | Cloud sync and update checking (v2.0.0+) | Optional |

You may deny optional permissions; the App will continue to function with reduced features.

### 5.3 GitHub API Usage

- The App may contact the GitHub API (`api.github.com`) solely to check for new releases of the App.
- No personal data is transmitted during this check.
- This feature can be disabled in Settings.

### 5.4 Firebase Services (v2.0.0+)

- If cloud sync is enabled, data is transmitted to and stored on Google Firebase servers.
- Firebase usage is governed by Google's Terms of Service and Privacy Policy.
- You may disable cloud sync at any time; local data will be retained.

---

## 6. Acceptable Use

You agree NOT to:

1. Use the App for any unlawful purpose or in violation of any applicable laws or regulations.
2. Attempt to reverse engineer, decompile, or disassemble the App beyond what is permitted by the MIT License.
3. Use the App to store, transmit, or process any content that is illegal, harmful, threatening, abusive, defamatory, or otherwise objectionable.
4. Attempt to gain unauthorized access to any systems or networks connected to the App's cloud services.
5. Use automated scripts, bots, or other tools to interact with the App in a manner that could disrupt its functionality.
6. Redistribute the App under a different name or branding without proper attribution as required by the MIT License.

---

## 7. Intellectual Property

### 7.1 Open Source License

- The App's source code is licensed under the MIT License.
- You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, subject to the conditions of the MIT License.
- The full license text is available at https://github.com/ashwani983/HobbyTracker/blob/main/LICENSE.

### 7.2 Trademarks

- The name "Hobby Tracker", the app icon, and associated branding are the property of the developer.
- The MIT License does not grant rights to use our trademarks or branding.

### 7.3 Third-Party Libraries

The App uses third-party open-source libraries, each governed by their respective licenses. Key dependencies include:

- Flutter (BSD-3-Clause) — Google
- Drift (MIT) — Simon Binder
- BLoC (MIT) — Felix Angelov
- fl_chart (MIT) — Iman Khoshabi
- Firebase SDKs (Apache 2.0) — Google

A complete list of dependencies and their licenses is available in the App's `pubspec.yaml` file.

---

## 8. Disclaimer of Warranties

THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO:

- IMPLIED WARRANTIES OF MERCHANTABILITY
- FITNESS FOR A PARTICULAR PURPOSE
- NON-INFRINGEMENT
- ACCURACY OR RELIABILITY OF DATA

We do not warrant that:

1. The App will meet your specific requirements.
2. The App will be uninterrupted, timely, secure, or error-free.
3. The results obtained from the App will be accurate or reliable.
4. Any errors in the App will be corrected.
5. Data stored locally or in the cloud will not be lost or corrupted.

---

## 9. Limitation of Liability

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW:

1. We shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of data, loss of profits, or loss of goodwill.
2. We shall not be liable for any damages arising from:
   - Your use or inability to use the App
   - Data loss due to device failure, App bugs, or cloud service outages
   - Unauthorized access to your data
   - Any third-party services integrated with the App (Firebase, Google Sign-In)
3. Our total aggregate liability shall not exceed the amount you paid for the App (which is $0 for the free version).

---

## 10. Data Loss and Backup

1. You are solely responsible for backing up your data.
2. We strongly recommend enabling cloud sync or regularly exporting your data using the CSV/PDF export feature.
3. We are not responsible for any data loss resulting from:
   - Device failure, theft, or damage
   - App uninstallation
   - Operating system updates that affect app data
   - Database corruption
   - Cloud service outages or account termination

---

## 11. Updates and Modifications

1. We may release updates to the App that add features, fix bugs, or improve performance.
2. Updates are distributed via GitHub Releases at https://github.com/ashwani983/HobbyTracker/releases.
3. The App may notify you of available updates (this can be disabled in Settings).
4. We are not obligated to provide updates, maintenance, or support for the App.
5. We reserve the right to discontinue the App at any time without notice.

---

## 12. Termination

1. You may terminate your use of the App at any time by uninstalling it from your device.
2. If cloud sync is enabled, you may delete your cloud data by signing into your Firebase account and requesting data deletion.
3. We reserve the right to terminate or suspend access to cloud services for users who violate these Terms.
4. Upon termination, your locally stored data remains on your device until you manually delete it.

---

## 13. Children's Privacy

1. The App is not directed at children under 13 years of age.
2. We do not knowingly collect personal information from children under 13.
3. If you are a parent or guardian and believe your child has provided data through the App's cloud sync feature, please contact us to request deletion.

---

## 14. Third-Party Services

The App may integrate with the following third-party services:

| Service | Provider | Purpose | Their Terms |
|---------|----------|---------|-------------|
| Firebase Auth | Google | User authentication | https://firebase.google.com/terms |
| Cloud Firestore | Google | Cloud data storage | https://firebase.google.com/terms |
| GitHub API | Microsoft | Update checking | https://docs.github.com/en/site-policy/github-terms |

We are not responsible for the practices, policies, or content of these third-party services. Your use of these services is governed by their respective terms and privacy policies.

---

## 15. Governing Law

1. These Terms shall be governed by and construed in accordance with the laws of India.
2. Any disputes arising from these Terms or the use of the App shall be subject to the exclusive jurisdiction of the courts in India.

---

## 16. Severability

If any provision of these Terms is found to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary, and the remaining provisions shall remain in full force and effect.

---

## 17. Entire Agreement

These Terms, together with the MIT License and any applicable Privacy Policy, constitute the entire agreement between you and us regarding the use of the App, superseding any prior agreements.

---

## 18. Contact Information

For questions, concerns, or requests regarding these Terms, please open an issue on our GitHub repository:

- **GitHub:** https://github.com/ashwani983/HobbyTracker/issues
- **Developer:** ashwani983

---

## 19. Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | March 11, 2026 | Initial Terms and Conditions |

---

*By using Hobby Tracker, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.*
