import 'package:usda_db/usda_db.dart';

void main() async {
  final db = DB();
  db.dispose();
  await db.init();
  final food = db.getFood('167512');
  print(food);

  db.dispose();
  try {
    print(db.getFood('167512'));
  } catch (e) {
    print(e);
  }
}
