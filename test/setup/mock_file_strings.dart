// cSpell: disable

import 'dart:convert';

final String mockDBString = jsonEncode(stringKeyedMap);
final String mockHashString = jsonEncode(mockHashTable);

const mockFoodsData = {
  167512: {
    "description":
        "Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough",
    "nutrients": [
      {"id": 1003, "amount": 5.88},
      {"id": 1079, "amount": 1.2},
      {"id": 1258, "amount": 2.94},
      {"id": 1004, "amount": 13.2},
      {"id": 1005, "amount": 41.2},
      {"id": 1008, "amount": 307},
      {"id": 2000, "amount": 5.88}
    ]
  },
  167513: {
    "description": "Pillsbury, Cinnamon Rolls with Icing, refrigerated dough",
    "nutrients": [
      {"id": 1003, "amount": 4.34},
      {"id": 1079, "amount": 1.4},
      {"id": 1258, "amount": 3.25},
      {"id": 1004, "amount": 11.3},
      {"id": 1005, "amount": 53.4},
      {"id": 1008, "amount": 330},
      {"id": 2000, "amount": 21.3}
    ]
  },
  167514: {
    "description":
        "Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry",
    "nutrients": [
      {"id": 1004, "amount": 3.7},
      {"id": 1005, "amount": 79.8},
      {"id": 1008, "amount": 377},
      {"id": 1003, "amount": 6.1}
    ]
  },
  167515: {
    "description": "George Weston Bakeries, Thomas English Muffins",
    "nutrients": [
      {"id": 1258, "amount": 0.308},
      {"id": 1003, "amount": 8.0},
      {"id": 1004, "amount": 1.8},
      {"id": 1005, "amount": 46.0},
      {"id": 1008, "amount": 232}
    ]
  },
  167516: {
    "description": "Waffles, buttermilk, frozen, ready-to-heat",
    "nutrients": [
      {"id": 1258, "amount": 1.9},
      {"id": 1003, "amount": 6.58},
      {"id": 1079, "amount": 2.2},
      {"id": 1008, "amount": 273},
      {"id": 2000, "amount": 4.3},
      {"id": 1004, "amount": 9.22},
      {"id": 1005, "amount": 41.0}
    ]
  },
  167517: {
    "description": "Waffle, buttermilk, frozen, ready-to-heat, toasted",
    "nutrients": [
      {"id": 1258, "amount": 2.28},
      {"id": 1004, "amount": 9.49},
      {"id": 1005, "amount": 48.4},
      {"id": 1008, "amount": 309},
      {"id": 2000, "amount": 4.41},
      {"id": 1003, "amount": 7.42},
      {"id": 1079, "amount": 2.6}
    ]
  },
};

final Map<String, dynamic> stringKeyedMap =
    mockFoodsData.map((k, v) => MapEntry(k.toString(), v as dynamic));

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
      174528
    ],
    "3": [168454, 168455, 170528],
    "4": [174212, 174213],
    "5": [168196],
    "6": [171721],
    "7": [169400],
    "8": [167512, 167513],
    "9": [167514, 167515]
  }
};
