import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String databaseName = 'engeo.db';
  
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Get the directory for the app's documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);

    // Check if the database exists
    bool dbExists = await File(path).exists();

    if (!dbExists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", filePath));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // Open the database
    return await openDatabase(path, readOnly: true); // Dictionary is read-only
  }

  // Search queries migrated from WordlistAdapter.java
  Future<List<Map<String, dynamic>>> searchEnglish(String query) async {
    final db = await instance.database;
    const sql = '''
      SELECT t1.id as _id, t1.eng as original, t1.transcription, group_concat(t2.geo, ', ') as translate, t4.name as type_name, group_concat(t4.abbr, ', ') as abbr 
      FROM eng t1, geo t2, geo_eng t3, types t4 
      WHERE t1.eng >= ? AND t3.eng_id=t1.id AND t2.id=t3.geo_id AND t4.id=t1.type 
      GROUP BY t1.eng 
      LIMIT 25
    ''';
    return await db.rawQuery(sql, [query.toLowerCase().trim()]);
  }

  Future<List<Map<String, dynamic>>> searchGeorgian(String query) async {
    final db = await instance.database;
    const sql = '''
      SELECT t2.id as _id, group_concat(t1.eng, ', ') as translate, t1.transcription, t2.geo as original, t4.name as type_name, t4.abbr 
      FROM eng t1, geo t2, geo_eng t3, types t4 
      WHERE t2.geo >= ? AND t3.eng_id=t1.id AND t2.id=t3.geo_id AND t4.id=t2.type 
      GROUP BY t2.geo 
      LIMIT 25
    ''';
    return await db.rawQuery(sql, [query.trim()]);
  }
}
