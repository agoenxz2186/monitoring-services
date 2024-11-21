import 'package:monitoring_service/helpers/db.dart';

class Model{
  String _table = "";

  String get table => _table;

  Future<int> insert(Map<String, dynamic> data, {bool autoIncrement=true, String columnPK="id"}) async {
 
    try{
      final conn = await DB.instance.connection();
      if(autoIncrement){
        data[columnPK] = await nextID(columnPK);
      }
      return await conn?.insert(table, data) ?? 0;
    }catch(e){}
    return -1;
  }

  Future<int> nextID([String column = "id"]) async {
    try{
      final conn = await DB.instance.connection();
      final result = await conn?.rawQuery("SELECT MAX($column) + 1 AS id FROM $table") ?? [];
      if(result.isEmpty)return 1;

      return int.tryParse('${result[0][column]}')  ?? 1;
    }catch(e){}
    return 1;
  }

  Future<int> update(Map<String, dynamic> data, {String? where, List whereArgs = const []}) async {
    try{
         print("update $data where $where $whereArgs");
      final conn = await DB.instance.connection();
      return await conn?.update(table, data, where: where, whereArgs: whereArgs) ?? 0;
    }catch(e){}
    return -1;
  }

  Future<int> delete(String where, List whereArgs)async{
    try{
      final conn = await DB.instance.connection();
      return await conn?.delete(table, where: where, whereArgs: whereArgs) ?? 0;
    }catch(e){}
    return -1;
  }

  Future<List<Map<String, Object?>>> get({List<String>? columns, String? where, List whereArgs = const [], 
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset})async{

    final conn = await DB.instance.connection();
    return await conn?.query(table, columns: columns,
      where: where, whereArgs: whereArgs,
      limit: limit,
      offset: offset, groupBy: groupBy, having: having, orderBy: orderBy
    ) ?? [];
  }
}