import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/weatherModel.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({Key? key}) : super(key: key);

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  final List<Placemark> _places = [
    Placemark(lat: 55.7532, lon: 37.6206, cityName: "Moscow"),
    Placemark(lat: 48.8753, lon: 2.2950, cityName: "Paris"),
    Placemark(lat: 51.5011, lon: -0.1253, cityName: "London"),
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _places.length,
          itemBuilder: (ctx, index){
          return Dismissible(
              key: Key(_places[index].cityName),
                onDismissed:(direction){
                  setState(() {
                    _places.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Место удалено")));
                },
              background: Container(color: Colors.red,),
              child: ListTile(
                title: Text(_places[index].cityName),
              )
          );
          }
          );
  }
}
