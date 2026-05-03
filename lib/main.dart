import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/router/app_router.dart';
import 'data/local/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final initialLocation = hasSeenOnboarding
      ? (isLoggedIn ? '/' : '/auth')
      : '/onboarding';

  final router = createRouter(initialLocation);

  runApp(
    ProviderScope(
      child: App(router: router),
    ),
  );
}
