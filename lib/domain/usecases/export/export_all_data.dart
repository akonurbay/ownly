import '../../repositories/settings_repository.dart';

class ExportAllData {
  final SettingsRepository repo;
  const ExportAllData(this.repo);

  Map<String, dynamic> call() => repo.exportAll();
}
