import '../../domain/entities/enums.dart';
import '../../domain/entities/visit.dart';

class VisitModel extends Visit {
  const VisitModel({
    required super.id,
    required super.placeId,
    required super.mood,
    required super.weather,
    required super.companion,
    super.note,
    required super.visitedAt,
  });

  factory VisitModel.fromEntity(Visit v) => VisitModel(
        id: v.id,
        placeId: v.placeId,
        mood: v.mood,
        weather: v.weather,
        companion: v.companion,
        note: v.note,
        visitedAt: v.visitedAt,
      );

  factory VisitModel.fromJson(Map<String, dynamic> json) => VisitModel(
        id: json['id'] as String,
        placeId: json['placeId'] as String,
        mood: MoodType.fromString(json['mood'] as String),
        weather: WeatherType.fromString(json['weather'] as String),
        companion: CompanionType.fromString(json['companion'] as String),
        note: json['note'] as String?,
        visitedAt: DateTime.parse(json['visitedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'placeId': placeId,
        'mood': mood.name,
        'weather': weather.name,
        'companion': companion.name,
        'note': note,
        'visitedAt': visitedAt.toIso8601String(),
      };
}
