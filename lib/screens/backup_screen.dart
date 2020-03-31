import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_face_diary/blocs/backup_bloc/bloc.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/repositories/user_repository.dart';

class BackupScreen extends StatelessWidget {
  static const routeName = '/backup';
  final DiaryRepository diaryRepository = DiaryRepository();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BackupBloc(diaryRepository: diaryRepository, userRepository: userRepository),
      child: Scaffold(
        body: Container(
          child: Center(
            child: BlocBuilder<BackupBloc, BackupState>(
              builder: (context, state) {
                //TODO: state 에 맞게 화면 로딩 변화
                if(state.isInitializing){
                  return RaisedButton(
                    child: Text('백업하기'),
                    onPressed: () => addLoadEvent(context),
                  );
                }else if (state.isLoading){
                  return Text('불러오는 중');
                }else if (state.loadSuccess){
                  addBackupEvent(context, state.diaries);
                  return Text('불러오기 성공');
                }else if (state.loadFailure){
                  return Text('불러오기 실패');
                }else if (state.isUploading){
                  return Container(
                      color: Colors.lightBlue,
                      child: Center(
                        child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink),
                      ));
                }else if (state.uploadSuccess){
                  return Text('업로드 성공');
                }else if (state.uploadFailure){
                  return Text('업로드 실패');
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
      BlocProvider.of<BackupBloc>(context).add(LoadStarted(userUid));
    }
  }

  void addBackupEvent(BuildContext context, List diaries) async{
    if(await userRepository.isSignedIn()){
      final currentUser = await userRepository.currentUser();
      final userUid = currentUser.uid;
      BlocProvider.of<BackupBloc>(context).add(BackupStarted(userUid, diaries));
    }
  }


}
