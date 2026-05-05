import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/storage_keys.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/visit.dart';
import '../models/place_model.dart';
import '../models/visit_model.dart';

class LocalStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(StorageKeys.placesBox);
    await Hive.openBox(StorageKeys.visitsBox);
    await Hive.openBox(StorageKeys.settingsBox);
  }

  static Box get _places => Hive.box(StorageKeys.placesBox);
  static Box get _visits => Hive.box(StorageKeys.visitsBox);
  static Box get _settings => Hive.box(StorageKeys.settingsBox);

  // Places
  static List<Place> getPlaces() {
    return _places.values
        .map((v) =>
            PlaceModel.fromJson(jsonDecode(v as String) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> savePlace(Place place) async {
    final model = place is PlaceModel ? place : PlaceModel.fromEntity(place);
    await _places.put(place.id, jsonEncode(model.toJson()));
  }

  static Future<void> deletePlace(String id) async {
    await _places.delete(id);
  }

  // Visits
  static List<Visit> getVisits() {
    return _visits.values
        .map((v) =>
            VisitModel.fromJson(jsonDecode(v as String) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
  }

  static Future<void> saveVisit(Visit visit) async {
    final model = visit is VisitModel ? visit : VisitModel.fromEntity(visit);
    await _visits.put(visit.id, jsonEncode(model.toJson()));
  }

  static Future<void> deleteVisit(String id) async {
    await _visits.delete(id);
  }

  static Future<void> deleteVisitsForPlace(String placeId) async {
    final ids = _visits.keys.where((key) {
      final raw = _visits.get(key);
      if (raw == null) return false;
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return map['placeId'] == placeId;
    }).toList();
    await _visits.deleteAll(ids);
  }

  static Map<String, dynamic> exportAll() {
    return {
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0',
      'places': _places.values.map((v) => jsonDecode(v as String)).toList(),
      'visits': _visits.values.map((v) => jsonDecode(v as String)).toList(),
    };
  }

  // Settings
  static bool getBool(String key, {bool defaultValue = false}) =>
      _settings.get(key, defaultValue: defaultValue) as bool;

  static Future<void> setBool(String key, bool value) async {
    await _settings.put(key, value);
  }
}
