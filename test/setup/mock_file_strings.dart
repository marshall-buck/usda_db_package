// cSpell: disable

// ignore_for_file: prefer_single_quotes

import "dart:convert";

final String mockDBString = jsonEncode(mockKJsonString);
final String mockHashString = jsonEncode(mockHashTable);

const mockFoodsData = {
  167512: {
    "description":
        "Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough",
    "nutrients": {
      1003: 5.88,
      1079: 1.2,
      1258: 2.94,
      1004: 13.2,
      1005: 41.2,
      1008: 307,
      2000: 5.88,
    },
  },
  167513: {
    "description": "Pillsbury, Cinnamon Rolls with Icing, refrigerated dough",
    "nutrients": {
      1003: 4.34,
      1079: 1.4,
      1258: 3.25,
      1004: 11.3,
      1005: 53.4,
      1008: 330,
      2000: 21.3,
    },
  },
  167514: {
    "description":
        "Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry",
    "nutrients": {
      1004: 3.7,
      1005: 79.8,
      1008: 377,
      1003: 6.1,
    },
  },
  167515: {
    "description": "George Weston Bakeries, Thomas English Muffins",
    "nutrients": {
      1258: 0.308,
      1003: 8.0,
      1004: 1.8,
      1005: 46.0,
      1008: 232,
    },
  },
  167516: {
    "description": "Waffles, buttermilk, frozen, ready-to-heat",
    "nutrients": {
      1258: 1.9,
      1003: 6.58,
      1079: 2.2,
      1008: 273,
      2000: 4.3,
      1004: 9.22,
      1005: 41.0,
    },
  },
  167517: {
    "description": "Waffle, buttermilk, frozen, ready-to-heat, toasted",
    "nutrients": {
      1258: 2.28,
      1004: 9.49,
      1005: 48.4,
      1008: 309,
      2000: 4.41,
      1003: 7.42,
      1079: 2.6,
    },
  },
};

final Map<String, dynamic> mockKJsonString = mockFoodsData.map((k, v) {
  final nutrients = (v['nutrients']! as Map<int, dynamic>).map(
    (key, value) => MapEntry(key.toString(), value),
  );
  return MapEntry(
    k.toString(),
    {'description': v['description'], 'nutrients': nutrients},
  );
});

const mockHashTable = {
  "substringHash": {
    "aab": 0,
    "aan": 1,
    "aba": 2,
    "abag": 3,
    "abaga": 3,
    "abagas": 3,
    "abal": 4,
    "abalo": 4,
    "abalon": 4,
    "abalone": 4,
    "aban": 5,
    "abana": 5,
    "abap": 6,
    "abapp": 6,
    "abappl": 6,
    "abapple": 6,
    "abapples": 6,
    "abar": 7,
    "ill": 8,
    "ake": 9,
    "dough": 9,
  },
  "indexHash": {
    "0": [167512, 167513, 167515],
    "1": [171845, 174077],
    "2": [
      168196,
      168454,
      168455,
      169093,
      169232,
      169233,
      169353,
      169400,
      170528,
      171428,
      171721,
      174212,
      174213,
      174528,
    ],
    "3": [168454, 168455, 170528],
    "4": [174212, 174213],
    "5": [168196],
    "6": [171721],
    "7": [169400],
    "8": [167512, 167513],
    "9": [167514, 167515],
  },
};
