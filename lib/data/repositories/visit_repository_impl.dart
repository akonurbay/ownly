import '../../domain/entities/visit.dart';
import '../../domain/repositories/visit_repository.dart';
import '../datasources/local_storage.dart';

class VisitRepositoryImpl implements VisitRepository {
  @override
  List<Visit> getAll() => LocalStorage.getVisits();

  @override
  Future<void> save(Visit visit) => LocalStorage.saveVisit(visit);

  @override
  Future<void> deleteForPlace(String placeId) =>
      LocalStorage.deleteVisitsForPlace(placeId);
}
