// cSpell: disable
const testTree = '''
{
    "root": {
        "key": "a",
        "isEnd": false,
        "left": null,
        "middle": {
            "key": "l",
            "isEnd": false,
            "left": null,
            "middle": {
                "key": "i",
                "isEnd": true,
                "left": null,
                "middle": {
                    "key": "c",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "e",
                        "isEnd": true,
                        "left": null,
                        "middle": null,
                        "right": null
                    },
                    "right": null
                },
                "right": null
            },
            "right": {
                "key": "n",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "n",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "a",
                        "isEnd": true,
                        "left": null,
                        "middle": null,
                        "right": null
                    },
                    "right": null
                },
                "right": null
            }
        },
        "right": {
            "key": "e",
            "isEnd": false,
            "left": null,
            "middle": {
                "key": "l",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "i",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "a",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "s",
                            "isEnd": true,
                            "left": null,
                            "middle": null,
                            "right": null
                        },
                        "right": {
                            "key": "z",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "a",
                                "isEnd": true,
                                "left": null,
                                "middle": null,
                                "right": null
                            },
                            "right": null
                        }
                    },
                    "right": null
                },
                "right": null
            },
            "right": null
        }
    }
}
''';
const testIndex = '''
{
    "abalone": [
        "174212",
        "174213"
    ],
    "abbott": [
        "167727",
        "168971",
        "170988",
        "171382",
        "171383",
        "171384",
        "171395",
        "171396",
        "171397",
        "171399",
        "172307",
        "172310",
        "172312",
        "172313",
        "172318",
        "172323",
        "172324",
        "172325",
        "172326",
        "173167",
        "173541",
        "173542",
        "173543",
        "173546",
        "173550",
        "173558",
        "173559",
        "173560",
        "173561",
        "174813",
        "174823"
    ],
    "abiyuch": [
        "167782"
    ],
    "acai": [
        "173175",
        "174170"
    ],
    "acerola": [
        "171686",
        "171687"
    ],
    "acid": [
        "167771",
        "167772",
        "167775",
        "167784",
        "167800",
        "168185",
        "168186",
        "168187",
        "168188",
        "168197",
        "168198",
        "168207",
        "169117",
        "169691",
        "169940",
        "169947",
        "170862",
        "170885",
        "170944",
        "170945",
        "170946",
        "170983",
        "171262",
        "171264",
        "171281",
        "171339",
        "171377",
        "171695",
        "171704",
        "171870",
        "171918",
        "172950",
        "173041",
        "173042",
        "173933",
        "173934",
        "173935",
        "174301"
    ],
    "fake": [
        "174212"
    ]
}
''';

const testDB = '''
{
    "167512": {
        "description": "Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough",
        "descriptionLength": 81,
        "Protein": 5.88,
        "Dietary Fiber": 1.2,
        "Saturated Fat": 2.94,
        "Total Fat": 13.2,
        "Total Carbs": 41.2,
        "Calories": 307,
        "Total Sugars": 5.88
    },
    "167513": {
        "description": "Pillsbury, Cinnamon Rolls with Icing, refrigerated dough",
        "descriptionLength": 56,
        "Protein": 4.34,
        "Dietary Fiber": 1.4,
        "Saturated Fat": 3.25,
        "Total Fat": 11.3,
        "Total Carbs": 53.4,
        "Calories": 330,
        "Total Sugars": 21.3
    },
    "167514": {
        "description": "Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry",
        "descriptionLength": 64,
        "Total Fat": 3.7,
        "Total Carbs": 79.8,
        "Calories": 377,
        "Protein": 6.1
    },
    "167515": {
        "description": "George Weston Bakeries, Thomas English Muffins",
        "descriptionLength": 46,
        "Saturated Fat": 0.308,
        "Protein": 8.0,
        "Total Fat": 1.8,
        "Total Carbs": 46.0,
        "Calories": 232
    },
    "167516": {
        "description": "Waffles, buttermilk, frozen, ready-to-heat",
        "descriptionLength": 42,
        "Saturated Fat": 1.9,
        "Protein": 6.58,
        "Dietary Fiber": 2.2,
        "Calories": 273,
        "Total Sugars": 4.3,
        "Total Fat": 9.22,
        "Total Carbs": 41.0
    }
}
''';
const testHashTable = '''
{
   "substrings": {
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
        "abar": 7

        },

         "indexHash": {
        "0": [
            "170381",
            "170382"
        ],
        "1": [
            "171845",
            "174077"
        ],
        "2": [
            "168196",
            "168454",
            "168455",
            "169093",
            "169232",
            "169233",
            "169353",
            "169400",
            "170528",
            "171428",
            "171721",
            "174212",
            "174213",
            "174528"
        ],
        "3": [
            "168454",
            "168455",
            "170528"
        ],
        "4": [
            "174212",
            "174213"
        ],
        "5": [
            "168196"
        ],
        "6": [
            "171721"
        ],
        "7": [
            "169400"
        ]

      }

  }



''';
