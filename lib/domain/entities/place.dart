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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category.name,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'photoPath': photoPath,
        'createdAt': createdAt.toIso8601String(),
        'isFavorite': isFavorite,
      };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        category: PlaceCategory.fromString(json['category'] as String),
        city: json['city'] as String,
        latitude: json['latitude'] as double?,
        longitude: json['longitude'] as double?,
        photoPath: json['photoPath'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isFavorite: json['isFavorite'] as bool,
      );
}
