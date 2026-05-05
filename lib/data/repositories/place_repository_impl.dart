import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/local_storage.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  @override
  List<Place> getAll() => LocalStorage.getPlaces();

  @override
  Place? getById(String id) {
    for (final p in LocalStorage.getPlaces()) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  Future<void> save(Place place) => LocalStorage.savePlace(place);

  @override
  Future<void> delete(String id) => LocalStorage.deletePlace(id);
}
