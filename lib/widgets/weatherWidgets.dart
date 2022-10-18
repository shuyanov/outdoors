import 'package:first_project/model/weatherModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WeatherWidget  extends StatelessWidget {
  final Weather weather;

  const WeatherWidget({
    Key? key,
    required this.weather
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row( //выводим значения на экран
        children: [
          Expanded(
              flex: 3, // показывает на сколько долей надо делить.
              child: Text(DateFormat("dd.MM.yyyy HH:mm").format(weather.dateTime))
          ),
          Expanded(
              flex: 1,
              child: Text(weather.degree.toString() + "C")
          ),
          Expanded(
              flex: 1,
              child: Text(weather.clouds.toString())
          ),
          Expanded(
              flex:1,
              child: Image.network(weather.getIconURL())
          )
        ],
      ),
    );
  }
}

class dayHeadingWidget extends StatelessWidget {
  final DayHeading dayHeading;
  static final DateFormat _dateFormat = DateFormat("EEEE");
  const dayHeadingWidget({
    Key? key,
    required this.dayHeading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile( // виджет который в себе имеет приблезительную разметку.
      title: Column(
        children: [
          Text(
              "${_dateFormat.format(dayHeading.dateTime)} ${dayHeading.dateTime.month}.${dayHeading.dateTime.day}"
          ),
          const Divider()
          // виджет который предстваляет из себя полосу для разделения(визуального)
        ],
      ),
    );
  }
}

