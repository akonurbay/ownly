import 'enums.dart';

class Visit {
  final String id;
  final String placeId;
  final MoodType mood;
  final WeatherType weather;
  final CompanionType companion;
  final String? note;
  final DateTime visitedAt;

  const Visit({
    required this.id,
    required this.placeId,
    required this.mood,
    required this.weather,
    required this.companion,
    this.note,
    required this.visitedAt,
  });

  Visit copyWith({
    String? id,
    String? placeId,
    MoodType? mood,
    WeatherType? weather,
    CompanionType? companion,
    String? note,
    DateTime? visitedAt,
  }) {
    return Visit(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      companion: companion ?? this.companion,
      note: note ?? this.note,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'placeId': placeId,
        'mood': mood.name,
        'weather': weather.name,
        'companion': companion.name,
        'note': note,
        'visitedAt': visitedAt.toIso8601String(),
      };

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        id: json['id'] as String,
        placeId: json['placeId'] as String,
        mood: MoodType.fromString(json['mood'] as String),
        weather: WeatherType.fromString(json['weather'] as String),
        companion: CompanionType.fromString(json['companion'] as String),
        note: json['note'] as String?,
        visitedAt: DateTime.parse(json['visitedAt'] as String),
      );
}
