import '../../repositories/settings_repository.dart';

class GetBoolSetting {
  final SettingsRepository repo;
  const GetBoolSetting(this.repo);

  bool call(String key, {bool defaultValue = false}) =>
      repo.getBool(key, defaultValue: defaultValue);
}
