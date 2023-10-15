import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('DB Class Tests', () {
    group('init()', () {
      test('should not throw', () async {
        final db = DB();

        expect(() async => await db.init(), returnsNormally);
        expect(() => db.getFood('index'), returnsNormally);
      });
    });
  });
}
