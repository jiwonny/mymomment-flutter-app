import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState>{
  final DiaryRepository _diaryRepository;

  DiaryBloc({@required DiaryRepository diaryRepository})
      : assert(diaryRepository != null),
        _diaryRepository = diaryRepository;

  @override
  DiaryState get initialState => DiaryState.unInitialized();

  @override
  Stream<DiaryState> mapEventToState(DiaryEvent event,) async* {
    if(event is HomeScreenStarted){
      yield* _mapHomeScreenStartedToState(event.year, event.month);
    }else if(event is LoadOtherDiaries){
      yield* _mapLoadOtherDiariesToState(event.year, event.month);
    }else if(event is AddDiaries) {
      yield* _mapAddDiariesToState(event.year, event.month, event.diaryModel);
    }else if(event is EditDiary) {
      yield* _mapEditDiaryToState(event.diaryModel);
    }else if(event is DeleteDiary){
      yield* _mapDeleteDiaryToState(event.year, event.month, event.diaryModel);
    }
  }

  Stream<DiaryState> _mapHomeScreenStartedToState(int year,
      int month) async* {
    print('mapHomeScreenStartedToState');
    yield state.update(selectedYear: year,
        selectedMonth: month,
        isInitializing: false,
        isLoading: true,
        isFailure: false,
        isSuccess: false);
    final diaries=await _diaryRepository.getDiaries(year, month);
    try {
      yield DiaryState.loaded(diaries, year, month);
    } catch (error) {
      print('mapHomeScreenStartedToStateError: ');
      print(error);
      yield DiaryState.loaded(null, year, month);
    }
  }

  Stream <DiaryState> _mapLoadOtherDiariesToState(int year, int month) async* {
    yield* _mapHomeScreenStartedToState(year, month);
  }

  Stream <DiaryState> _mapAddDiariesToState(int year, int month, DiaryModel diaryModel) async* {
    try {
      if (diaryModel != null) {
        state.addDiary(diaryModel);
        yield state.update(
            isLoading: false, isSuccess: true, isFailure: false);
      } else {
        yield state.update(
            isLoading: false, isSuccess: false, isFailure: true);
      }
    } catch (error) {
      print('add diaries error ::: $error');
      yield state.update(isLoading: false, isSuccess: false, isFailure: true);
    }
  }

  Stream <DiaryState> _mapDeleteDiaryToState(int year, int month, DiaryModel diaryModel) async* {
    yield state.update(isInitializing: false,
        isLoading: true,
        isFailure: false,
        isSuccess: false);

    try {
      if (diaryModel != null) {
        state.deleteDiary(diaryModel);
        yield state.update(isLoading: false, isSuccess: true, isFailure: false);
      } else {
        yield state.update(isLoading: false, isSuccess: false, isFailure: true);
      }
    } catch (error) {
      print('delete diary error ::: $error');
      yield state.update(isLoading: false, isSuccess: false, isFailure: true);
    }
  }


  Stream<DiaryState> _mapEditDiaryToState(DiaryModel diaryModel) async* {
    try {
      List<DiaryModel> diaries=state.replaceDiary(diaryModel);
      yield state.copyWith(diaries: diaries,
          isLoading: false,
          isSuccess: true,
          isFailure: false);
    } catch (error) {
      print('edit diaru error ::: $error');
      yield state.update(isLoading: false, isSuccess: false, isFailure: true);
    }
  }

}


