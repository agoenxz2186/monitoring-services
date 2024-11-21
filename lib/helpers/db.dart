 
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DB{
  static DB ? _instance;
  static DB get instance => _instance ??= DB._();
  static Database? _db;

  DB._(){
    if(_db == null){
    
    }
         
  }

  Future<Database?> connection()async {
    if(DB._db == null){
        final _conn = await databaseFactoryFfi.openDatabase("db.db",
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) {
            db.execute("""
              CREATE TABLE services(
                id INTEGER PRIMARY KEY,
                url TEXT,
                servicename TEXT,
                description TEXT,
                ipserver TEXT,
                port TEXT,
                username TEXT,
                password TEXT,
                container_name TEXT,
                created_at TEXT,
                updated_at TEXT
              )
            """);

              db.execute("""
              CREATE TABLE settings(
                name TEXT PRIMARY KEY,
                nilai TEXT, 
                created_at TEXT,
                updated_at TEXT
              )
            """);

          },
        )
      );

      DB._db = _conn;
      return _conn;
    }

    return DB._db;
  }
}