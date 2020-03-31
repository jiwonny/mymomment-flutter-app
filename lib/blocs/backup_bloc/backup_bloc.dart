import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/repositories/user_repository.dart';
import 'bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState>{
  final DiaryRepository _diaryRepository;
  final UserRepository _userRepository;

  BackupBloc({@required DiaryRepository diaryRepository, @required UserRepository userRepository})
      : assert(diaryRepository != null),
        _diaryRepository = diaryRepository,
        _userRepository = userRepository;

  @override
  BackupState get initialState => BackupState.initializing();

  @override
  Stream<BackupState> mapEventToState(BackupEvent event,) async* {
    if(event is LoadStarted){
      yield* _mapLoadStartedToState(event.uid);
    }else if(event is BackupStarted){
      yield* _mapBackupStartedToState(event.uid, event.diaries);
    }
//    else if(event is BackupStopped) {
//      yield* _mapBackupStoppedToState(event.uid);
//    }
  }

  Stream<BackupState> _mapLoadStartedToState(String uid) async* {
    print('mapBackupStartedToState');
    yield state.update(isInitializing: false, isLoading: true, loadFailure: false, loadSuccess: false, uploadFailure: false, uploadSuccess: false);

    try {
      final diaries = await _diaryRepository.getAllDiaries();
      yield BackupState.loaded(diaries);
    } catch (error) {
      print('mapLoadStartedToState error ::: $error');
      yield BackupState.loaded(null);
    }
  }

  Stream<BackupState> _mapBackupStartedToState(String uid, List diaries) async* {
    print('mapBackupStartedToState');
    yield state.update(isInitializing: false, isLoading: false, isUploading: true, loadFailure: false, loadSuccess: false, uploadFailure: false, uploadSuccess: false);

    final currentUser = await _userRepository.currentUser();
    final userUid = currentUser.uid;
    final CollectionReference userCollection = Firestore.instance.collection(userUid);

    try{
      List<Future> futures = [];
      for(DiaryModel diary in diaries){
        final dateRef = userCollection.document();
        final String docId = dateRef.documentID;
        final imageUrl1 = diary.image1 == null ? null : await diary.uploadImage(diary.image1, '${docId}_1', userUid);
        final imageUrl2 = diary.image2 == null ? null : await diary.uploadImage(diary.image2, '${docId}_2', userUid);
        final imageUrl3 = diary.image3 == null ? null : await diary.uploadImage(diary.image3, '${docId}_3', userUid);
        futures.add(dateRef.setData(diary.toDocument(imageUrl1, imageUrl2, imageUrl3)));
      }
      await Future.wait(futures);

      yield BackupState.uploaded(true);

    }catch(error){
      print('mapBackupStartedToState $error');
      yield BackupState.uploaded(false);
    }
  }

}