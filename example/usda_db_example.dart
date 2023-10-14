import 'package:usda_db_package/usda_db_package.dart';

void main() async {
  final db = DB();
  db.dispose();
  await db.init();
  //
  final des = await db.getDescriptions('apple');
  print(des.length);
}
