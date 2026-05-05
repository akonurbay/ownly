import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/place_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/visit_repository_impl.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/visit_repository.dart';
import '../../domain/usecases/export/export_all_data.dart';
import '../../domain/usecases/places/add_place.dart';
import '../../domain/usecases/places/delete_place_with_visits.dart';
import '../../domain/usecases/places/get_place_by_id.dart';
import '../../domain/usecases/places/get_places.dart';
import '../../domain/usecases/places/toggle_favorite.dart';
import '../../domain/usecases/settings/get_setting.dart';
import '../../domain/usecases/settings/set_setting.dart';
import '../../domain/usecases/visits/add_visit.dart';
import '../../domain/usecases/visits/delete_visits_for_place.dart';
import '../../domain/usecases/visits/get_visits.dart';

// Repositories
final placeRepositoryProvider =
    Provider<PlaceRepository>((ref) => PlaceRepositoryImpl());

final visitRepositoryProvider =
    Provider<VisitRepository>((ref) => VisitRepositoryImpl());

final settingsRepositoryProvider =
    Provider<SettingsRepository>((ref) => SettingsRepositoryImpl());

// Place use cases
final getPlacesUseCaseProvider =
    Provider((ref) => GetPlaces(ref.watch(placeRepositoryProvider)));

final getPlaceByIdUseCaseProvider =
    Provider((ref) => GetPlaceById(ref.watch(placeRepositoryProvider)));

final addPlaceUseCaseProvider =
    Provider((ref) => AddPlace(ref.watch(placeRepositoryProvider)));

final toggleFavoriteUseCaseProvider =
    Provider((ref) => ToggleFavorite(ref.watch(placeRepositoryProvider)));

final deletePlaceWithVisitsUseCaseProvider = Provider((ref) =>
    DeletePlaceWithVisits(
      ref.watch(placeRepositoryProvider),
      ref.watch(visitRepositoryProvider),
    ));

// Visit use cases
final getVisitsUseCaseProvider =
    Provider((ref) => GetVisits(ref.watch(visitRepositoryProvider)));

final addVisitUseCaseProvider =
    Provider((ref) => AddVisit(ref.watch(visitRepositoryProvider)));

final deleteVisitsForPlaceUseCaseProvider = Provider(
    (ref) => DeleteVisitsForPlace(ref.watch(visitRepositoryProvider)));

// Settings use cases
final getBoolSettingUseCaseProvider =
    Provider((ref) => GetBoolSetting(ref.watch(settingsRepositoryProvider)));

final setBoolSettingUseCaseProvider =
    Provider((ref) => SetBoolSetting(ref.watch(settingsRepositoryProvider)));

// Export use case
final exportAllDataUseCaseProvider =
    Provider((ref) => ExportAllData(ref.watch(settingsRepositoryProvider)));
