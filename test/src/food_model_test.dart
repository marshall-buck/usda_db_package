import 'package:test/test.dart';
import 'package:usda_db_package/src/food_model.dart';

void main() {
  group('Food Model class tests', () {
    group('Constructor tests - ', () {
      test('creates Food with default values', () {
        final food = FoodModel(
            id: 'id', description: 'description', descriptionLength: 0);
        expect(food.id, 'id');
        expect(food.description, 'description');
        expect(food.descriptionLength, 0);
        expect(food.protein, isNull);
        expect(food.dietaryFiber, isNull);
        expect(food.satFat, isNull);
        expect(food.totCarb, isNull);
        expect(food.totFat, isNull);
        expect(food.totSugars, isNull);
        expect(food.calories, isNull);
      });

      test('creates PTNode with specified values creates correctly', () {
        final food = FoodModel(
            id: 'id',
            description: 'description',
            descriptionLength: 10,
            protein: 1,
            dietaryFiber: 1,
            satFat: 1,
            totCarb: 1,
            calories: 1,
            totFat: 1,
            totSugars: 1);
        expect(food.id, 'id');
        expect(food.description, 'description');
        expect(food.descriptionLength, 10);
        expect(food.protein, 1);
        expect(food.dietaryFiber, 1);
        expect(food.satFat, 1);
        expect(food.totCarb, 1);
        expect(food.totFat, 1);
        expect(food.totSugars, 1);
        expect(food.calories, 1);
      });
    });

    group('fromJson() - ', () {
      test('deserializes from valid JSON has correct node values', () {
        final json = {
          "id": "167513",
          "description":
              "Pillsbury, Cinnamon Rolls with Icing, refrigerated dough",
          "descriptionLength": 56,
          "protein": 4.34,
          "dietaryFiber": 1.4,
          "satFat": 3.25,
          "totFat": 11.3,
          "totCarb": 53.4,
          "calories": 330,
          "totSugars": 21.3
        };

        final food = FoodModel.fromJson(json);
        expect(food.id, "167513");
        expect(food.description,
            "Pillsbury, Cinnamon Rolls with Icing, refrigerated dough");
        expect(food.descriptionLength, 56);
        expect(food.protein, 4.34);
        expect(food.dietaryFiber, 1.4);
        expect(food.satFat, 3.25);
        expect(food.totFat, 11.3);
        expect(food.totCarb, 53.4);
        expect(food.calories, 330);
        expect(food.totSugars, 21.3);
      });

      test('serializes toJson ', () {
        final food = FoodModel(
            id: 'id',
            description: 'description',
            descriptionLength: 10,
            protein: 1,
            dietaryFiber: 1,
            satFat: 1,
            totCarb: 1,
            calories: 1,
            totFat: 1,
            totSugars: 1);

        final json = {
          "id": "id",
          "description": "description",
          "descriptionLength": 10,
          "protein": 1,
          "dietaryFiber": 1,
          "satFat": 1,
          "totFat": 1,
          "totCarb": 1,
          "calories": 1,
          "totSugars": 1
        };
        expect(food.toJson(), json);
      });
    });
  });
}
