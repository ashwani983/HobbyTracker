/// Maps deep link URIs to GoRouter paths.
/// Supported routes:
///   hobbytracker://dashboard       → /
///   hobbytracker://hobby/{id}      → /hobbies/{id}
///   hobbytracker://timer/{hobbyId} → /timer?hobbyId={hobbyId}
///   hobbytracker://challenge/{code}→ /challenges/join?code={code}
class HandleDeepLink {
  String? call(Uri uri) {
    if (uri.scheme != 'hobbytracker') return null;
    final segments = uri.pathSegments;
    if (segments.isEmpty || uri.host == 'dashboard') return '/';
    final host = uri.host;
    switch (host) {
      case 'hobby' when segments.isNotEmpty:
        return '/hobbies/${segments.first}';
      case 'timer' when segments.isNotEmpty:
        return '/timer?hobbyId=${segments.first}';
      case 'challenge' when segments.isNotEmpty:
        return '/challenges/join?code=${segments.first}';
      default:
        return '/'; // invalid route → dashboard
    }
  }
}
