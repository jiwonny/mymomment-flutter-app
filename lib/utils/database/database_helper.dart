import 'dart:io';

import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/utils/database/diary_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DiaryDBHelper {
  static DiaryDBHelper _databaseHelper; //Singleton databaseHelper
  static Database _database; //Singleton utils.database
  static DiaryDatabase _diaryDatabase = DiaryDatabase();

  final _lock=new Lock();

  /// MyFaceDiary Database Name
  final String dbNAME='diary.db';

  DiaryDBHelper._createInstance();

  factory DiaryDBHelper(){
    if (_databaseHelper == null) {
      _databaseHelper=DiaryDBHelper._createInstance(); // Execute only once to make singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
        _database = await initDatabase();
    }

    return _database;
  }

  Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path= join(databasesPath, dbNAME);
    print(path);

//    deleteDatabase(path);

    try {
      await Directory(dirname(path)).create(recursive: true);
    }catch(error){
      print('initDatabase error: $error');
    }

    try{
      var db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await _diaryDatabase.onCreate(db);
        }
      );
      print('db open ? ${db.isOpen}');
      return db;
    }catch(error){
      print(error);
    }

  }

  Future<int> saveDiary(DiaryModel diary) async {
    try{
      return await DiaryDatabase().onSave(await database, diary);
    } catch (error) {
      print('error ::: $error');
      return -1;
    }
  }

  Future<void> saveDiaries(List<DiaryModel> diaries) async {
    try{
      for(DiaryModel diary in diaries){
        saveDiary(diary);
      }
    }catch(error){
      print('save diaries error::: $error');
    }
  }

  Future<void> deleteDiary(int id) async {
    return await _diaryDatabase.onDelete(await database, id);
  }

  Future<void> updateDiary(DiaryModel diary) async {
    return await _diaryDatabase.onUpdate(await database, diary);
  }

  Future<void> readDiary() async {
    return await _diaryDatabase.getAllDiaries(await database);
  }

  @override
  String toString() {
    final a = _databaseHelper == null;
    final b = _database == null;
    return 'db: $dbNAME' + a.toString() + "," + b.toString() ;
  }

}