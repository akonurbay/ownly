# Ownly — Refactor Plan: выравнивание под medetas/template

Цель — привести структуру проекта в соответствие с шаблоном **medetas/template**, сохранив текущий стек (Riverpod, Hive, Firebase, image/geo пакеты).

## Что остаётся без изменений

- **State management:** `flutter_riverpod` + `StateNotifier` (в шаблоне BLoC — не мигрируем)
- **Хранилище:** `hive_flutter` (в шаблоне Drift — не мигрируем)
- **Папка:** `presentation/providers/` (в шаблоне `presentation/blocs/` — не переименовываем)
- **Дополнительные фичи:** Firebase Auth, image_picker, image_cropper, share_plus, geolocator, geocoding, google_fonts, uuid

## Что добавляется (по шаблону)

Полные слои Clean Architecture + общие core-папки:

- `core/constants/` — строковые константы, ключи Hive, маршруты, ключи SharedPreferences
- `core/utils/` — хелперы (плюрализация, форматтеры дат, парсеры)
- `core/widgets/` — переиспользуемые низкоуровневые виджеты (OwnlyLogo)
- `data/models/` — DTO для Hive с `toJson` / `fromJson` (вынесем из entities)
- `data/repositories/` — конкретные реализации репозиториев на базе `LocalStorage`
- `domain/repositories/` — абстрактные интерфейсы репозиториев
- `domain/usecases/` — бизнес-операции, инкапсулирующие сценарии

---

## Целевая структура

```
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
│
├── core/
│   ├── constants/
│   │   ├── app_strings.dart            # русские заголовки/тексты
│   │   ├── storage_keys.dart           # 'places', 'visits', 'settings', 'darkTheme', ...
│   │   └── route_paths.dart            # /, /onboarding, /auth, /place/:id, ...
│   ├── router/
│   │   └── app_router.dart             # ← без изменений
│   ├── theme/
│   │   ├── app_colors.dart             # ← без изменений
│   │   ├── app_text_styles.dart        # ← без изменений
│   │   └── app_theme.dart              # ← без изменений
│   ├── utils/
│   │   ├── plural.dart                 # «визит/визита/визитов» → из place_card.dart
│   │   ├── date_format.dart            # форматирование дат для Time Machine / истории визитов
│   │   └── geo_helpers.dart            # обёртки для geocoding/geolocator
│   └── widgets/
│       └── ownly_logo.dart             # ← перенести из presentation/widgets/
│
├── domain/
│   ├── entities/
│   │   ├── enums.dart                  # ← без изменений
│   │   ├── place.dart                  # очистить от toJson/fromJson
│   │   └── visit.dart                  # очистить от toJson/fromJson
│   ├── repositories/
│   │   ├── place_repository.dart       # abstract class
│   │   ├── visit_repository.dart       # abstract class
│   │   └── settings_repository.dart    # abstract class
│   └── usecases/
│       ├── places/
│       │   ├── get_places.dart
│       │   ├── add_place.dart
│       │   ├── toggle_favorite.dart
│       │   ├── delete_place_with_visits.dart
│       │   └── get_place_by_id.dart
│       ├── visits/
│       │   ├── get_visits.dart
│       │   ├── add_visit.dart
│       │   ├── get_visits_for_place.dart
│       │   └── delete_visits_for_place.dart
│       ├── settings/
│       │   ├── get_settings.dart
│       │   ├── toggle_dark_theme.dart
│       │   ├── toggle_time_machine_notifs.dart
│       │   └── toggle_gps.dart
│       └── export/
│           └── export_all_data.dart    # из LocalStorage.exportAll
│
├── data/
│   ├── datasources/
│   │   └── local_storage.dart          # ← переехать из data/local/
│   ├── models/
│   │   ├── place_model.dart            # extends Place + JSON-сериализация
│   │   └── visit_model.dart            # extends Visit + JSON-сериализация
│   ├── repositories/
│   │   ├── place_repository_impl.dart
│   │   ├── visit_repository_impl.dart
│   │   └── settings_repository_impl.dart
│   └── seed_data.dart                  # ← без изменений
│
└── presentation/
    ├── providers/
    │   ├── places_provider.dart        # вызывает usecases вместо LocalStorage
    │   ├── settings_provider.dart      # вызывает usecases вместо LocalStorage
    │   └── repository_providers.dart   # DI: provider → repository → usecase
    ├── widgets/
    │   ├── place_card.dart             # использует core/utils/plural.dart
    │   └── visit_card.dart             # ← без изменений
    └── screens/                        # ← без изменений
        ├── add_place/
        ├── analytics/
        ├── auth/
        ├── home/
        ├── main_shell.dart
        ├── onboarding/
        ├── place_detail/
        ├── settings/
        └── time_machine/
```

