import '../../repositories/place_repository.dart';
import '../../repositories/visit_repository.dart';

class DeletePlaceWithVisits {
  final PlaceRepository placeRepo;
  final VisitRepository visitRepo;
  const DeletePlaceWithVisits(this.placeRepo, this.visitRepo);

  Future<void> call(String id) async {
    await visitRepo.deleteForPlace(id);
    await placeRepo.delete(id);
  }
}
