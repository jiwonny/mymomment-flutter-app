import 'package:flutter/material.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/screens/diary_detail_screen.dart';
import 'package:my_face_diary/screens/diary_edit_screen.dart';
import 'package:my_face_diary/screens/sync_screen.dart';

Future<DiaryModel> moveToEditDiaryScreen(BuildContext context, {DiaryModel diaryModel}) async{
  DiaryModel newDiary;

  newDiary = await Navigator.push(context, MaterialPageRoute(builder: (context){
    return DiaryEditScreen(diaryModel: diaryModel);
  }));

  return newDiary;
}

void moveToDiaryDetailScreen(BuildContext context, DiaryModel diaryModel){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return DiaryDetailScreen(diaryModel);
  }));
}

void moveToSyncScreen(BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return SyncScreen();
  }));
}