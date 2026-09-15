import 'package:equatable/equatable.dart';

/// A single nutrient measurement for a food: the USDA nutrient [id], its
/// display [name] and [unit], and the [amount] present per 100g of the food.
///
/// `UsdaFoodModel` stores nutrients as a raw `Map<int, double>` of id to
/// amount. This class pairs those numbers with the name and unit they mean.
/// You rarely need to build one by hand — read them off a food instead:
///
/// ```dart
/// final food = await db.queryFood(id: 167512);
/// for (final nutrient in food!.nutrientList) {
///   print('${nutrient.name}: ${nutrient.amount}${nutrient.unit}');
/// }
/// ```
///
/// Names and units come from [originalNutrientTableEdit], a fixed table keyed
/// by USDA nutrient id. Every nutrient id in the shipped data is in that
/// table, so nutrients read off a food always have both. An id you supply
/// yourself that the table does not hold yields an empty [name] and [unit];
/// see [isKnown].
class UsdaNutrientModel extends Equatable {
  /// Creates a nutrient with its display [name] and [unit] already resolved.
  ///
  /// Prefer [UsdaNutrientModel.fromId], which looks both up for you.
  const UsdaNutrientModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  /// Builds a nutrient from a USDA nutrient [id] and an [amount], looking up
  /// the name and unit in [originalNutrientTableEdit].
  ///
  /// If [id] is not in the table, [name] and [unit] are empty strings rather
  /// than an error — the amount is still preserved. Check [isKnown] if you
  /// need to tell the two cases apart.
  factory UsdaNutrientModel.fromId({
    required int id,
    required double amount,
  }) {
    final entry = originalNutrientTableEdit[id];
    return UsdaNutrientModel(
      id: id,
      name: entry?['name'] ?? '',
      amount: amount,
      unit: entry?['unit'] ?? '',
    );
  }

