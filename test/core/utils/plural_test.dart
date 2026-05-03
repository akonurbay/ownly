import 'package:flutter_test/flutter_test.dart';
import 'package:ownly/core/utils/plural.dart';

void main() {
  group('pluralRu', () {
    test('форма "one" для чисел, оканчивающихся на 1 (кроме 11)', () {
      expect(pluralRu(1, 'визит', 'визита', 'визитов'), 'визит');
      expect(pluralRu(21, 'визит', 'визита', 'визитов'), 'визит');
      expect(pluralRu(101, 'визит', 'визита', 'визитов'), 'визит');
    });

    test('форма "few" для чисел, оканчивающихся на 2-4 (кроме 12-14)', () {
      expect(pluralRu(2, 'визит', 'визита', 'визитов'), 'визита');
      expect(pluralRu(3, 'визит', 'визита', 'визитов'), 'визита');
      expect(pluralRu(4, 'визит', 'визита', 'визитов'), 'визита');
      expect(pluralRu(22, 'визит', 'визита', 'визитов'), 'визита');
      expect(pluralRu(103, 'визит', 'визита', 'визитов'), 'визита');
    });

    test('форма "many" для чисел, оканчивающихся на 0, 5-9', () {
      expect(pluralRu(0, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(5, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(9, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(10, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(20, 'визит', 'визита', 'визитов'), 'визитов');
    });

    test('исключение: числа 11-14 всегда форма "many"', () {
      expect(pluralRu(11, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(12, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(13, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(14, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(111, 'визит', 'визита', 'визитов'), 'визитов');
      expect(pluralRu(114, 'визит', 'визита', 'визитов'), 'визитов');
    });
  });

  group('visitWord и placeWord', () {
    test('visitWord возвращает корректные формы', () {
      expect(visitWord(1), 'визит');
      expect(visitWord(3), 'визита');
      expect(visitWord(7), 'визитов');
    });

    test('placeWord возвращает корректные формы', () {
      expect(placeWord(1), 'место');
      expect(placeWord(2), 'места');
      expect(placeWord(5), 'мест');
    });
  });
}
