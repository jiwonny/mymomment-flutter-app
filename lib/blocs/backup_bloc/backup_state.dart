import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_face_diary/models/diary_model.dart';

class BackupState {
  final List<DiaryModel> diaries;

  final bool isInitializing;
  final bool isLoading;
  final bool isUploading;
  final bool loadSuccess;
  final bool loadFailure;
  final bool uploadSuccess;
  final bool uploadFailure;


  BackupState({
    @required this.diaries,
    @required this.isInitializing,
    @required this.isLoading,
    @required this.isUploading,
    @required this.loadSuccess,
    @required this.loadFailure,
    @required this.uploadSuccess,
    @required this.uploadFailure
  });


  factory BackupState.initializing(){
    return BackupState(
        diaries: [],
        isInitializing: true,
        isLoading: false,
        isUploading: false,
        loadSuccess: false,
        loadFailure: false,
        uploadSuccess: false,
        uploadFailure: false
    );
  }

  factory BackupState.loaded(List<DiaryModel> diaries){
    print('backupstate loaded ::: ${diaries.length}');
    return BackupState(
        diaries: diaries ?? [],
        isInitializing: false,
        isLoading: false,
        isUploading: false,
        loadSuccess: diaries == null ? false : true,
        loadFailure: diaries == null ? true : false,
        uploadSuccess: false,
        uploadFailure: false
    );
  }

  factory BackupState.uploaded(bool isSuccess){
    return BackupState(
      diaries: [],
      isInitializing: false,
      isLoading: false,
      isUploading: false,
      loadSuccess: false,
      loadFailure: false,
      uploadSuccess: isSuccess ? true : false,
      uploadFailure: isSuccess ? false : true
    );
  }


  BackupState update({
    bool isInitializing,
    bool isLoading,
    bool isUploading,
    bool loadSuccess,
    bool loadFailure,
    bool uploadSuccess,
    bool uploadFailure
  }){
    return copyWith(
        isInitializing: isInitializing,
        isLoading: isLoading,
        isUploading: isUploading,
        loadSuccess: loadSuccess,
        loadFailure: loadFailure,
        uploadSuccess: uploadSuccess,
        uploadFailure: uploadFailure
    );
  }

  BackupState copyWith({
    List<DiaryModel> diaries,
    bool isInitializing,
    bool isLoading,
    bool isUploading,
    bool loadSuccess,
    bool loadFailure,
    bool uploadSuccess,
    bool uploadFailure

  }){
    return BackupState(
        diaries: diaries ?? this.diaries,
        isInitializing: isInitializing ?? this.isInitializing,
        isLoading: isLoading ?? this.isLoading,
        isUploading: isUploading ?? this.isUploading,
        loadSuccess: loadSuccess ?? this.loadSuccess,
        loadFailure: loadFailure ?? this.loadFailure,
        uploadSuccess: uploadSuccess ?? this.uploadSuccess,
        uploadFailure: uploadFailure ?? this.uploadFailure
    );
  }

  @override
  String toString() {
    return 'BackupState{isInitializing: $isInitializing, isLoading: $isLoading, isUploading: $isUploading, loadSuccess: $loadSuccess, loadFailure: $loadFailure, uploadSuccess: $uploadSuccess, uploadFailure: $uploadFailure}';
  }

}
