import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/sync_bloc/bloc.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/repositories/user_repository.dart';

class SyncScreen extends StatelessWidget {
  final DiaryRepository diaryRepository = DiaryRepository();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SyncBloc(diaryRepository: diaryRepository, userRepository: userRepository),
      child: Scaffold(
        body: Container(
          child: Center(
              child: BlocBuilder<SyncBloc, SyncState>(
                builder: (context, state) {
                  if(state.isInitializing){
                    return RaisedButton(
                      child: Text('동기화하기'),
                      onPressed: () => addLoadEvent(context),
                    );
                  }else if (state.isLoading){
                    return Text('기존 diary 불러오는 중');
                  }else if (state.loadSuccess){
                    addSyncEvent(context, state.diaries);
                    return Text('기존 diary 불러오기 성공');
                  }else if (state.loadFailure){
                    return Text('기존 diary 불러오기 실패');
                  }else if (state.isDownloading){
                    return Text('다운로드 중');
                  }else if (state.downloadSuccess){
                    addAddDiariesEvent(context, state.downloaded);
                    return Text('다운로드 성공');
                  }else if (state.downloadFailure){
                    return Text('다운로드 실패');
                  } else{
                    return Text('실험');
                  }
                },
              )
          ),
        ),
      ),
    );
  }



  void addLoadEvent(BuildContext context) async{
    if(await userRepository.isSignedIn()){
      final currentUser = await userRepository.currentUser();
      final userUid = currentUser.uid;
      BlocProvider.of<SyncBloc>(context).add(LoadStarted(userUid));
    }
  }

  void addSyncEvent(BuildContext context, List diaries) async{
    if(await userRepository.isSignedIn()){
      final currentUser = await userRepository.currentUser();
      final userUid = currentUser.uid;
      BlocProvider.of<SyncBloc>(context).add(SyncStarted(userUid, diaries));
    }
  }

  void addAddDiariesEvent(BuildContext context, List downloaded) async {
    for(DiaryModel diary in downloaded){
      final _date = diary.date;
      BlocProvider.of<DiaryBloc>(context).add(AddDiaries(_date.year, _date.month, diary));
    }
  }


}
