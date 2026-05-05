import '../../repositories/place_repository.dart';

class ToggleFavorite {
  final PlaceRepository repo;
  const ToggleFavorite(this.repo);

  Future<void> call(String id) async {
    final place = repo.getById(id);
    if (place == null) return;
    await repo.save(place.copyWith(isFavorite: !place.isFavorite));
  }
}
