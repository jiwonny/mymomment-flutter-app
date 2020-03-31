import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/models/diary_model.dart';

@immutable
abstract class BackupEvent extends Equatable {
  BackupEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class LoadStarted extends BackupEvent{
  final String uid;

  LoadStarted(this.uid);
}

class BackupStarted extends BackupEvent{
  final String uid;
  final List<DiaryModel> diaries;

  BackupStarted(this.uid, this.diaries);
}

class BackupStopped extends BackupEvent{
  final String uid;

  BackupStopped(this.uid);
}
