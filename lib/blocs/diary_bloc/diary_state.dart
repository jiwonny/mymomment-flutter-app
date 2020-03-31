import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_face_diary/models/diary_model.dart';

class DiaryState {
  final List<DiaryModel> diaries;

  final int selectedYear;
  final int selectedMonth;
  final bool isInitializing;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;


  DiaryState({
    @required this.diaries,
    @required this.selectedYear,
    @required this.selectedMonth,
    @required this.isInitializing,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory DiaryState.unInitialized(){
    return DiaryState(
      diaries: [],
      selectedYear: DateTime.now().year,
      selectedMonth: DateTime.now().month,
      isInitializing: false,
      isLoading: false,
      isSuccess: false,
      isFailure: false
    );
  }

  factory DiaryState.initializing(){
    return DiaryState(
        diaries: [],
        selectedYear: DateTime.now().year,
        selectedMonth: DateTime.now().month,
        isInitializing: true,
        isLoading: false,
        isSuccess: false,
        isFailure: false
    );
  }


  factory DiaryState.loaded(List<DiaryModel> diaries, int year, int month, ){
    print('loaded state: ' + diaries.length.toString());
    return DiaryState(
        diaries: diaries ?? [],
        selectedYear: year,
        selectedMonth: month,
        isInitializing: false,
        isLoading: false,
        isSuccess: diaries == null ? false : true,
        isFailure: diaries == null ? true : false
    );
  }

  List<DiaryModel> replaceDiary(DiaryModel diaryModel){
    return this.diaries.map((d) => d.id == diaryModel.id ? diaryModel : d).toList();
  }


  void addDiaries(List<DiaryModel> diaries){
    this.diaries.addAll(diaries);
  }

  void addDiary(DiaryModel diary){
    this.diaries.add(diary);
  }

  void deleteDiary(DiaryModel diary){
    this.diaries.removeWhere((d)=> d.id == diary.id);
  }

  DiaryState update({
    int selectedYear,
    int selectedMonth,
    bool isInitializing,
    bool isLoading,
    bool isSuccess,
    bool isFailure
  }){
    return copyWith(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        isInitializing: isInitializing,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure
    );
  }

  DiaryState copyWith({
    List<DiaryModel> diaries,
    int selectedYear,
    int selectedMonth,
    bool isInitializing,
    bool isLoading,
    bool isSuccess,
    bool isFailure
  }){
    return DiaryState(
        diaries: diaries ?? this.diaries,
        selectedYear: selectedYear ?? this.selectedYear,
        selectedMonth: selectedMonth ?? this.selectedMonth,
        isInitializing: isInitializing ?? this.isInitializing,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure
    );
  }

  @override
  String toString() {
    return 'DiaryState{selectedYear: $selectedYear, selectedMonth: $selectedMonth, isInitializing: $isInitializing, isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure}';
  }

}
