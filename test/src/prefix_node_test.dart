import 'package:test/test.dart';
import 'package:usda_db/src/prefix_node.dart';

void main() {
  group('PTNode class tests', () {
    group('Constructor tests - ', () {
      test('creates PTNode with default values returns values with all null',
          () {
        final node = PTNode();
        expect(node.key, isNull);
        expect(node.left, isNull);
        expect(node.right, isNull);
        expect(node.middle, isNull);
        expect(node.isEnd, false);
      });

      test('creates PTNode with specified values creates correctly', () {
        final node = PTNode(key: 'a', isEnd: true);
        expect(node.key, 'a');
        expect(node.isEnd, true);
      });
    });

    group('fromJson() - ', () {
      test('deserializes from valid JSON has correct node values', () {
        final json = {'key': 'a', 'isEnd': true};
        final node = PTNode.fromJson(json);
        expect(node.key, 'a');
        expect(node.isEnd, true);
        expect(node.middle, isNull);
      });

      // test('deserializes from invalid JSON throws', () {
      //   final json = {'invalid_key': 'a'};
      //   expect(() => PTNode.fromJson(json), throwsException);
      // });
    });
  });
}
