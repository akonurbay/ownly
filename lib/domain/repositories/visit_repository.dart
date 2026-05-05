import '../entities/visit.dart';

abstract class VisitRepository {
  List<Visit> getAll();
  Future<void> save(Visit visit);
  Future<void> deleteForPlace(String placeId);
}
