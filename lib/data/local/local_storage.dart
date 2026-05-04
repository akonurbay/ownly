import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/visit.dart';

class LocalStorage {
  static const _placesBox = 'places';
  static const _visitsBox = 'visits';
  static const _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_placesBox);
    await Hive.openBox(_visitsBox);
    await Hive.openBox(_settingsBox);
  }

  static Box get _places => Hive.box(_placesBox);
  static Box get _visits => Hive.box(_visitsBox);
  static Box get _settings => Hive.box(_settingsBox);

  // Places
  static List<Place> getPlaces() {
    return _places.values
        .map((v) => Place.fromJson(jsonDecode(v as String)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> savePlace(Place place) async {
    await _places.put(place.id, jsonEncode(place.toJson()));
  }

  static Future<void> deletePlace(String id) async {
    await _places.delete(id);
  }

  // Visits
  static List<Visit> getVisits() {
    return _visits.values
        .map((v) => Visit.fromJson(jsonDecode(v as String)))
        .toList()
      ..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
  }

  static Future<void> saveVisit(Visit visit) async {
    await _visits.put(visit.id, jsonEncode(visit.toJson()));
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
      'places': _places.values
          .map((v) => jsonDecode(v as String))
          .toList(),
      'visits': _visits.values
          .map((v) => jsonDecode(v as String))
          .toList(),
    };
  }

  // Settings
  static bool getBool(String key, {bool defaultValue = false}) =>
      _settings.get(key, defaultValue: defaultValue) as bool;

  static Future<void> setBool(String key, bool value) async {
    await _settings.put(key, value);
  }
}