---

## Слой-за-слоем: что и как переносим

### 1. `core/constants/`

Создать три файла:

- **`storage_keys.dart`** — вынести из `local_storage.dart` (`_placesBox`, `_visitsBox`, `_settingsBox`) + ключи настроек (`darkTheme`, `timeMachineNotifs`, `gpsEnabled`)
- **`route_paths.dart`** — вынести из `app_router.dart` все строковые пути
- **`app_strings.dart`** — собрать русские строки из экранов (опционально, можно постепенно)

### 2. `core/utils/`

- **`plural.dart`** — функция `visitsWord(int n)` (текущий `_visitWord` в `place_card.dart:149`)
- **`date_format.dart`** — хелперы вида «год назад», «месяц назад» для Time Machine
- **`geo_helpers.dart`** — обёртка над `geolocator`/`geocoding` (если используется в `add_place_screen`)

### 3. `core/widgets/`

- Переместить `presentation/widgets/ownly_logo.dart` → `core/widgets/ownly_logo.dart`
- `place_card.dart` и `visit_card.dart` оставить в `presentation/widgets/` — они зависят от entities/providers (feature-level)

### 4. `domain/repositories/` (абстрактные интерфейсы)

```dart
// place_repository.dart
abstract class PlaceRepository {
  List<Place> getAll();
  Future<void> save(Place place);
  Future<void> delete(String id);
  Place? getById(String id);
}

// visit_repository.dart
abstract class VisitRepository {
  List<Visit> getAll();
  Future<void> save(Visit visit);
  Future<void> deleteForPlace(String placeId);
}

// settings_repository.dart
abstract class SettingsRepository {
  bool getBool(String key, {bool defaultValue = false});
  Future<void> setBool(String key, bool value);
  Map<String, dynamic> exportAll();
}
```

### 5. `domain/usecases/`

Тонкие классы — один use case = один метод `call()`. Берут репозиторий через конструктор. Например:

```dart
class TogglePlaceFavorite {
  final PlaceRepository repo;
  TogglePlaceFavorite(this.repo);

  Future<void> call(String id) async {
    final place = repo.getById(id);
    if (place == null) return;
    await repo.save(place.copyWith(isFavorite: !place.isFavorite));
  }
}
```

Список use case'ов — см. целевую структуру выше.

### 6. `data/datasources/`

- Переместить `data/local/local_storage.dart` → `data/datasources/local_storage.dart`
- Удалить пустую папку `data/local/`
- Заменить хардкод имён боксов на константы из `core/constants/storage_keys.dart`

### 7. `data/models/`

Вынести JSON-логику из entities в models. Entity становится «чистой» (без знаний о JSON), модель наследует entity и добавляет сериализацию:

```dart
// data/models/place_model.dart
class PlaceModel extends Place {
  const PlaceModel({...}) : super(...);

  factory PlaceModel.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
  factory PlaceModel.fromEntity(Place p) => PlaceModel(...);
}
```

### 8. `data/repositories/`

Конкретные реализации — обёртка над `LocalStorage` + конвертация Model ↔ Entity:

```dart
class PlaceRepositoryImpl implements PlaceRepository {
  @override
  List<Place> getAll() => LocalStorage.getPlaces(); // через PlaceModel.fromJson
  ...
}
```

### 9. `presentation/providers/`

Создать новый файл `repository_providers.dart` — точка DI:

```dart
final placeRepositoryProvider = Provider<PlaceRepository>((ref) => PlaceRepositoryImpl());
final addPlaceUseCaseProvider = Provider((ref) => AddPlace(ref.watch(placeRepositoryProvider)));
// ...
```

