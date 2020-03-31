import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';
import 'package:my_face_diary/models/diary_model.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/utils/date_util.dart';
import 'package:my_face_diary/utils/navigators.dart';
import 'package:my_face_diary/widgets/diary_card_add.dart';
import 'package:my_face_diary/widgets/diary_widgets/icons.dart';

import '../models/diary_model.dart';
import 'carousel_slider.dart';


const double kSpacing = 10;
const double noteBoxHeight = 120;

class DiaryCarousel extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  final DiaryRepository diaryRepository = DiaryRepository();

  DiaryCarousel({this.maxWidth, this.maxHeight});

  @override
  Widget build(BuildContext context) {
    double height = (maxWidth * 0.65) * 4.5/3 + noteBoxHeight*(1/2) + 10;
    return Container(
      child: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state){
          if(state.isLoading){
            //TODO: loading 화면 구성
            return Center(child: Text('is loading'));
          }
          else if(state.isSuccess == true){
            _precacheImages(state.diaries, context);
            List<Widget> items = getFaceList(state.diaries);
            int initialPage = state.diaries.length > 1 ? state.diaries.length - 1 : 0;
            CarouselSlider carousel = CarouselSlider.builder(
                key: UniqueKey(),
                enableInfiniteScroll: false,
                height: height,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                initialPage: initialPage,
                itemCount: items.length,
                itemBuilder: (context, index) => items[index]
            );
            return carousel;
          }else if(state.isFailure){
            return Text('is failure');
          } else{
            return Text('else statement');
          }
        },
      )
    );
  }

  List<Widget> getFaceList(List<DiaryModel> diaries) {
    diaries.sort((a, b) => a.date.compareTo(b.date));
    List<Widget> faceList = [];
    for(DiaryModel diary in diaries){
      faceList.add(
          DiaryCard(key: ValueKey(diary.id),diaryModel: diary)
      );
    }
    faceList.add(DiaryCardAdd(key: ValueKey('add_card'),));
    return faceList;
  }

  Future<void> _precacheImages(List<DiaryModel> diaries, BuildContext context) async{
    if(diaries.isNotEmpty){
      List<Future> futures =[];
      for(DiaryModel diary in diaries){
        futures.add(
            precacheImage(MemoryImage(diary.image1), context)
        );
      }
      await Future.wait(futures);
    }
  }
}

class DiaryCard extends StatelessWidget {
  final Key key;
  final DiaryModel diaryModel;

  DiaryCard({this.key, this.diaryModel}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    final day = DateUtil.getOrdinalIndicator(diaryModel.date.day);
    final weekOfDay = DateUtil.weekdays[diaryModel.date.weekday % 7];

    final IconThemeData iconThemeData = IconThemeData(
        color: Color(0xffff6f6e),
        size: 20.0
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: AspectRatio(
        aspectRatio: 3 / 4.5,
        child: GestureDetector(
          onTap: ()=> moveToDiaryDetailScreen(context, diaryModel),
          child: Card(
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            borderOnForeground: false,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.memory(diaryModel.image1, fit: BoxFit.cover)),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(day + '. ' + weekOfDay,
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5.0,),
                                diaryModel.note != ''
                                    ? Text(diaryModel.note,
                                  style: TextStyle(fontSize: 16.0, height: 1.2 ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,)
                                    : null,
                                const SizedBox(height: 5.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconTheme.merge(
                                        data: iconThemeData,
                                        child: DiaryIcons.getEmotionWidget(diaryModel.emotion)),
                                    const SizedBox(width: 5.0,),
                                    IconTheme.merge(
                                        data: iconThemeData,
                                        child: DiaryIcons.getWeatherWidget(diaryModel.weather)),
                                  ],
                                )
                              ].where((w) => w!=null).toList(),
                    ),
                        )
                ),)
              ],
            )
          ),
        ),
      ),
    );
  }
}

