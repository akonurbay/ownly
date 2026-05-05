import '../entities/place.dart';

abstract class PlaceRepository {
  List<Place> getAll();
  Place? getById(String id);
  Future<void> save(Place place);
  Future<void> delete(String id);
}
