abstract class SettingsRepository {
  bool getBool(String key, {bool defaultValue = false});
  Future<void> setBool(String key, bool value);
  Map<String, dynamic> exportAll();
}
