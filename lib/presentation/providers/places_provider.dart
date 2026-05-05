import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/seed_data.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/visit.dart';
import '../../domain/usecases/places/add_place.dart';
import '../../domain/usecases/places/delete_place_with_visits.dart';
import '../../domain/usecases/places/get_place_by_id.dart';
import '../../domain/usecases/places/get_places.dart';
import '../../domain/usecases/places/toggle_favorite.dart';
import '../../domain/usecases/visits/add_visit.dart';
import '../../domain/usecases/visits/delete_visits_for_place.dart';
import '../../domain/usecases/visits/get_visits.dart';
import 'repository_providers.dart';

const _uuid = Uuid();

// ─── Places ───────────────────────────────────────────────────────────────────

class PlacesNotifier extends StateNotifier<List<Place>> {
  final GetPlaces _getPlaces;
  final AddPlace _addPlace;
  final ToggleFavorite _toggleFavorite;
  final DeletePlaceWithVisits _deletePlaceWithVisits;
  final GetPlaceById _getPlaceById;
  final AddVisit _addVisit;

  PlacesNotifier({
    required GetPlaces getPlaces,
    required AddPlace addPlace,
    required ToggleFavorite toggleFavorite,
    required DeletePlaceWithVisits deletePlaceWithVisits,
    required GetPlaceById getPlaceById,
    required AddVisit addVisit,
  })  : _getPlaces = getPlaces,
        _addPlace = addPlace,
        _toggleFavorite = toggleFavorite,
        _deletePlaceWithVisits = deletePlaceWithVisits,
        _getPlaceById = getPlaceById,
        _addVisit = addVisit,
        super([]) {
    _load();
  }

  Future<void> _load() async {
    var places = _getPlaces();
    if (places.isEmpty) {
      await _seed();
      places = _getPlaces();
    }
    state = places;
  }

  Future<void> _seed() async {
    for (final p in seedPlaces) {
      await _addPlace(p);
    }
    for (final v in seedVisits) {
      await _addVisit(v);
    }
  }

  Future<void> addPlace(Place place) async {
    await _addPlace(place);
    state = _getPlaces();
  }

  Future<void> toggleFavorite(String id) async {
    await _toggleFavorite(id);
    state = _getPlaces();
  }

  Future<void> deletePlaceWithVisits(
      String id, VisitsNotifier visitsNotifier) async {
    await _deletePlaceWithVisits(id);
    await visitsNotifier.refresh();
    state = _getPlaces();
  }

  Place? getById(String id) => _getPlaceById(id);
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(
    getPlaces: ref.watch(getPlacesUseCaseProvider),
    addPlace: ref.watch(addPlaceUseCaseProvider),
    toggleFavorite: ref.watch(toggleFavoriteUseCaseProvider),
    deletePlaceWithVisits: ref.watch(deletePlaceWithVisitsUseCaseProvider),
    getPlaceById: ref.watch(getPlaceByIdUseCaseProvider),
    addVisit: ref.watch(addVisitUseCaseProvider),
  ),
);

// ─── Visits ───────────────────────────────────────────────────────────────────

class VisitsNotifier extends StateNotifier<List<Visit>> {
  final GetVisits _getVisits;
  final AddVisit _addVisit;
  final DeleteVisitsForPlace _deleteVisitsForPlace;

  VisitsNotifier({
    required GetVisits getVisits,
    required AddVisit addVisit,
    required DeleteVisitsForPlace deleteVisitsForPlace,
  })  : _getVisits = getVisits,
        _addVisit = addVisit,
        _deleteVisitsForPlace = deleteVisitsForPlace,
        super([]) {
    _load();
  }

  void _load() {
    state = _getVisits();
  }

  Future<void> refresh() async {
    state = _getVisits();
  }

  Future<void> addVisit({
    required String placeId,
    required MoodType mood,
    required WeatherType weather,
    required CompanionType companion,
    String? note,
    DateTime? visitedAt,
  }) async {
    final visit = Visit(
      id: _uuid.v4(),
      placeId: placeId,
      mood: mood,
      weather: weather,
      companion: companion,
      note: note,
      visitedAt: visitedAt ?? DateTime.now(),
    );
    await _addVisit(visit);
    state = _getVisits();
  }

  Future<void> deleteVisitsForPlace(String placeId) async {
    await _deleteVisitsForPlace(placeId);
    state = _getVisits();
  }

  List<Visit> forPlace(String placeId) =>
      state.where((v) => v.placeId == placeId).toList();

  List<Visit> get all => state;
}

final visitsProvider = StateNotifierProvider<VisitsNotifier, List<Visit>>(
  (ref) => VisitsNotifier(
    getVisits: ref.watch(getVisitsUseCaseProvider),
    addVisit: ref.watch(addVisitUseCaseProvider),
    deleteVisitsForPlace: ref.watch(deleteVisitsForPlaceUseCaseProvider),
  ),
);

// ─── Derived ─────────────────────────────────────────────────────────────────

final visitCountProvider = Provider.family<int, String>((ref, placeId) {
  return ref.watch(visitsProvider).where((v) => v.placeId == placeId).length;
});

final placeVisitsProvider = Provider.family<List<Visit>, String>((ref, placeId) {
  return ref.watch(visitsProvider).where((v) => v.placeId == placeId).toList();
});

// New place ID helper
String newPlaceId() => _uuid.v4();
