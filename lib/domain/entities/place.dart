import 'enums.dart';

class Place {
  final String id;
  final String name;
  final String description;
  final PlaceCategory category;
  final String city;
  final double? latitude;
  final double? longitude;
  final String? photoPath;
  final DateTime createdAt;
  final bool isFavorite;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    this.latitude,
    this.longitude,
    this.photoPath,
    required this.createdAt,
    required this.isFavorite,
  });

  Place copyWith({
    String? id,
    String? name,
    String? description,
    PlaceCategory? category,
    String? city,
    double? latitude,
    double? longitude,
    String? photoPath,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
