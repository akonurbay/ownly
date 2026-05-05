import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_storage.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  bool getBool(String key, {bool defaultValue = false}) =>
      LocalStorage.getBool(key, defaultValue: defaultValue);

  @override
  Future<void> setBool(String key, bool value) =>
      LocalStorage.setBool(key, value);

  @override
  Map<String, dynamic> exportAll() => LocalStorage.exportAll();
}
