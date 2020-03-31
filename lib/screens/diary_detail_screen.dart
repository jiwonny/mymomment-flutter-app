import 'package:flutter/material.dart';
import 'package:my_face_diary/utils/date_util.dart';
import 'package:my_face_diary/widgets/diary_widgets/detail_widgets.dart';

import '../models/diary_model.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryModel diaryModel;

  DiaryDetailScreen(this.diaryModel);

  @override
  _DiaryDetailScreenState createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  DiaryModel _diary;

  @override
  void initState() {
    _diary = widget.diaryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ObjectKey(_diary),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DiaryDetailImages(
              diaryModel: _diary,
              onDiaryEdited: (edited){
                setState(() {
                  _diary = edited;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(DateUtil.dateFormat(_diary.date),
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  DiaryDetailIcons(
                      emotion: _diary.emotion,
                      weather: _diary.weather)
                ],
              ),
            ),
            DiaryDetailNote(_diary.note)
          ],
        ),
      ),
    );
  }
}

