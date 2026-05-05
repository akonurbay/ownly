import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/storage_keys.dart';
import '../../domain/usecases/settings/get_setting.dart';
import '../../domain/usecases/settings/set_setting.dart';
import 'repository_providers.dart';

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
  final SetBoolSetting _setBool;

  SettingsNotifier({
    required GetBoolSetting getBool,
    required SetBoolSetting setBool,
  })  : _setBool = setBool,
        super(SettingsState(
          darkTheme: getBool(StorageKeys.darkTheme),
          timeMachineNotifications:
              getBool(StorageKeys.timeMachineNotifs, defaultValue: true),
          gpsEnabled: getBool(StorageKeys.gpsEnabled, defaultValue: true),
        ));

  Future<void> toggleDarkTheme() async {
    final next = !state.darkTheme;
    await _setBool(StorageKeys.darkTheme, next);
    state = state.copyWith(darkTheme: next);
  }

  Future<void> toggleTimeMachineNotifs() async {
    final next = !state.timeMachineNotifications;
    await _setBool(StorageKeys.timeMachineNotifs, next);
    state = state.copyWith(timeMachineNotifications: next);
  }

  Future<void> toggleGps() async {
    final next = !state.gpsEnabled;
    await _setBool(StorageKeys.gpsEnabled, next);
    state = state.copyWith(gpsEnabled: next);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(
    getBool: ref.watch(getBoolSettingUseCaseProvider),
    setBool: ref.watch(setBoolSettingUseCaseProvider),
  ),
);
