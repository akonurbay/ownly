import '../../entities/visit.dart';
import '../../repositories/visit_repository.dart';

class AddVisit {
  final VisitRepository repo;
  const AddVisit(this.repo);

  Future<void> call(Visit visit) => repo.save(visit);
}
