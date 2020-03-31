import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_face_diary/widgets/diary_card_carousel.dart';
import 'package:my_face_diary/widgets/month_selector.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 20.0),
//            child: Text('하루하루, 소중한 내 모습을 기억하세요.',
//              style: TextStyle(color: Colors.black, fontSize: 18.0),
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 15.0),
            child: MonthSelector()
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                return DiaryCarousel(
                      maxWidth: c.maxWidth,
                      maxHeight: c.maxHeight
                );
              }
            ),
          )
        ],
      )
    );
  }


}
