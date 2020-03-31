import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/utils/database/database_helper.dart';
import 'package:my_face_diary/utils/date_util.dart';
import 'package:my_face_diary/widgets/back_button.dart';
import 'package:my_face_diary/widgets/diary_widgets/edit_icons.dart';
import 'package:my_face_diary/widgets/diary_widgets/edit_image.dart';
import 'package:my_face_diary/widgets/diary_widgets/edit_note.dart';
import 'package:my_face_diary/widgets/diary_widgets/icons.dart';
import 'package:toast/toast.dart';

import '../models/diary_model.dart';

//TODO(동찬) : 새로 작성 화면과 수정화면 구분 해줘야함(diaryModel이 같이 들오냐 안오냐로 구분해주면 될듯)

class DiaryEditScreen extends StatefulWidget {
  static const routeName = '/editDiaryScreen';

  final DiaryModel diaryModel;

  DiaryEditScreen({this.diaryModel});

  @override
  _DiaryEditScreenState createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  final _maxNumOfImages = 3;

  bool _isEditing;
  DiaryModel _editingDiary;

  ScrollController _scrollController;
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  List<List<int>> _images;
  int _id;
  Emotions _emotion;
  Weathers _weather;
  DateTime _date;


  @override
  void initState() {
    _isEditing = widget.diaryModel != null ? true : false;
    if(_isEditing) _editingDiary = widget.diaryModel;

    _scrollController = ScrollController();

    _textEditingController = TextEditingController(
      text: _isEditing ? _editingDiary.note : ''
    );

    _focusNode = FocusNode()
      ..addListener((){
        // Remove Keyboard when Scrolling down
        if(_focusNode.hasFocus){
          _scrollController.addListener((){
            if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
              _focusNode.unfocus();
            }
          });
        }
      });

    // Initial Setting
    if(_isEditing){
      _id = _editingDiary.id;
      _images = _editingDiary.images;
      _emotion = _editingDiary.emotion;
      _weather = _editingDiary.weather;
      _date = _editingDiary.date;
    } else {
      _id = null;
      _images = null;
      _emotion = Emotions.happiness;
      _weather = Weathers.sunny;
      _date = DateTime.now();
    }

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final DiaryModel diaryModel = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            EditDiaryImage(
                              onImagesChanged: (images){
                                _images = images;
                              },
                              initialImages: _images,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(DateUtil.dateFormat(_date),
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                  EditDiaryIcons(
                                    initialEmotion: _emotion,
                                    initialWeather: _weather,
                                    onEmotionChanged: (emotion){
                                      _emotion = emotion;
                                    },
                                    onWeatherChanged: (weather){
                                      _weather = weather;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: EditDiaryNote(
                                textEditingController: _textEditingController,
                                focusNode: _focusNode,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                top: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomBackButton(
                      margin: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
                    ),
                    FlatButton(
                        onPressed: () =>  _saveDiary(
                            images: _images,
                            emotion: _emotion,
                            weather: _weather,
                            note: _textEditingController.text
                        ),
//                          color: Color(0xffff6f5f).withOpacity(0.7),
                        child: Text('Save',
                          style: TextStyle(fontSize: 20.0, color: Color(0xffff2f2f), fontWeight: FontWeight.bold),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  void _saveDiary({List<List<int>> images, String note, Emotions emotion, Weathers weather}) async{
    final helper = DiaryDBHelper();
    final numOfImages = images.length;
    List<List<int>> savedImages = List.from(images);
    for(int i = numOfImages; i < _maxNumOfImages ; i ++){
        savedImages.add(null);
    }

    DiaryModel diary = DiaryModel(
      id: _id,
      date: _date,
      image1: savedImages[0] == null ? null : Uint8List.fromList(savedImages[0]),
      image2: savedImages[1] == null ? null : Uint8List.fromList(savedImages[1]),
      image3: savedImages[2] == null ? null : Uint8List.fromList(savedImages[2]),
      emotion: emotion,
      weather: weather,
      note: note
    );

    final selectedMonth = BlocProvider.of<DiaryBloc>(context).state.selectedMonth;
    final selectedYear = BlocProvider.of<DiaryBloc>(context).state.selectedYear;

    try{
      if(_isEditing){
        await helper.updateDiary(diary);
        if(_date.year == selectedYear && _date.month == selectedMonth) {
          BlocProvider.of<DiaryBloc>(context).add(EditDiary(diary));
        }
        Toast.show('수정 하였습니다.', context, duration: Toast.LENGTH_LONG);
        Navigator.pop(context, diary);
      } else {
        final id = await helper.saveDiary(diary);
        diary = diary.copyWith(id: id);
        if(_date.year == selectedYear && _date.month == selectedMonth) {
          BlocProvider.of<DiaryBloc>(context).add(AddDiaries(_date.year, _date.month, diary));
        }
        Toast.show('저장 하였습니다.', context, duration: Toast.LENGTH_LONG);
        Navigator.pop(context, null);
      }
    }catch(error){
      Toast.show('저장에 실패하였습니다.', context, duration: Toast.LENGTH_LONG);
      print(error);
    }

  }
}
