import '../../entities/place.dart';
import '../../repositories/place_repository.dart';

class GetPlaces {
  final PlaceRepository repo;
  const GetPlaces(this.repo);

  List<Place> call() => repo.getAll();
}
