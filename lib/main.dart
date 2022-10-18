import 'dart:convert';

import 'package:first_project/Constants.dart';
import 'package:first_project/widgets/PlacesPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


import 'model/weatherModel.dart';
import 'widgets/LocationInfo.dart';
import 'widgets/weatherWidgets.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // Этот виджет является корнем вашего приложения.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  Scaffold(
            appBar: AppBar(
              title: Text("First project"),
            ),
            body: PlacesPage(),
            // body:LocationInheritedWidget(
            //     child: WeatherPage(cityName: "Moscow",)
            // )

        )
    );
  }
}

class WeatherPage extends StatefulWidget {
  final String cityName;
  WeatherPage({
    Key? key,
    required this.cityName
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
{
  List<Weather> weatherForecast = [];
  List<ListItem> itemsToBuild = [];
  bool _isLoading = true;
  Placemark? _placemark;

  @override
  void didChangeDependencies(){
    _placemark = LocationInfo
        .of(context)
        .placemark;
    _getWeatherData();
  }

  // _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever){
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   print(await Geolocator.getCurrentPosition());
  //   Position currentPosition = await Geolocator.getCurrentPosition();
  //   _lat = currentPosition.latitude.toString();
  //   _lon = currentPosition.longitude.toString();
  // }

  _getWeatherData() async{
    if(_placemark == null) return;
    Map<String, dynamic> _queryParams = {
      "APPID": Constants.WEATHER_APP_ID,
      "units":"metric",
        "lat":_placemark!.lat.toString(),
        "lon":_placemark!.lon.toString()
      };

      // _queryParams.runtimeType()// показывает какого типа переменная
      var uri = Uri.https(Constants.WEATHER_BASE_URL, Constants.WEATHER_FORECAST_URL, _queryParams);
      var response = await http.get(uri);

      var parsedRespones = jsonDecode(response.body);
      if (parsedRespones["cod"] != "200") return;

      parsedRespones["list"].forEach((period) {
        var dateTime = DateTime.fromMillisecondsSinceEpoch(period["dt"] * 1000);
        var degree = period["main"]["temp"];
        var clouds = period["clouds"]["all"];
        var icon = period["weather"][0]["icon"];

        weatherForecast.add(Weather(dateTime: dateTime, degree: degree, iconUrl: icon, clouds: clouds));
      });
      initWeatherWithData();

    }

    initWeatherWithData(){
      var now = DateTime.now();
      var itCurreentDay = now;
      var itNextDay = DateTime(now.year, now.month, now.day + 1, 0,0,0,0,0);

       itemsToBuild.add(DayHeading(dateTime: now));

       for(int i = 0; i < weatherForecast.length; i++){
         if(weatherForecast[i].getDateTime() == itNextDay){
           itCurreentDay = itNextDay;
           itNextDay = DateTime(itNextDay.year, itNextDay.month, itNextDay.day + 1, 0,0,0,0,0);
           itemsToBuild.add(DayHeading(dateTime: itCurreentDay));
           itemsToBuild.add(weatherForecast[i]);
         }
         else if(weatherForecast[i].getDateTime().isAfter(itNextDay)){
           itCurreentDay = itNextDay;
           itNextDay = DateTime(itNextDay.year, itNextDay.month, itNextDay.day + 1, 0,0,0,0,0);
           itemsToBuild.add(DayHeading(dateTime: itCurreentDay));
         }
         else{
           itemsToBuild.add(weatherForecast[i]);
         }
       }

       setState(() {
         _isLoading = false;
       });
    }

    @override
    Widget build(BuildContext context){
      if(_isLoading){
        return Center(child: CircularProgressIndicator());
      }
      else{
        return ListView.builder(
            itemCount: weatherForecast.length,
            itemBuilder: (BuildContext ctx, int index){
              final item = itemsToBuild[index];
              if(item is Weather) return WeatherWidget(weather: item,);// отображает погоду итд
              else if(item is DayHeading) return dayHeadingWidget(dayHeading: item,);// заголовок
              else return Text("Error type");
            }
            );
      }
    }
}
