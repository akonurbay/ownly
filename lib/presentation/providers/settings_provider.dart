import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/local_storage.dart';

class SettingsState {
  final bool darkTheme;
  final bool timeMachineNotifications;
  final bool gpsEnabled;

  const SettingsState({
    this.darkTheme = false,
    this.timeMachineNotifications = true,
    this.gpsEnabled = true,
  });

  SettingsState copyWith({
    bool? darkTheme,
    bool? timeMachineNotifications,
    bool? gpsEnabled,
  }) {
    return SettingsState(
      darkTheme: darkTheme ?? this.darkTheme,
      timeMachineNotifications:
          timeMachineNotifications ?? this.timeMachineNotifications,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
          darkTheme: LocalStorage.getBool('darkTheme'),
          timeMachineNotifications:
              LocalStorage.getBool('timeMachineNotifs', defaultValue: true),
          gpsEnabled: LocalStorage.getBool('gpsEnabled', defaultValue: true),
        ));

  Future<void> toggleDarkTheme() async {
    final next = !state.darkTheme;
    await LocalStorage.setBool('darkTheme', next);
    state = state.copyWith(darkTheme: next);
  }

  Future<void> toggleTimeMachineNotifs() async {
    final next = !state.timeMachineNotifications;
    await LocalStorage.setBool('timeMachineNotifs', next);
    state = state.copyWith(timeMachineNotifications: next);
  }

  Future<void> toggleGps() async {
    final next = !state.gpsEnabled;
    await LocalStorage.setBool('gpsEnabled', next);
    state = state.copyWith(gpsEnabled: next);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
