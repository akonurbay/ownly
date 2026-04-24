import '../domain/entities/place.dart';
import '../domain/entities/visit.dart';
import '../domain/entities/enums.dart';

final seedPlaces = <Place>[
  Place(
    id: 'p1',
    name: 'Кофейня «Утро»',
    description: 'Уютное место с отличным эспрессо и видом на парк',
    category: PlaceCategory.cafe,
    city: 'Москва',
    createdAt: DateTime.now().subtract(const Duration(days: 400)),
    isFavorite: true,
  ),
  Place(
    id: 'p2',
    name: 'Парк Горького',
    description: 'Лучшее место для утренних прогулок и пикников',
    category: PlaceCategory.nature,
    city: 'Москва',
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    isFavorite: false,
  ),
  Place(
    id: 'p3',
    name: 'Третьяковская галерея',
    description: 'Русское искусство XIX века, зал Репина — просто шедевр',
    category: PlaceCategory.museum,
    city: 'Москва',
    createdAt: DateTime.now().subtract(const Duration(days: 380)),
    isFavorite: true,
  ),
  Place(
    id: 'p4',
    name: 'Ресторан «Пушкин»',
    description: 'Классическая русская кухня в историческом особняке',
    category: PlaceCategory.restaurant,
    city: 'Москва',
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
    isFavorite: false,
  ),
  Place(
    id: 'p5',
    name: 'Смотровая на Воробьёвых',
    description: 'Лучший вид на Москву на закате',
    category: PlaceCategory.other,
    city: 'Москва',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    isFavorite: true,
  ),
];

final seedVisits = <Visit>[
  // p1 — год назад
  Visit(
    id: 'v1',
    placeId: 'p1',
    mood: MoodType.great,
    weather: WeatherType.sunny,
    companion: CompanionType.alone,
    note: 'Идеальное утро. Капучино, книга и солнце в окне.',
    visitedAt: DateTime.now().subtract(const Duration(days: 365)),
  ),
  Visit(
    id: 'v2',
    placeId: 'p1',
    mood: MoodType.good,
    weather: WeatherType.cloudy,
    companion: CompanionType.friend,
    note: 'Встреча с Антоном, обсудили много всего.',
    visitedAt: DateTime.now().subtract(const Duration(days: 120)),
  ),
  Visit(
    id: 'v3',
    placeId: 'p1',
    mood: MoodType.good,
    weather: WeatherType.rainy,
    companion: CompanionType.alone,
    note: 'Дождь снаружи — уют внутри.',
    visitedAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  // p2
  Visit(
    id: 'v4',
    placeId: 'p2',
    mood: MoodType.great,
    weather: WeatherType.sunny,
    companion: CompanionType.couple,
    note: 'Весенний парк, цветёт сирень.',
    visitedAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Visit(
    id: 'v5',
    placeId: 'p2',
    mood: MoodType.good,
    weather: WeatherType.sunny,
    companion: CompanionType.alone,
    note: 'Пробежка. 5 км без остановок.',
    visitedAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  // p3 — год назад
  Visit(
    id: 'v6',
    placeId: 'p3',
    mood: MoodType.great,
    weather: WeatherType.cloudy,
    companion: CompanionType.friend,
    note: 'Зал Врубеля — стоял долго у «Демона».',
    visitedAt: DateTime.now().subtract(const Duration(days: 363)),
  ),
  // p4
  Visit(
    id: 'v7',
    placeId: 'p4',
    mood: MoodType.great,
    weather: WeatherType.snowy,
    companion: CompanionType.couple,
    note: 'Ужин по поводу годовщины. Незабываемо.',
    visitedAt: DateTime.now().subtract(const Duration(days: 50)),
  ),
  // p5
  Visit(
    id: 'v8',
    placeId: 'p5',
    mood: MoodType.great,
    weather: WeatherType.sunny,
    companion: CompanionType.alone,
    note: 'Закат над городом. Оранжевое небо.',
    visitedAt: DateTime.now().subtract(const Duration(days: 29)),
  ),
  Visit(
    id: 'v9',
    placeId: 'p5',
    mood: MoodType.neutral,
    weather: WeatherType.cloudy,
    companion: CompanionType.friend,
    note: 'Пасмурно, но всё равно красиво.',
    visitedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
