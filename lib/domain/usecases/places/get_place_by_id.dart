import '../../entities/place.dart';
import '../../repositories/place_repository.dart';

class GetPlaceById {
  final PlaceRepository repo;
  const GetPlaceById(this.repo);

  Place? call(String id) => repo.getById(id);
}