`PlacesNotifier` / `VisitsNotifier` / `SettingsNotifier` принимают use case'ы через конструктор и вызывают их вместо прямых обращений к `LocalStorage`.

---

## Порядок миграции (коммиты)

Каждый шаг — отдельный коммит, проект остаётся в рабочем состоянии после каждого.

1. **`refactor: extract storage keys and route paths to core/constants/`**
   - Создать `core/constants/storage_keys.dart`, `core/constants/route_paths.dart`
   - Заменить хардкод в `local_storage.dart` и `app_router.dart`

2. **`refactor: extract shared utils to core/utils/`**
   - Создать `core/utils/plural.dart`, `date_format.dart`
   - Заменить `_visitWord` в `place_card.dart`

3. **`refactor: move OwnlyLogo to core/widgets/`**
   - Переместить файл, обновить импорты в screens

4. **`refactor: move local_storage to data/datasources/`**
   - Переместить + обновить импорты в `places_provider.dart`, `settings_provider.dart`, `seed_data.dart`

5. **`refactor: extract data models with JSON serialization`**
   - Создать `data/models/place_model.dart`, `visit_model.dart`
   - Очистить `place.dart` и `visit.dart` от `toJson` / `fromJson`
   - `LocalStorage` использует модели для (де)сериализации

6. **`feat: add domain repository interfaces`**
   - Создать абстракции в `domain/repositories/`

7. **`feat: add data repository implementations`**
   - Создать `data/repositories/*_impl.dart`

8. **`feat: add domain usecases`**
   - Создать use case'ы в `domain/usecases/<feature>/`

9. **`refactor: wire usecases into providers via DI`**
   - Создать `presentation/providers/repository_providers.dart`
   - `PlacesNotifier` / `VisitsNotifier` / `SettingsNotifier` переходят на use case'ы
   - Прямые вызовы `LocalStorage` остаются только в repository implementations

10. **`docs: update PLAN.md to reflect new architecture`**
    - Обновить дерево в `PLAN.md` под новую структуру

---

## Чек-лист соответствия шаблону по завершении

- [x] `core/router/`, `core/theme/` (уже есть)
- [ ] `core/constants/` (новое)
- [ ] `core/utils/` (новое)
- [ ] `core/widgets/` (новое)
- [ ] `data/datasources/` (переименование `data/local/`)
- [ ] `data/models/` (новое)
- [ ] `data/repositories/` (новое)
- [x] `domain/entities/` (уже есть)
- [ ] `domain/repositories/` (новое)
- [ ] `domain/usecases/` (новое)
- [x] `presentation/screens/` (уже есть)
- [x] `presentation/widgets/` (уже есть)
- [x] `presentation/providers/` (свой эквивалент `presentation/blocs/` шаблона)

---

## Что НЕ соответствует шаблону и остаётся таковым (осознанно)

| Аспект | Шаблон | Ownly | Причина |
|---|---|---|---|
| State management | BLoC | Riverpod | Сохраняем по решению пользователя |
| База данных | Drift | Hive | Сохраняем по решению пользователя |
| `presentation/blocs/` | есть | `presentation/providers/` | Аналог под Riverpod |
| HTTP-клиент | `dio` | — | В Ownly нет сетевых вызовов (Firebase Auth — свой SDK) |

---

## Оценка трудозатрат

| Шаг | Файлов затронуто | Сложность |
|---|---|---|
| 1. constants | 3 новых, 2 правки | низкая |
| 2. utils | 2–3 новых, 1 правка | низкая |
| 3. core/widgets | 1 перенос, ~3 правки импортов | низкая |
| 4. datasources | 1 перенос, 3 правки импортов | низкая |
| 5. models | 2 новых, 2 entities урезать, 1 правка LocalStorage | средняя |
| 6. domain/repositories | 3 новых файла | низкая |
| 7. data/repositories | 3 новых файла | средняя |
| 8. usecases | ~13 новых файлов | средняя (механика, не логика) |
| 9. DI + providers | 1 новый, 2 переписать | средняя |
| **Итого** | ~35 новых, ~10 правок | **2–3 рабочих сессии** |