  /// Maps a decoded JSON object to a Nutrient.
  ///
  /// Expects `{'id': int, 'amount': num}`.
  factory UsdaNutrientModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return UsdaNutrientModel.fromId(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// Builds a nutrient from a `MapEntry` whose key is a nutrient id in string
  /// form, as it appears in the raw JSON.
  ///
  /// For the `Map<int, double>` exposed by `UsdaFoodModel.nutrients`, use
  /// [UsdaNutrientModel.fromId] instead.
  ///
  /// Throws a [FormatException] if the key is not an integer.
  factory UsdaNutrientModel.fromMapEntry({
    required MapEntry<String, double> entry,
  }) =>
      UsdaNutrientModel.fromId(
        id: int.parse(entry.key),
        amount: entry.value,
      );

  /// The USDA nutrient id, e.g. `1003` for protein.
  final int id;

  /// Display name, e.g. `'Protein'`. Empty if [id] is not a known nutrient.
  final String name;

  /// Amount per 100g of the food, expressed in [unit].
  final double amount;

  /// Unit of [amount], e.g. `'g'`, `'mg'`, `'kcal'`. Empty if [id] is not a
  /// known nutrient.
  final String unit;

  /// Whether [id] was found in [originalNutrientTableEdit], and so whether
  /// [name] and [unit] are meaningful.
  bool get isKnown => originalNutrientTableEdit.containsKey(id);

  /// The display name for a USDA nutrient [id], or `null` if unknown.
  static String? nameFor(int id) => originalNutrientTableEdit[id]?['name'];

  /// The unit for a USDA nutrient [id], or `null` if unknown.
  static String? unitFor(int id) => originalNutrientTableEdit[id]?['unit'];

  @override
  String toString() => '$name: $amount$unit';

  @override
  List<Object?> get props => [id, name, amount, unit];

  /*CSpell:disable*/
  /// USDA nutrient id to its display name and unit.
  ///
  /// Some names have been changed to be more user friendly. See [nameFor] and
  /// [unitFor] for single lookups.
  static const Map<int, Map<String, String>> originalNutrientTableEdit = {
    1003: {'name': 'Protein', 'unit': 'g'},
    1004: {'name': 'Total Fat', 'unit': 'g'},
    1005: {'name': 'Total Carbohydrates', 'unit': 'g'},
    1007: {'name': 'Ash', 'unit': 'g'},
    1008: {'name': 'Calories', 'unit': 'kcal'},
    1009: {'name': 'Starch', 'unit': 'g'},
    1010: {'name': 'Sucrose', 'unit': 'g'},
    1011: {'name': 'Glucose (dextrose)', 'unit': 'g'},
    1012: {'name': 'Fructose', 'unit': 'g'},
    1013: {'name': 'Lactose', 'unit': 'g'},
    1014: {'name': 'Maltose', 'unit': 'g'},
    1018: {'name': 'Alcohol, ethyl', 'unit': 'g'},
    1051: {'name': 'Water', 'unit': 'g'},
    1057: {'name': 'Caffeine', 'unit': 'mg'},
    1058: {'name': 'Theobromine', 'unit': 'mg'},
    1075: {'name': 'Galactose', 'unit': 'g'},
    1079: {'name': 'Fiber, total dietary', 'unit': 'g'},
    1087: {'name': 'Calcium, Ca', 'unit': 'mg'},
    1089: {'name': 'Iron, Fe', 'unit': 'mg'},
    1090: {'name': 'Magnesium, Mg', 'unit': 'mg'},
    1091: {'name': 'Phosphorus, P', 'unit': 'mg'},
    1092: {'name': 'Potassium, K', 'unit': 'mg'},
    1093: {'name': 'Sodium, Na', 'unit': 'mg'},
    1095: {'name': 'Zinc, Zn', 'unit': 'mg'},
    1098: {'name': 'Copper, Cu', 'unit': 'mg'},
    1099: {'name': 'Fluoride, F', 'unit': 'ug'},
    1101: {'name': 'Manganese, Mn', 'unit': 'mg'},
    1103: {'name': 'Selenium, Se', 'unit': 'ug'},
    1104: {'name': 'Vitamin A, IU', 'unit': 'iu'},
    1105: {'name': 'Retinol', 'unit': 'ug'},
    1106: {'name': 'Vitamin A, RAE', 'unit': 'ug'},
    1107: {'name': 'Carotene, beta', 'unit': 'ug'},
    1108: {'name': 'Carotene, alpha', 'unit': 'ug'},
    1109: {'name': 'Vitamin E (alpha-tocopherol)', 'unit': 'mg'},
    1110: {'name': 'Vitamin D (D2 + D3), International Units', 'unit': 'iu'},
    1111: {'name': 'Vitamin D2 (ergocalciferol)', 'unit': 'ug'},
    1112: {'name': 'Vitamin D3 (cholecalciferol)', 'unit': 'ug'},
    1114: {'name': 'Vitamin D (D2 + D3)', 'unit': 'ug'},
    1120: {'name': 'Cryptoxanthin, beta', 'unit': 'ug'},
    1122: {'name': 'Lycopene', 'unit': 'ug'},
    1123: {'name': 'Lutein + zeaxanthin', 'unit': 'ug'},
    1125: {'name': 'Tocopherol, beta', 'unit': 'mg'},
    1126: {'name': 'Tocopherol, gamma', 'unit': 'mg'},
    1127: {'name': 'Tocopherol, delta', 'unit': 'mg'},
    1128: {'name': 'Tocotrienol, alpha', 'unit': 'mg'},
    1129: {'name': 'Tocotrienol, beta', 'unit': 'mg'},
    1130: {'name': 'Tocotrienol, gamma', 'unit': 'mg'},
    1131: {'name': 'Tocotrienol, delta', 'unit': 'mg'},
    1162: {'name': 'Vitamin C, total ascorbic acid', 'unit': 'mg'},
    1165: {'name': 'Thiamin', 'unit': 'mg'},
    1166: {'name': 'Riboflavin', 'unit': 'mg'},
    1167: {'name': 'Niacin', 'unit': 'mg'},
    1170: {'name': 'Pantothenic acid', 'unit': 'mg'},
    1175: {'name': 'Vitamin B-6', 'unit': 'mg'},
    1177: {'name': 'Folate, total', 'unit': 'ug'},
    1178: {'name': 'Vitamin B-12', 'unit': 'ug'},
    1180: {'name': 'Choline, total', 'unit': 'mg'},
    1183: {'name': 'Vitamin K (Menaquinone-4)', 'unit': 'ug'},
    1184: {'name': 'Vitamin K (Dihydrophylloquinone)', 'unit': 'ug'},
    1185: {'name': 'Vitamin K (phylloquinone)', 'unit': 'ug'},
    1186: {'name': 'Folic acid', 'unit': 'ug'},
    1187: {'name': 'Folate, food', 'unit': 'ug'},
    1190: {'name': 'Folate, DFE', 'unit': 'ug'},
    1198: {'name': 'Betaine', 'unit': 'mg'},
    1210: {'name': 'Tryptophan', 'unit': 'g'},
    1211: {'name': 'Threonine', 'unit': 'g'},
    1212: {'name': 'Isoleucine', 'unit': 'g'},
    1213: {'name': 'Leucine', 'unit': 'g'},
    1214: {'name': 'Lysine', 'unit': 'g'},
    1215: {'name': 'Methionine', 'unit': 'g'},
    1216: {'name': 'Cystine', 'unit': 'g'},
    1217: {'name': 'Phenylalanine', 'unit': 'g'},
    1218: {'name': 'Tyrosine', 'unit': 'g'},
    1219: {'name': 'Valine', 'unit': 'g'},
    1220: {'name': 'Arginine', 'unit': 'g'},
    1221: {'name': 'Histidine', 'unit': 'g'},
    1222: {'name': 'Alanine', 'unit': 'g'},
    1223: {'name': 'Aspartic acid', 'unit': 'g'},
    1224: {'name': 'Glutamic acid', 'unit': 'g'},
    1225: {'name': 'Glycine', 'unit': 'g'},
    1226: {'name': 'Proline', 'unit': 'g'},
    1227: {'name': 'Serine', 'unit': 'g'},
    1228: {'name': 'Hydroxyproline', 'unit': 'g'},
    1242: {'name': 'Vitamin E, added', 'unit': 'mg'},
    1246: {'name': 'Vitamin B-12, added', 'unit': 'ug'},
    1253: {'name': 'Cholesterol', 'unit': 'mg'},
    1257: {'name': 'Fatty acids, total trans', 'unit': 'g'},
    1258: {'name': 'Fatty acids, total saturated', 'unit': 'g'},
    1259: {'name': '4:0', 'unit': 'g'},
    1260: {'name': '6:0', 'unit': 'g'},
    1261: {'name': '8:0', 'unit': 'g'},
    1262: {'name': '10:0', 'unit': 'g'},
    1263: {'name': '12:0', 'unit': 'g'},
    1264: {'name': '14:0', 'unit': 'g'},
    1265: {'name': '16:0', 'unit': 'g'},
    1266: {'name': '18:0', 'unit': 'g'},
    1267: {'name': '20:0', 'unit': 'g'},
    1268: {'name': '18:1', 'unit': 'g'},
    1269: {'name': '18:2', 'unit': 'g'},
    1270: {'name': '18:3', 'unit': 'g'},
    1271: {'name': '20:4', 'unit': 'g'},
    1272: {'name': '22:6 n-3 (DHA)', 'unit': 'g'},
    1273: {'name': '22:0', 'unit': 'g'},
    1274: {'name': '14:1', 'unit': 'g'},
    1275: {'name': '16:1', 'unit': 'g'},
    1276: {'name': '18:4', 'unit': 'g'},
    1277: {'name': '20:1', 'unit': 'g'},
    1278: {'name': '20:5 n-3 (EPA)', 'unit': 'g'},
    1279: {'name': '22:1', 'unit': 'g'},
    1280: {'name': '22:5 n-3 (DPA)', 'unit': 'g'},
    1283: {'name': 'Phytosterols', 'unit': 'mg'},
    1285: {'name': 'Stigmasterol', 'unit': 'mg'},
    1286: {'name': 'Campesterol', 'unit': 'mg'},
    1288: {'name': 'Beta-sitosterol', 'unit': 'mg'},
    1292: {'name': 'Fatty acids, total monounsaturated', 'unit': 'g'},
    1293: {'name': 'Fatty acids, total polyunsaturated', 'unit': 'g'},
    1299: {'name': '15:0', 'unit': 'g'},
    1300: {'name': '17:0', 'unit': 'g'},
    1301: {'name': '24:0', 'unit': 'g'},
    1303: {'name': '16:1 t', 'unit': 'g'},
    1304: {'name': '18:1 t', 'unit': 'g'},
    1305: {'name': '22:1 t', 'unit': 'g'},
    1306: {'name': '18:2 t not further defined', 'unit': 'g'},
    1307: {'name': '18:2 i', 'unit': 'g'},
    1310: {'name': '18:2 t,t', 'unit': 'g'},
    1311: {'name': '18:2 CLAs', 'unit': 'g'},
    1312: {'name': '24:1 c', 'unit': 'g'},
    1313: {'name': '20:2 n-6 c,c', 'unit': 'g'},
    1314: {'name': '16:1 c', 'unit': 'g'},
    1315: {'name': '18:1 c', 'unit': 'g'},
    1316: {'name': '18:2 n-6 c,c', 'unit': 'g'},
    1317: {'name': '22:1 c', 'unit': 'g'},
    1321: {'name': '18:3 n-6 c,c,c', 'unit': 'g'},
    1323: {'name': '17:1', 'unit': 'g'},
    1325: {'name': '20:3', 'unit': 'g'},
    1329: {'name': 'Fatty acids, total trans-monoenoic', 'unit': 'g'},
    1331: {'name': 'Fatty acids, total trans-polyenoic', 'unit': 'g'},
    1332: {'name': '13:0', 'unit': 'g'},
    1333: {'name': '15:1', 'unit': 'g'},
    1404: {'name': '18:3 n-3 c,c,c (ALA)', 'unit': 'g'},
    1405: {'name': '20:3 n-3', 'unit': 'g'},
    1406: {'name': '20:3 n-6', 'unit': 'g'},
    1408: {'name': '20:4 n-6', 'unit': 'g'},
    1409: {'name': '18:3i', 'unit': 'g'},
    1410: {'name': '21:5', 'unit': 'g'},
    1411: {'name': '22:4', 'unit': 'g'},
    1412: {'name': '18:1-11 t (18:1t n-7)', 'unit': 'g'},
    2000: {'name': 'Total Sugars', 'unit': 'g'},
  };
}
