const mocDB = '''
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
    },
    "167517": {
        "description": "Waffle, buttermilk, frozen, ready-to-heat, toasted",
        "descriptionLength": 50,
        "Saturated Fat": 2.28,
        "Total Fat": 9.49,
        "Total Carbs": 48.4,
        "Calories": 309,
        "Total Sugars": 4.41,
        "Protein": 7.42,
        "Dietary Fiber": 2.6
    }
}
''';

const mocWordIndex = '''
{
    "artificial": [
        "167512"
    ],
    "bake": [
        "167514"
    ],
    "bakeries": [
        "167515"
    ],
    "biscuits": [
        "167512"
    ],
    "buttermilk": [
        "167516",
        "167517",
        "167512"
    ],
    "cinnamon": [
        "167513"
    ],
    "coating": [
        "167514"
    ],
    "dough": [
        "167513",
        "167512"
    ],
    "dry": [
        "167514"
    ],
    "english": [
        "167515"
    ],
    "flavor": [
        "167512"
    ],
    "foods": [
        "167514"
    ],
    "frozen": [
        "167516",
        "167517"
    ],
    "george": [
        "167515"
    ],
    "golden": [
        "167512"
    ],
    "heat": [
        "167516",
        "167517"
    ],
    "icing": [
        "167513"
    ],
    "kraft": [
        "167514"
    ],
    "layer": [
        "167512"
    ],
    "muffins": [
        "167515"
    ],
    "original": [
        "167514"
    ],
    "pillsbury": [
        "167513",
        "167512"
    ],
    "pork": [
        "167514"
    ],
    "ready": [
        "167516",
        "167517"
    ],
    "recipe": [
        "167514"
    ],
    "refrigerated": [
        "167513",
        "167512"
    ],
    "rolls": [
        "167513"
    ],
    "shake": [
        "167514"
    ],
    "thomas": [
        "167515"
    ],
    "toasted": [
        "167517"
    ],
    "waffle": [
        "167517"
    ],
    "waffles": [
        "167516"
    ],
    "weston": [
        "167515"
    ]
}
''';

