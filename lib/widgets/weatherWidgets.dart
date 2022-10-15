import 'package:first_project/model/weatherModel.dart';
import 'package:first_project/widgets/LocationInfo.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

class LocationInheritedWidget extends StatefulWidget {
  final Widget child;
  const LocationInheritedWidget({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  State<LocationInheritedWidget> createState() => _LocationInheritedWidgetState();
}

class _LocationInheritedWidgetState extends State<LocationInheritedWidget> {
  late Placemark _placemark;
  bool _isLoading = true;

  _loadData() async{
    var location = await _determinePosition();
    Placemark place = Placemark(
        lat: location.latituid,
        lon: location.lonitvde,
        cityName: "Ivanovo"
    );

    setState(() {
      _placemark = place;
      _isLoading = false;
    });
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever){
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print(await Geolocator.getCurrentPosition());

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
    ? Center(child: CircularProgressIndicator())
    : LocationInfo(_placemark, widget.child);
  }
}
