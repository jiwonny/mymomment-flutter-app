import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_face_diary/models/diary_model.dart';

@immutable
abstract class DiaryEvent extends Equatable {
  DiaryEvent([List props = const []]);

  @override
  List<Object> get props => [];
}
class HomeScreenStarted extends DiaryEvent{
  final int year;
  final int month;

  HomeScreenStarted(this.year, this.month);
}

class LoadDiaries extends DiaryEvent{}

class LoadOtherDiaries extends DiaryEvent{
  final int year;
  final int month;

  LoadOtherDiaries(this.year, this.month);
}

class AddDiaries extends DiaryEvent{
  final int year;
  final int month;
  final DiaryModel diaryModel;

  AddDiaries(this.year, this.month, this.diaryModel);
}

class EditDiary extends DiaryEvent{
  final DiaryModel diaryModel;

  EditDiary(this.diaryModel);
}

class DeleteDiary extends DiaryEvent{
  final int year;
  final int month;
  final DiaryModel diaryModel;

  DeleteDiary(this.year, this.month, this.diaryModel);

}
