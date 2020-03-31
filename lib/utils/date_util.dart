class DateUtil {
  static const List<String> weekdays = const [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  ];

  static const List<String> months = const [
    "1월",
    "2월",
    "3월",
    "4월",
    "5월",
    "6월",
    "7월",
    "8월",
    "9월",
    "10월",
    "11월",
    "12월",
  ];

  static const List<String> weeks = const [
    "첫째 주",
    "둘째 주",
    "셋째 주",
    "넷째 주",
    "다섯째 주",
    "여섯째 주",
    "마지막 주",
  ];

  static String getWeekdays(DateTime day) {
    return weekdays[day.weekday % 7];
  }

  static String getOrdinalIndicator(int day){
    if(day == 1) return day.toString() + 'th';
    else if(day == 2) return day.toString() + 'nd';
    else if(day == 3) return day.toString() + 'rd';
    else return day.toString() + 'th';
  }

  static DateTime firstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// We use Sunday - Saturday as Weekday,
    var increaseNum = day.weekday % 7;
    return day.subtract(new Duration(days: increaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// We use Sunday - Saturday as Weekday,
    var increaseNum = day.weekday % 7;
    return day.add(new Duration(days: 6 - increaseNum));
  }

  static String weekName(DateTime day) {
    int currentMonth = day.month;
    String month = months[currentMonth - 1];
    DateTime firstDay = firstDayOfWeek(day);
    DateTime lastDay = lastDayOfWeek(day);

    if (previousWeek(lastDay).month < currentMonth) {
      return "$month ${weeks.first}";
    } else if (nextWeek(firstDay).month > currentMonth) {
      return "$month ${weeks.last}";
    } else {
      int increased = 0;
      while (lastDay.month == currentMonth) {
        increased++;
        lastDay = previousWeek(lastDay);
      }
      return "$month ${weeks[increased - 1]}";
    }
  }

  /// The first day of a given month
  static DateTime firstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month, 1);
  }


  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  static DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return new DateTime(year, month,1);
  }

  static DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return new DateTime(year, month, 1);
  }

  static DateTime previousWeek(DateTime w) {
    return w.subtract(new Duration(days: 7));
  }

  static DateTime nextWeek(DateTime w) {
    return w.add(new Duration(days: 7));
  }

  static bool isToday(DateTime w) {
    DateTime today = DateTime.now();
    return today.year == w.year && today.month == w.month && today.day == w.day;
  }

  static int differenceInMinute(DateTime w) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(w);
    return difference.inMinutes;
  }

  static String dateFormat(DateTime w) {
    String month;
    String day;

    if(w.month.toString().length == 1){
      month = '0'+w.month.toString();
    } else {
      month = w.month.toString();
    }
    if(w.day.toString().length == 1){
      day = '0'+w.day.toString();
    } else {
      day = w.day.toString();
    }

    return '${w.year}.$month.$day';
  }
}