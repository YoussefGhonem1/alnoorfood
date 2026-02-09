
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class SQLHelper {

  static SQLHelper? dbHelper;
  static Database? _database;
  int oldVersion = 1,newVersion = 2;
  SQLHelper._createInstance();

  factory SQLHelper() {
    dbHelper ??= SQLHelper._createInstance();
    return dbHelper!;
  }

  String tableName = "cart_product";

  Future<Database> get database async {
    _database ??= await initializedDatabase();
    return _database!;
  }


  Future<Database> initializedDatabase() async {

    late String path;
    if(Platform.isIOS){
      String directory = await getDatabasesPath();
      path = p.join(directory,"cart_v2.db");
    }else{
      Directory directory = await getApplicationDocumentsDirectory();
      path = "${directory.path}cart_v2.db";
    }

    var studentDB = await openDatabase(path, version: 2, onCreate: createDatabase);
    return studentDB;
  }


  void createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER, name TEXT,brand TEXT,weight TEXT, description TEXT, price DOUBLE,"
            " count INTEGER, image TEXT, showPrice INTEGER,taxEntity VARCHAR(1000))");
  }
}
