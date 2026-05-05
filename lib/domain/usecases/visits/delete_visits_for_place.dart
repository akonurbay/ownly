import '../../repositories/visit_repository.dart';

class DeleteVisitsForPlace {
  final VisitRepository repo;
  const DeleteVisitsForPlace(this.repo);

  Future<void> call(String placeId) => repo.deleteForPlace(placeId);
}
