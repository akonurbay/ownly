import '../../entities/place.dart';
import '../../repositories/place_repository.dart';

class AddPlace {
  final PlaceRepository repo;
  const AddPlace(this.repo);

  Future<void> call(Place place) => repo.save(place);
}
