import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum PlaceCategory {
  cafe,
  nature,
  museum,
  restaurant,
  other;

  String get label {
    switch (this) {
      case PlaceCategory.cafe:
        return 'кафе';
      case PlaceCategory.nature:
        return 'природа';
      case PlaceCategory.museum:
        return 'музей';
      case PlaceCategory.restaurant:
        return 'ресторан';
      case PlaceCategory.other:
        return 'другое';
    }
  }

  String get emoji {
    switch (this) {
      case PlaceCategory.cafe:
        return '☕';
      case PlaceCategory.nature:
        return '🌿';
      case PlaceCategory.museum:
        return '🏛';
      case PlaceCategory.restaurant:
        return '🍽';
      case PlaceCategory.other:
        return '📍';
    }
  }

  Color get color {
    switch (this) {
      case PlaceCategory.cafe:
        return AppColors.gold;
      case PlaceCategory.nature:
        return AppColors.green;
      case PlaceCategory.museum:
        return AppColors.purple;
      case PlaceCategory.restaurant:
        return AppColors.accent;
      case PlaceCategory.other:
        return AppColors.blue;
    }
  }

  Color get bgColor {
    switch (this) {
      case PlaceCategory.cafe:
        return AppColors.goldBg;
      case PlaceCategory.nature:
        return AppColors.greenBg;
      case PlaceCategory.museum:
        return AppColors.purpleBg;
      case PlaceCategory.restaurant:
        return AppColors.accentBg;
      case PlaceCategory.other:
        return AppColors.blueBg;
    }
  }

  static PlaceCategory fromString(String s) =>
      PlaceCategory.values.firstWhere((e) => e.name == s,
          orElse: () => PlaceCategory.other);
}

enum MoodType {
  great,
  good,
  neutral,
  bad;

  String get label {
    switch (this) {
      case MoodType.great:
        return 'Отлично';
      case MoodType.good:
        return 'Хорошо';
      case MoodType.neutral:
        return 'Нейтрально';
      case MoodType.bad:
        return 'Плохо';
    }
  }

  String get emoji {
    switch (this) {
      case MoodType.great:
        return '🤩';
      case MoodType.good:
        return '😊';
      case MoodType.neutral:
        return '😐';
      case MoodType.bad:
        return '😔';
    }
  }

  Color get color {
    switch (this) {
      case MoodType.great:
        return AppColors.green;
      case MoodType.good:
        return AppColors.gold;
      case MoodType.neutral:
        return AppColors.blue;
      case MoodType.bad:
        return AppColors.moodBad;
    }
  }

  static MoodType fromString(String s) =>
      MoodType.values.firstWhere((e) => e.name == s,
          orElse: () => MoodType.good);
}

enum WeatherType {
  sunny,
  cloudy,
  rainy,
  snowy;

  String get label {
    switch (this) {
      case WeatherType.sunny:
        return 'Солнечно';
      case WeatherType.cloudy:
        return 'Облачно';
      case WeatherType.rainy:
        return 'Дождь';
      case WeatherType.snowy:
        return 'Снег';
    }
  }

  String get emoji {
    switch (this) {
      case WeatherType.sunny:
        return '☀️';
      case WeatherType.cloudy:
        return '⛅';
      case WeatherType.rainy:
        return '🌧';
      case WeatherType.snowy:
        return '❄️';
    }
  }

  static WeatherType fromString(String s) =>
      WeatherType.values.firstWhere((e) => e.name == s,
          orElse: () => WeatherType.sunny);
}

enum CompanionType {
  alone,
  friend,
  couple,
  family;

  String get label {
    switch (this) {
      case CompanionType.alone:
        return 'Один';
      case CompanionType.friend:
        return 'С другом';
      case CompanionType.couple:
        return 'Пара';
      case CompanionType.family:
        return 'Семья';
    }
  }

  static CompanionType fromString(String s) =>
      CompanionType.values.firstWhere((e) => e.name == s,
          orElse: () => CompanionType.alone);
}
