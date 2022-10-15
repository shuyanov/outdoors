class Weather{
  DateTime dateTime;
  num degree;
  String iconUrl;
  int clouds;

  Weather({
    required this.dateTime,
    required this.degree,
    required this.iconUrl,
    required this.clouds
  });

  static const String weatherURL ="http://openweathermap.org/img/wn/";

  String getIconURL() => "$weatherURL$iconUrl.png";
}

class DayHeading{
  final DateTime dateTime;

  DayHeading({
    required this.dateTime
  });
}