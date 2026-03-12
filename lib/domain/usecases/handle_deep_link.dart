import '../../domain/repositories/hobby_repository.dart';

/// Maps deep link URIs to GoRouter paths.
/// Supported routes:
///   hobbytracker://dashboard       → /
///   hobbytracker://hobby/{name}    → /hobbies/{id} (looks up by name)
///   hobbytracker://timer/{name}    → /timer?hobbyId={id} (looks up by name)
///   hobbytracker://challenge/{code}→ /challenges/join?code={code}
class HandleDeepLink {
  final HobbyRepository _hobbyRepo;
  HandleDeepLink(this._hobbyRepo);

  Future<String?> call(Uri uri) async {
    if (uri.scheme != 'hobbytracker') return null;
    final segments = uri.pathSegments;
    final host = uri.host;
    if (segments.isEmpty || host == 'dashboard') return '/';

    switch (host) {
      case 'hobby' when segments.isNotEmpty:
        final id = await _resolveHobbyId(segments.first);
        return id != null ? '/hobbies/$id' : '/';
      case 'timer' when segments.isNotEmpty:
        final id = await _resolveHobbyId(segments.first);
        return id != null ? '/timer?hobbyId=$id' : '/timer';
      case 'challenge' when segments.isNotEmpty:
        return '/challenges/join?code=${segments.first}';
      default:
        return '/';
    }
  }

  /// Try as UUID first, then as hobby name (case-insensitive).
  Future<String?> _resolveHobbyId(String value) async {
    final byId = await _hobbyRepo.getHobbyById(value);
    if (byId != null) return byId.id;
    final byName = await _hobbyRepo.getHobbyByName(Uri.decodeComponent(value));
    return byName?.id;
  }
}
