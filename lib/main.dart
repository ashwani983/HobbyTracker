import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'core/services/widget_service.dart';
import 'domain/repositories/hobby_repository.dart';
import 'domain/usecases/handle_deep_link.dart';
import 'firebase_options.dart';
import 'presentation/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final tzName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzName));
  await NotificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  await WidgetService.init();

  final deepLinkHandler = HandleDeepLink(sl<HobbyRepository>());

  // Cold start deep link
  final appLinks = AppLinks();
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    final path = await deepLinkHandler.call(initialLink);
    if (path != null) {
      appRouter.go(path);
    }
  }

  // Warm start deep links
  appLinks.uriLinkStream.listen((uri) async {
    final path = await deepLinkHandler.call(uri);
    if (path != null) {
      Future.microtask(() => appRouter.go(path));
    }
  });

  runApp(const App());
}
