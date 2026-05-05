import '../../repositories/settings_repository.dart';

class SetBoolSetting {
  final SettingsRepository repo;
  const SetBoolSetting(this.repo);

  Future<void> call(String key, bool value) => repo.setBool(key, value);
}
