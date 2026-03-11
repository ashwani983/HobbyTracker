import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class GitHubRelease {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;

  const GitHubRelease({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) => GitHubRelease(
        tagName: json['tag_name'] as String,
        name: json['name'] as String? ?? '',
        body: json['body'] as String? ?? '',
        htmlUrl: json['html_url'] as String,
      );

  /// Parse "v1.2.3" or "1.2.3" into comparable list [1, 2, 3]
  List<int> get versionParts {
    final clean = tagName.replaceFirst(RegExp(r'^v'), '');
    return clean.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  }
}

class AppUpdateService {
  static const _repo = 'ashwani983/HobbyTracker';

  static Future<GitHubRelease?> checkForUpdate() async {
    try {
      final resp = await http.get(
        Uri.parse('https://api.github.com/repos/$_repo/releases/latest'),
      );
      if (resp.statusCode != 200) return null;
      final release = GitHubRelease.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>,
      );
      final info = await PackageInfo.fromPlatform();
      final current = info.version.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      final latest = release.versionParts;

      for (var i = 0; i < 3; i++) {
        final c = i < current.length ? current[i] : 0;
        final l = i < latest.length ? latest[i] : 0;
        if (l > c) return release;
        if (l < c) return null;
      }
      return null; // same version
    } catch (_) {
      return null;
    }
  }
}
