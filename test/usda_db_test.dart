import 'package:test/test.dart';
import 'package:usda_db_package/usda_db.dart';

void main() {
  group('DB Class Tests', () {
    group('init()', () {
      test('populates structures', () async {
        final db = DB();

        expect(() async => await db.init(), returnsNormally);
      });
    });
  });
}
