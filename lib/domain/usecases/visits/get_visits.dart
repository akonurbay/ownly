import '../../entities/visit.dart';
import '../../repositories/visit_repository.dart';

class GetVisits {
  final VisitRepository repo;
  const GetVisits(this.repo);

  List<Visit> call() => repo.getAll();
}
