import 'package:drift/drift.dart';

import '../db/circle_database.dart';

class CircleDbService {
  CircleDbService(this.db);
  final CircleDatabase db;
  Future<List<Circle>> getAllCircle() async {
    final data = await db.circles.select().get();

    return data;
  }
}
