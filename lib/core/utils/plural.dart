String pluralRu(int n, String one, String few, String many) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  if (mod10 == 1 && mod100 != 11) return one;
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) return few;
  return many;
}

String visitWord(int n) => pluralRu(n, 'визит', 'визита', 'визитов');

String placeWord(int n) => pluralRu(n, 'место', 'места', 'мест');