const mocTree = '''
{
    "root": {
        "key": "k",
        "isEnd": false,
        "left": {
            "key": "a",
            "isEnd": false,
            "left": null,
            "middle": {
                "key": "r",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "t",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "i",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "f",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "i",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "c",
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
                                                "key": "l",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": null
                    },
                    "right": null
                },
                "right": null
            },
            "right": {
                "key": "b",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "a",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "k",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "e",
                            "isEnd": true,
                            "left": null,
                            "middle": {
                                "key": "r",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "i",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "e",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "s",
                                            "isEnd": true,
                                            "left": null,
                                            "middle": null,
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": null
                    },
                    "right": {
                        "key": "i",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "s",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "c",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "u",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "i",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "t",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "s",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": {
                            "key": "u",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "t",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "t",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "e",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "r",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "m",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "i",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "l",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "k",
                                                            "isEnd": true,
                                                            "left": null,
                                                            "middle": null,
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        }
                    }
                },
                "right": {
                    "key": "c",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "i",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "n",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "n",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "a",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "m",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "n",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": {
                            "key": "o",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "a",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "t",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "i",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "n",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "g",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        }
                    },
                    "right": {
                        "key": "d",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "o",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "u",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "g",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "h",
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
                                "key": "r",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "y",
                                    "isEnd": true,
                                    "left": null,
                                    "middle": null,
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
                                "key": "n",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "g",
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
                                                "key": "s",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "h",
                                                    "isEnd": true,
                                                    "left": null,
                                                    "middle": null,
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": {
                                "key": "f",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "l",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "a",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "v",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "o",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "r",
                                                    "isEnd": true,
                                                    "left": null,
                                                    "middle": null,
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": {
                                        "key": "o",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "d",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "s",
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
                                            "key": "r",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "o",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "z",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "e",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "n",
                                                            "isEnd": true,
                                                            "left": null,
                                                            "middle": null,
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        }
                                    }
                                },
                                "right": {
                                    "key": "g",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "e",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "r",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "g",
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
                                            "right": null
                                        },
                                        "right": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "l",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "d",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "e",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "n",
                                                            "isEnd": true,
                                                            "left": null,
                                                            "middle": null,
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        }
                                    },
                                    "right": {
                                        "key": "h",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "e",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "a",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "t",
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
                                            "key": "i",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "c",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "i",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "n",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "g",
                                                            "isEnd": true,
                                                            "left": null,
                                                            "middle": null,
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        "middle": {
            "key": "r",
            "isEnd": false,
            "left": null,
            "middle": {
                "key": "a",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "f",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "t",
                        "isEnd": true,
                        "left": null,
                        "middle": null,
                        "right": null
                    },
                    "right": null
                },
                "right": null
            },
            "right": null
        },
        "right": {
            "key": "l",
            "isEnd": false,
            "left": null,
            "middle": {
                "key": "a",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "y",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "e",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "r",
                            "isEnd": true,
                            "left": null,
                            "middle": null,
                            "right": null
                        },
                        "right": null
                    },
                    "right": null
                },
                "right": null
            },
            "right": {
                "key": "m",
                "isEnd": false,
                "left": null,
                "middle": {
                    "key": "u",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "f",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "f",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "i",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "n",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "s",
                                        "isEnd": true,
                                        "left": null,
                                        "middle": null,
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": null
                    },
                    "right": null
                },
                "right": {
                    "key": "o",
                    "isEnd": false,
                    "left": null,
                    "middle": {
                        "key": "r",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "i",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "g",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "i",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "n",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "a",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "l",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": null
                        },
                        "right": null
                    },
                    "right": {
                        "key": "p",
                        "isEnd": false,
                        "left": null,
                        "middle": {
                            "key": "i",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "l",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "l",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "s",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "b",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "u",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "r",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "y",
                                                        "isEnd": true,
                                                        "left": null,
                                                        "middle": null,
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                },
                                "right": null
                            },
                            "right": {
                                "key": "o",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "r",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "k",
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
                            "key": "r",
                            "isEnd": false,
                            "left": null,
                            "middle": {
                                "key": "e",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "a",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "d",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "y",
                                            "isEnd": true,
                                            "left": null,
                                            "middle": null,
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": {
                                        "key": "c",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "i",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "p",
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
                                            "key": "f",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "r",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "i",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "g",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "e",
                                                            "isEnd": false,
                                                            "left": null,
                                                            "middle": {
                                                                "key": "r",
                                                                "isEnd": false,
                                                                "left": null,
                                                                "middle": {
                                                                    "key": "a",
                                                                    "isEnd": false,
                                                                    "left": null,
                                                                    "middle": {
                                                                        "key": "t",
                                                                        "isEnd": false,
                                                                        "left": null,
                                                                        "middle": {
                                                                            "key": "e",
                                                                            "isEnd": false,
                                                                            "left": null,
                                                                            "middle": {
                                                                                "key": "d",
                                                                                "isEnd": true,
                                                                                "left": null,
                                                                                "middle": null,
                                                                                "right": null
                                                                            },
                                                                            "right": null
                                                                        },
                                                                        "right": null
                                                                    },
                                                                    "right": null
                                                                },
                                                                "right": null
                                                            },
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        }
                                    }
                                },
                                "right": {
                                    "key": "o",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "l",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "l",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "s",
                                                "isEnd": true,
                                                "left": null,
                                                "middle": null,
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": null
                                    },
                                    "right": null
                                }
                            },
                            "right": {
                                "key": "s",
                                "isEnd": false,
                                "left": null,
                                "middle": {
                                    "key": "h",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "a",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "k",
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
                                    "right": null
                                },
                                "right": {
                                    "key": "t",
                                    "isEnd": false,
                                    "left": null,
                                    "middle": {
                                        "key": "h",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "m",
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
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        },
                                        "right": {
                                            "key": "o",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "a",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "s",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "t",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "e",
                                                            "isEnd": false,
                                                            "left": null,
                                                            "middle": {
                                                                "key": "d",
                                                                "isEnd": true,
                                                                "left": null,
                                                                "middle": null,
                                                                "right": null
                                                            },
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": null
                                        }
                                    },
                                    "right": {
                                        "key": "w",
                                        "isEnd": false,
                                        "left": null,
                                        "middle": {
                                            "key": "a",
                                            "isEnd": false,
                                            "left": null,
                                            "middle": {
                                                "key": "f",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "f",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "l",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "e",
                                                            "isEnd": true,
                                                            "left": null,
                                                            "middle": {
                                                                "key": "s",
                                                                "isEnd": true,
                                                                "left": null,
                                                                "middle": null,
                                                                "right": null
                                                            },
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            },
                                            "right": {
                                                "key": "e",
                                                "isEnd": false,
                                                "left": null,
                                                "middle": {
                                                    "key": "s",
                                                    "isEnd": false,
                                                    "left": null,
                                                    "middle": {
                                                        "key": "t",
                                                        "isEnd": false,
                                                        "left": null,
                                                        "middle": {
                                                            "key": "o",
                                                            "isEnd": false,
                                                            "left": null,
                                                            "middle": {
                                                                "key": "n",
                                                                "isEnd": true,
                                                                "left": null,
                                                                "middle": null,
                                                                "right": null
                                                            },
                                                            "right": null
                                                        },
                                                        "right": null
                                                    },
                                                    "right": null
                                                },
                                                "right": null
                                            }
                                        },
                                        "right": null
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
''';
