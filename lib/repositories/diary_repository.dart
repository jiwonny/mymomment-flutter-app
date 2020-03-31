import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/utils/database/database_helper.dart';
import 'package:my_face_diary/utils/database/diary_database.dart';

class DiaryRepository {
  final dbHelper = DiaryDBHelper();
  final diaryDatabase = DiaryDatabase();

  Future<List<DiaryModel>> getAllDiaries() async{
    try {
      final database = await dbHelper.database;
      return diaryDatabase.getDiaries(database);
    }catch(error){
      print('get all diaries error ::: $error');
      return null;
    }

  }

  Future<List<DiaryModel>> getDiaries(int year, int month) async{
    try{
      final database = await dbHelper.database;
      print('get diaries function in repo');
      return diaryDatabase.getDiaries(database, year: year, month: month);

    }catch(error){
      print("get Diaries in repo : " + error);
      return null;
    }

  }

  Future<List<DiaryModel>> getDiaryWithId(int id) async{
    try{
      final database = await dbHelper.database;
      return diaryDatabase.getDiaryWithId(database, id);
    }catch(error){
      print('get diary in repo : $error');
      return null;
    }
  }


  Future<DiaryModel> downloadImage(DiaryModel diary, String uid) async {
    final imageSize = 10000000;
    StorageReference storageReference = FirebaseStorage().ref().child('Diaries').child(uid);
    Uint8List image1Url;
    Uint8List image2Url;
    Uint8List image3Url;

    if(diary.image1 != null){
      StorageReference ref = storageReference.child('${diary.docId}_1');
      image1Url = await ref.getData(imageSize);
    }

    if(diary.image2 != null){
      StorageReference ref = storageReference.child('${diary.docId}_2');
      image2Url = await ref.getData(imageSize);
    }

    if(diary.image3 != null){
      StorageReference ref = storageReference.child('${diary.docId}_3');
      image3Url = await ref.getData(imageSize);
    }

    return diary.copyWith(image1: image1Url, image2: image2Url, image3: image3Url);
  }

}
