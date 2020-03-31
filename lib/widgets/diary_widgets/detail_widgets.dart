import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/utils/navigators.dart';
import 'package:my_face_diary/widgets/back_button.dart';
import 'package:my_face_diary/widgets/dialog/delete_confirm.dart';
import 'icons.dart';

class DiaryDetailImages extends StatefulWidget {
  final Key key;
  final DiaryModel diaryModel;
  final Function(DiaryModel diary) onDiaryEdited;

  DiaryDetailImages({this.key, this.diaryModel, this.onDiaryEdited})
      : super(key: key);

  @override
  _DiaryDetailImagesState createState() => _DiaryDetailImagesState();
}

class _DiaryDetailImagesState extends State<DiaryDetailImages> {
  DiaryModel _diary;
  int _index;

  @override
  void initState() {
    _diary = widget.diaryModel;
    _index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4.5,
      child: Stack(
        children: <Widget>[
          CarouselSlider.builder(
            aspectRatio: 3 / 4.5,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            itemCount: _diary.images.length,
            onPageChanged: (index){
              setState(() {
                _index = index;
              });
            },
            itemBuilder: (context, index){
              return Image.memory(
                _diary.images[index],
                fit: BoxFit.cover,
              );
            },),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  CustomBackButton(
                    margin: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.trashAlt),
                      color: Color(0xffff6f5f),
                      onPressed: () => deleteDiary(context, widget.diaryModel)
                  ),
                  IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                      icon: Icon(FontAwesomeIcons.edit),
                      color: Color(0xffff6f5f),
                      onPressed: () async{
                       DiaryModel edited = await moveToEditDiaryScreen(context, diaryModel: widget.diaryModel);
                       if(edited != null){
                         widget.onDiaryEdited(edited);
                       }
                    }
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _diary.images.map((image) =>
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _diary.images.indexOf(image) == _index ? Colors.white : Colors.grey
                      ),
                      width: 5.0,
                      height: 5.0,
                    )
                ).toList(),
              ),
            ),

          )
        ],
      ),
    );
  }

  void deleteDiary(BuildContext context, DiaryModel diaryModel){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirm(diaryModel);
      },
    );
  }
}

class DiaryDetailIcons extends StatelessWidget {
  final Emotions emotion;
  final Weathers weather;

  DiaryDetailIcons({@required this.emotion, @required this.weather});

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = DiaryIcons.iconThemeData;

    return Row(
      children: <Widget>[
        IconTheme.merge(
            data: iconThemeData,
            child: DiaryIcons.getEmotionWidget(emotion)),
        const SizedBox(width: 15,),
        IconTheme.merge(
            data: iconThemeData,
            child: DiaryIcons.getWeatherWidget(weather))
      ],
    );
  }
}

class DiaryDetailNote extends StatelessWidget {
  final String note;

  DiaryDetailNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Text(note,
        style: TextStyle(fontSize: 18.0, height: 1.5),)
    );
  }
}

