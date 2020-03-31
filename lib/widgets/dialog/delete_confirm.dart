import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/utils/database/database_helper.dart';
import 'package:toast/toast.dart';

class DeleteConfirm extends StatelessWidget {
  final DiaryModel diaryModel;

  DeleteConfirm(this.diaryModel);

  @override
  Widget build(BuildContext context) {
    return  CupertinoAlertDialog(
        title: Text("카드를 삭제하시겠습니까?"),
        actions: [
          continueButton(context),
          cancelButton(context),
        ],
      );
  }

  // set up the buttons
  Widget cancelButton(BuildContext context){
    return  CupertinoDialogAction(
      child: Text("취소", style: TextStyle(color: Colors.black),),
      isDefaultAction: true,
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context){
    return CupertinoDialogAction(
      child: Text("확인"),
      isDefaultAction: true,
      isDestructiveAction: true,
      onPressed:  () async{
        final deletedDiary = diaryModel;
        final diaryDate = diaryModel.date;

        final deleteSuccess = await confirmDeleteDiary(context, diaryModel.id);
        if(deleteSuccess){
          BlocProvider.of<DiaryBloc>(context).add(DeleteDiary(diaryDate.year, diaryDate.month, deletedDiary.copyWith(id: deletedDiary.id)));
          Navigator.of(context).pop();
        }
      }
    );
  }

  Future<bool> confirmDeleteDiary(BuildContext context, int id) async{
    final helper = DiaryDBHelper();
    try{
      await helper.deleteDiary(id);
      Toast.show('삭제되었습니다.', context, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return true;
    }catch(error){
      Toast.show('삭제 실패 : $error', context, duration: Toast.LENGTH_LONG);
      return false;
    }


  }
}

