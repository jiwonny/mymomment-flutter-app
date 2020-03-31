import 'package:my_face_diary/models/diary_model.dart';
import 'package:sqflite/sqflite.dart';

class DiaryDatabase {
  final int maxDaysPerLoad = 30;

  /// TodoTable
  final String diaryTable = 'DAIRY_TABLE';
  final String colId = 'id';
  final String colDate = 'date';
  final String colImage1 = 'image1';
  final String colImage2 = 'image2';
  final String colImage3 = 'image3';
  final String colEmotion = 'emotion';
  final String colWeather = 'weather';
  final String colNote = 'note';


  Future<void> onCreate(Database db) async {
    await db.execute(
        "CREATE TABLE $diaryTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT," +
            "$colDate INTEGER, $colImage1 BLOB, $colImage2 BLOB, $colImage3 BLOB," +
            "$colEmotion TEXT, $colWeather TEXT, $colNote TEXT)"
    );
  }

  Future<int> onSave(Database db, DiaryModel diary)                                                                               async {
    // Return ID
    return await db.insert(diaryTable, diary.toMap());
  }

  Future<void> onDelete(Database db, int id) async {
    return await db.delete(diaryTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> onUpdate(Database db, DiaryModel diary) async {
    // Return ID
    return await db.update(diaryTable, diary.toMap(),
      where: '$colId = ?',
      whereArgs: [diary.id]
    );
  }

  Future<void> getAllDiaries(Database db) async {
    final res = await db.query(diaryTable);
    for (int j = 0; j < res.length; j++){
       print(res[j]);
    }
  }


  Future<List<DiaryModel>> getDiaries(Database db, {int year, int month}) async {
    if( year == null || month == null ){
      List<Map> maps= await db.query(diaryTable,
        orderBy: colDate,
      );

      return maps.map((map) => DiaryModel.fromMap(map)).toList();
    } else {
      final upperDateTime = DateTime(year, month + 1);
      final lowerDateTime = DateTime(year, month);

      List<Map> maps= await db.query(diaryTable,
        where: '$colDate < ? AND $colDate >= ?',
        whereArgs: [upperDateTime.microsecondsSinceEpoch, lowerDateTime.microsecondsSinceEpoch],
        orderBy: '$colDate ASC',
        limit: maxDaysPerLoad,
      );
      return maps.map((map) => DiaryModel.fromMap(map)).toList();
    }
  }

  Future<List<DiaryModel>> getDiaryWithId(Database db, int id) async {
    try{
      List<Map> maps = await db.query(diaryTable,
        where: '$colId = ?',
        whereArgs: [id],
      );
      return maps.map((map) => DiaryModel.fromMap(map)).toList();
    }catch(error){
      print('get Diary with Id ::: $error');
      return null;
    }

  }
}


