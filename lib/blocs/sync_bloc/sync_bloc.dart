import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/repositories/user_repository.dart';
import 'package:my_face_diary/utils/database/database_helper.dart';
import 'package:my_face_diary/widgets/diary_widgets/icons.dart';
import 'bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState>{
  final DiaryRepository _diaryRepository;
  final UserRepository _userRepository;

  SyncBloc({@required DiaryRepository diaryRepository, @required UserRepository userRepository})
      : assert(diaryRepository != null),
        _diaryRepository = diaryRepository,
        _userRepository = userRepository;

  @override
  SyncState get initialState => SyncState.initializing();

  @override
  Stream<SyncState> mapEventToState(SyncEvent event,) async* {
    if(event is LoadStarted){
      yield* _mapLoadStartedToState(event.uid);
    }else if(event is SyncStarted){
      yield* _mapSyncStartedToState(event.uid, event.diaries);
    }
//    else if(event is SyncStopped) {
//      yield* _mapSyncStoppedToState(event.uid);
//    }
  }

  Stream<SyncState> _mapLoadStartedToState(String uid) async* {
    print('mapLoadStartedToState');
    yield state.update(isInitializing: false, isLoading: true, loadFailure: false, loadSuccess: false, downloadFailure: false, downloadSuccess: false);

    try {
      final diaries = await _diaryRepository.getAllDiaries();
      yield SyncState.loaded(diaries);
    } catch (error) {
      print('mapLoadStartedToState error ::: $error');
      yield SyncState.loaded(null);
    }
  }


  Stream<SyncState> _mapSyncStartedToState(String uid, List diaries) async* {
    print('mapSyncStartedToState');
    yield state.update(isInitializing: false, isLoading: false, isDownloading: true, loadFailure: false, loadSuccess: false, downloadFailure: false, downloadSuccess: false);

    final currentUser = await _userRepository.currentUser();
    final userUid = currentUser.uid;
    final CollectionReference userCollection = Firestore.instance.collection(userUid);
    final helper = DiaryDBHelper();
    final urlModifiedDiaries = List<DiaryModel>();

    try{
      print('get diaries from usercollection(firebase)');
      QuerySnapshot querySnapshot = await userCollection.getDocuments();
      List<DocumentSnapshot> documents = querySnapshot.documents;

      if(documents.isNotEmpty) {
        final downloadedDiaries = documents.map((doc) => DiaryModel.fromSnapshot(doc)).toList();
        for(DiaryModel diary in diaries){
          for(DiaryModel downloaded in downloadedDiaries){
            if(diary.date == downloaded.date){
              downloadedDiaries.remove(downloaded);
              break;
            }
          }
        }

        for(DiaryModel diary in downloadedDiaries) {
          urlModifiedDiaries.add(await _diaryRepository.downloadImage(diary, userUid));
        }

        await helper.saveDiaries(urlModifiedDiaries);

      } else {
        print('empty documents');
      }

      yield SyncState.downloaded(true, urlModifiedDiaries);

    }catch(error){
      print('mapSyncStartedToState $error');
      yield SyncState.downloaded(false, []);
    }
  }
}