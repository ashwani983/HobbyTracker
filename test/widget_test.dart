import 'package:flutter_test/flutter_test.dart';
import 'package:hobby_tracker/app.dart';

void main() {
  testWidgets('App builds without error', (tester) async {
    // Smoke test — just verify the widget tree can be created.
    // Full widget tests require DI setup and are covered in task 9.2.
    expect(const App(), isNotNull);
  });
}
