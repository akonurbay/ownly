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
}
