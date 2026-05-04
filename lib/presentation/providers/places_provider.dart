import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/local_storage.dart';
import '../../data/seed_data.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/visit.dart';
import '../../domain/entities/enums.dart';

const _uuid = Uuid();

// ─── Places ───────────────────────────────────────────────────────────────────

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]) {
    _load();
  }

  void _load() {
    var places = LocalStorage.getPlaces();
    if (places.isEmpty) {
      _seed();
      places = LocalStorage.getPlaces();
    }
    state = places;
  }

  void _seed() {
    for (final p in seedPlaces) {
      LocalStorage.savePlace(p);
    }
    for (final v in seedVisits) {
      LocalStorage.saveVisit(v);
    }
  }

  Future<void> addPlace(Place place) async {
    await LocalStorage.savePlace(place);
    state = LocalStorage.getPlaces();
  }

  Future<void> toggleFavorite(String id) async {
    final place = state.firstWhere((p) => p.id == id);
    await LocalStorage.savePlace(place.copyWith(isFavorite: !place.isFavorite));
    state = LocalStorage.getPlaces();
  }

  Future<void> deletePlace(String id) async {
    await LocalStorage.deletePlace(id);
    state = LocalStorage.getPlaces();
  }

  Future<void> deletePlaceWithVisits(String id, VisitsNotifier visitsNotifier) async {
    await visitsNotifier.deleteVisitsForPlace(id);
    await LocalStorage.deletePlace(id);
    state = LocalStorage.getPlaces();
  }

  Place? getById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);

// ─── Visits ───────────────────────────────────────────────────────────────────

class VisitsNotifier extends StateNotifier<List<Visit>> {
  VisitsNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = LocalStorage.getVisits();
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
    await LocalStorage.saveVisit(visit);
    state = LocalStorage.getVisits();
  }

  Future<void> deleteVisitsForPlace(String placeId) async {
    await LocalStorage.deleteVisitsForPlace(placeId);
    state = LocalStorage.getVisits();
  }

  List<Visit> forPlace(String placeId) =>
      state.where((v) => v.placeId == placeId).toList();

  List<Visit> get all => state;
}

final visitsProvider = StateNotifierProvider<VisitsNotifier, List<Visit>>(
  (ref) => VisitsNotifier(),
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
