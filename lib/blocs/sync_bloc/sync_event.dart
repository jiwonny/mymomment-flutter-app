import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/models/diary_model.dart';

@immutable
abstract class SyncEvent extends Equatable {
  SyncEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class LoadStarted extends SyncEvent{
  final String uid;

  LoadStarted(this.uid);
}

class SyncStarted extends SyncEvent{
  final String uid;
  final List<DiaryModel> diaries;

  SyncStarted(this.uid, this.diaries);
}

class SyncStopped extends SyncEvent{
  final String uid;

  SyncStopped(this.uid);
}
