import 'package:monitoring_service/helpers/db.dart';

class Model{
  String _table = "";

  Future<int?> insert(Map<String, dynamic> data) async {
      final conn = await DB.instance.connection();
      return await conn?.insert(_table, data);
  }

  Future update(Map<String, dynamic> data) async {
      final conn = await DB.instance.connection();
      return await conn?.update(_table, data);
  }

  Future delete(String where, List whereArgs)async{
    final conn = await DB.instance.connection();
    return await conn?.delete(_table, where: where, whereArgs: whereArgs);
  }
}