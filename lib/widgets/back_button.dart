import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  final Function onPressed;
  final EdgeInsets margin;
  final Color color;

  CustomBackButton({
    this.onPressed,
    this.margin,
    this.color = const Color(0xffff6f6e)
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  (){
        if(onPressed != null){
          onPressed();
        } else {
          moveToLastScreen(context);
        }
      },
      child: Container(
        margin: margin,
        width: 30,
        height: 20,
        child: Center(
          child: SizedBox(
            width: 30,
            height: 20,
            child: SvgPicture.asset('assets/icons/left_arrow.svg',
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen(context) {
    Navigator.pop(context);
  }
}
