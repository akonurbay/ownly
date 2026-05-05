import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/route_paths.dart';
import 'core/constants/storage_keys.dart';
import 'core/router/app_router.dart';
import 'data/datasources/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding =
      prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  final initialLocation = hasSeenOnboarding
      ? (isLoggedIn ? RoutePaths.home : RoutePaths.auth)
      : RoutePaths.onboarding;

  final router = createRouter(initialLocation);

  runApp(
    ProviderScope(
      child: App(router: router),
    ),
  );
}
