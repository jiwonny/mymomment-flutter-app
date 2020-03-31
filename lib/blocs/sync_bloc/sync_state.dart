import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_face_diary/models/diary_model.dart';

class SyncState {
  final List<DiaryModel> diaries;
  final List<DiaryModel> downloaded;

  final bool isInitializing;
  final bool isLoading;
  final bool isDownloading;
  final bool loadSuccess;
  final bool loadFailure;
  final bool downloadSuccess;
  final bool downloadFailure;


  SyncState({
    @required this.diaries,
    @required this.downloaded,
    @required this.isInitializing,
    @required this.isLoading,
    @required this.isDownloading,
    @required this.loadSuccess,
    @required this.loadFailure,
    @required this.downloadSuccess,
    @required this.downloadFailure
  });


  factory SyncState.initializing(){
    return SyncState(
        diaries: [],
        downloaded: [],
        isInitializing: true,
        isLoading: false,
        isDownloading: false,
        loadSuccess: false,
        loadFailure: false,
        downloadSuccess: false,
        downloadFailure: false
    );
  }

  factory SyncState.loaded(List<DiaryModel> diaries){
    print('SyncState loaded ::: ${diaries.length}');
    return SyncState(
        diaries: diaries ?? [],
        downloaded: [],
        isInitializing: false,
        isLoading: false,
        isDownloading: false,
        loadSuccess: diaries == null ? false : true,
        loadFailure: diaries == null ? true : false,
        downloadSuccess: false,
        downloadFailure: false
    );
  }

  factory SyncState.downloaded(bool isSuccess, List<DiaryModel> downloaded){
    return SyncState(
        diaries: [],
        downloaded: downloaded ?? [],
        isInitializing: false,
        isLoading: false,
        isDownloading: false,
        loadSuccess: false,
        loadFailure: false,
        downloadSuccess: isSuccess ? true : false,
        downloadFailure: isSuccess ? false : true
    );
  }


  SyncState update({
    bool isInitializing,
    bool isLoading,
    bool isDownloading,
    bool loadSuccess,
    bool loadFailure,
    bool downloadSuccess,
    bool downloadFailure
  }){
    return copyWith(
        isInitializing: isInitializing,
        isLoading: isLoading,
        isDownloading: isDownloading,
        loadSuccess: loadSuccess,
        loadFailure: loadFailure,
        downloadSuccess: downloadSuccess,
        downloadFailure: downloadFailure
    );
  }

  SyncState copyWith({
    List<DiaryModel> diaries,
    List<DiaryModel> downloaded,
    bool isInitializing,
    bool isLoading,
    bool isDownloading,
    bool loadSuccess,
    bool loadFailure,
    bool downloadSuccess,
    bool downloadFailure

  }){
    return SyncState(
        diaries: diaries ?? this.diaries,
        downloaded: downloaded ?? this.downloaded,
        isInitializing: isInitializing ?? this.isInitializing,
        isLoading: isLoading ?? this.isLoading,
        isDownloading: isDownloading ?? this.isDownloading,
        loadSuccess: loadSuccess ?? this.loadSuccess,
        loadFailure: loadFailure ?? this.loadFailure,
        downloadSuccess: downloadSuccess ?? this.downloadSuccess,
        downloadFailure: downloadFailure ?? this.downloadFailure
    );
  }

  @override
  String toString() {
    return 'SyncState{isInitializing: $isInitializing, isLoading: $isLoading, isDownloading: $isDownloading, loadSuccess: $loadSuccess, loadFailure: $loadFailure, downloadSuccess: $downloadSuccess, downloadFailure: $downloadFailure}';
  }

}
