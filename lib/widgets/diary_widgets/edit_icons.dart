import 'package:flutter/material.dart';

import 'icons.dart';


class EditDiaryIcons extends StatefulWidget {
  final Emotions initialEmotion;
  final Weathers initialWeather;
  final Function(Emotions emotion) onEmotionChanged;
  final Function(Weathers weather) onWeatherChanged;

  EditDiaryIcons({
    @required this.initialEmotion,
    @required this.initialWeather,
    this.onEmotionChanged,
    this.onWeatherChanged
  });

  @override
  _EditDiaryIconsState createState() => _EditDiaryIconsState();
}

class _EditDiaryIconsState extends State<EditDiaryIcons> {
  Emotions _emotion;
  Weathers _weather;

  @override
  void initState() {
    // Initial Emotion & Weather
    _emotion = widget.initialEmotion;
    _weather = widget.initialWeather;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = DiaryIcons.iconThemeData;

    return GestureDetector(
      onTap: () => _showDiaryIconsBottomSheet(context),
      child: Row(
        children: <Widget>[
          IconTheme.merge(
              data: iconThemeData,
              child: DiaryIcons.getEmotionWidget(_emotion)),
          const SizedBox(width: 15,),
          IconTheme.merge(
              data: iconThemeData,
              child: DiaryIcons.getWeatherWidget(_weather))
        ],
      ),
    );
  }

  void _showDiaryIconsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
        return Container(
            color: Colors.white,
            height: 330,
            child: DiaryIconsBottomSheet(
              initialEmotion: _emotion,
              initialWeather: _weather,
              onEmotionChanged: (emotion){
                setState(() {
                  _emotion = emotion;
                  widget.onEmotionChanged(_emotion);
                });
              },
              onWeatherChanged: (weather){
                setState(() {
                  _weather = weather;
                  widget.onWeatherChanged(_weather);
                });
              }));},
    );
  }
}


class DiaryIconsBottomSheet extends StatefulWidget {
  final Emotions initialEmotion;
  final Weathers initialWeather;
  final Function(Emotions emotion) onEmotionChanged;
  final Function(Weathers weather) onWeatherChanged;

  DiaryIconsBottomSheet({
    this.initialEmotion,
    this.initialWeather,
    this.onEmotionChanged,
    this.onWeatherChanged
  });

  @override
  _DiaryIconsBottomSheetState createState() => _DiaryIconsBottomSheetState();
}

class _DiaryIconsBottomSheetState extends State<DiaryIconsBottomSheet> {
  Emotions _selectedEmotion;
  Weathers _selectedWeather;

  @override
  void initState() {
    _selectedEmotion = widget.initialEmotion;
    _selectedWeather = widget.initialWeather;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

    List<Widget> emotionWidgets = DiaryIcons.allEmotions.map((emotion){
      return GestureDetector(
        onTap: (){
          setState(() {
            _selectedEmotion = emotion;
            widget.onEmotionChanged(_selectedEmotion);
          });
        },
        child: IconTheme.merge(
            data: IconThemeData(
              size: 34.0,
              color: emotion == _selectedEmotion ? Color(0xffff6f6e): Colors.grey
            ),
            child: DiaryIcons.getEmotionWidget(emotion)
        ),
      );
    }).toList();

    List<Widget> weatherWidgets = DiaryIcons.allWeathers.map((weather){
      return GestureDetector(
        onTap: (){
          setState(() {
            _selectedWeather = weather;
            widget.onWeatherChanged(_selectedWeather);
          });
        },
        child: IconTheme.merge(
            data: IconThemeData(
                size: 34.0,
                color: weather == _selectedWeather? Color(0xffff6f6e) : Colors.grey
            ),
            child: DiaryIcons.getWeatherWidget(weather)
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(('오늘의 감정'), style: textStyle,),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: emotionWidgets,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.8,
              color: Colors.grey.withOpacity(0.6),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(('오늘의 날씨'), style: textStyle,),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weatherWidgets,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
