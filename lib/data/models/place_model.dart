import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.city,
    super.latitude,
    super.longitude,
    super.photoPath,
    required super.createdAt,
    required super.isFavorite,
  });

  factory PlaceModel.fromEntity(Place p) => PlaceModel(
        id: p.id,
        name: p.name,
        description: p.description,
        category: p.category,
        city: p.city,
        latitude: p.latitude,
        longitude: p.longitude,
        photoPath: p.photoPath,
        createdAt: p.createdAt,
        isFavorite: p.isFavorite,
      );

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
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
}
