import 'package:first_project/model/weatherModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfo extends InheritedWidget{
  final Placemark placemark;

  LocationInfo(this.placemark, Widget child) : super(child: child);

  static LocationInfo of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocationInfo>()!;

  @override
  bool updateShouldNotify(LocationInfo oldLocationInfo){
    var oldLocationTime = oldLocationInfo.placemark.timeStamp;
    var newLocationTime = placemark.timeStamp;

    return oldLocationTime < newLocationTime;
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
    Position location = await _determinePosition();
    Placemark place = Placemark(
        lat: location.longitude,
        lon: location.latitude,
        cityName: "Ivanovo"
    );
    print(place.getPlacemark());
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
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : LocationInfo(_placemark, widget.child);
  }
}