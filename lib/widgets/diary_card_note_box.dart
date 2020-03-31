import 'dart:math' as Math;
import 'package:flutter/material.dart';

class DiaryCardNote extends StatelessWidget {

  DiaryCardNote({
    this.width,
    this.height,
    this.borderRadius = 20.0,
    this.circleButtonRadius = 13.0,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xffff6f6e),
    this.child
  });

  final double width;
  final double height;
  final double borderRadius;
  final double circleButtonRadius;
  final Color backgroundColor;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CustomPaint(
        painter: NoteBox(
          borderRadius: borderRadius,
          circleButtonRadius: circleButtonRadius,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
        ),
        child: child
      )
    );
  }
}


class NoteBox extends CustomPainter {
  NoteBox({
    this.borderRadius,
    this.circleButtonRadius,
    this.backgroundColor,
    this.iconColor
  });

  final double borderRadius;
  final double circleButtonRadius;
  final Color backgroundColor;
  final Color iconColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round;

    Path circlePath = drawCircle(size.width, circleButtonRadius);
    canvas.drawShadow(circlePath, Colors.grey[900], 2.0, false);
    canvas.drawPath(circlePath, paint);

    Path boxPath = drawBox(size.width, size.height-2, borderRadius, circleButtonRadius);
    canvas.drawShadow(boxPath,Colors.grey[900], 3.0, false);
    canvas.drawPath(boxPath, paint);

    final icon = Icons.arrow_forward;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint),
        style: TextStyle(color: iconColor,fontSize: 2*circleButtonRadius -7, fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width/2 - circleButtonRadius+4, -circleButtonRadius+4));
  }

  Path drawCircle(double width, double radius){
    return Path()
      .. addOval(Rect.fromCircle(center: Offset(width/2, 0), radius: radius));
  }

  Path drawBox(double width, double height, double edgeRadius, double centerRadius){
    double actualWidth = width - 2*edgeRadius;
    double actualHeight = height - 2*edgeRadius;
    double topHalfWidth = (actualWidth - 2*centerRadius)/2;
    double gap = 3.0;
    double sRadius = 6.0;

    Path path = Path();
    path.moveTo(0, edgeRadius);
    path.relativeArcToPoint(Offset(edgeRadius, -edgeRadius), radius: Radius.circular(edgeRadius), clockwise: true);

    path.relativeLineTo(topHalfWidth-sRadius-gap, 0);

    path.relativeArcToPoint(Offset(sRadius, sRadius), radius: Radius.circular(sRadius), clockwise: true);
    path.relativeArcToPoint(Offset(2*centerRadius+2*gap, 0), radius: Radius.circular(centerRadius+1.4*gap), clockwise: false);
    path.relativeArcToPoint(Offset(sRadius, -sRadius), radius: Radius.circular(sRadius), clockwise: true);

    path.relativeLineTo(topHalfWidth-sRadius-gap, 0);

    path.relativeArcToPoint(Offset(edgeRadius, edgeRadius), radius: Radius.circular(edgeRadius), clockwise: true);
    path.relativeLineTo(0, actualHeight);
    path.relativeArcToPoint(Offset(-edgeRadius, edgeRadius), radius: Radius.circular(edgeRadius), clockwise: true);

    path.relativeLineTo(-actualWidth, 0);
    path.relativeArcToPoint(Offset(-edgeRadius, -edgeRadius), radius: Radius.circular(edgeRadius), clockwise: true);
    path.close();

    return path;
  }

  // Method to convert degree to radians
  num degToRad(num deg) => deg * (Math.pi / 180.0);

  @override
  bool shouldRepaint(NoteBox oldDelegate) {
    return oldDelegate.borderRadius != borderRadius || oldDelegate.circleButtonRadius != circleButtonRadius
        || oldDelegate.backgroundColor != backgroundColor || oldDelegate.iconColor != iconColor;
  }

}