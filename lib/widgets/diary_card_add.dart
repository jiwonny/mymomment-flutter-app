import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:my_face_diary/utils/navigators.dart';
import 'package:my_face_diary/widgets/diary_card_carousel.dart';

class DiaryCardAdd extends StatelessWidget {

  final Key key;

  DiaryCardAdd({this.key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => moveToEditDiaryScreen(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: AspectRatio(
          aspectRatio: 3 / 4.5,
          child: DottedBorder(
            borderType: BorderType.RRect,
            padding: EdgeInsets.all(0.5),
            radius: Radius.circular(20.0),
            color: Colors.grey,
            dashPattern: [4,2],
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 15,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                color: Colors.grey[100],
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_circle_outline, color: Color(0xaa000000),),
                        const SizedBox(height: 10.0,),
                        Text('오늘의 모습\n추가하기',
                          style: TextStyle(fontSize: 14.0, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
