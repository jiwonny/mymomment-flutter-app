import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons/weather_icons.dart';

enum Emotions {anger, sadness, normal, happiness, excitement}

extension EmotionToString on Emotions {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

enum Weathers {sunny, cloudy, rainy, windy, snow}

extension WeatherToString on Weathers {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class DiaryIcons {
  static IconThemeData iconThemeData = IconThemeData(
      color: Color(0xffff6f6e),
      size: 26.0
  );

  static List<Emotions> allEmotions = [
    Emotions.excitement, Emotions.happiness, Emotions.normal, Emotions.sadness, Emotions.anger
  ];

  static List<Weathers> allWeathers = [
    Weathers.sunny, Weathers.windy, Weathers.cloudy, Weathers.rainy, Weathers.snow
  ];

  static Widget getEmotionWidget(Emotions emotion){
    switch(emotion){
      case Emotions.anger:
        return Icon(FontAwesomeIcons.angry);
        break;
      case Emotions.sadness:
        return Icon(FontAwesomeIcons.frown);
        break;
      case Emotions.normal:
        return Icon(FontAwesomeIcons.smile);
        break;
      case Emotions.happiness:
        return Icon(FontAwesomeIcons.grinBeam);
        break;
      case Emotions.excitement:
        return Icon(FontAwesomeIcons.grinHearts);
        break;
      default:
        return Container();
    }
  }

  static Map<String, Emotions> stringToEmotions = {
    'anger': Emotions.anger,
    'sadness': Emotions.sadness,
    'normal': Emotions.normal,
    'happiness': Emotions.happiness,
    'excitement': Emotions.excitement
  };

  static Widget getWeatherWidget(Weathers weather){
    switch(weather){
      case Weathers.cloudy:
        return BoxedIcon(WeatherIcons.cloudy);
        break;
      case Weathers.rainy:
        return BoxedIcon(WeatherIcons.rain);
        break;
      case Weathers.sunny:
        return BoxedIcon(WeatherIcons.day_sunny);
        break;
      case Weathers.windy:
        return BoxedIcon(WeatherIcons.day_cloudy);
        break;
      case Weathers.snow:
        return BoxedIcon(WeatherIcons.snow);
        break;
      default:
        return Container();
    }
  }

  static Map<String, Weathers> stringToWeathers = {
    'cloudy': Weathers.cloudy,
    'rainy': Weathers.rainy,
    'sunny': Weathers.sunny,
    'windy': Weathers.windy,
    'snow': Weathers.snow
  };
}