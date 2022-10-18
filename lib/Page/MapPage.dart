import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:first_project/widgets/LocationInfo.dart';

class MapPage extends StatefulWidget {
  const MapPage({ Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PlacemarkMapObject _placemark;
  late YandexMapController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _placemark = PlacemarkMapObject(
        mapId: MapObjectId("example"),
        point: Point(
          latitude: LocationInfo.of(context).placemark.lat,
          longitude: LocationInfo.of(context).placemark.lon,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search new place"),
      ),
      body: YandexMap(
        mapObjects: [
            _placemark
        ],
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _onMapCreated(YandexMapController controller){
    _controller = controller;
    _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: Point(
                  latitude: _placemark.point.latitude,
                  longitude: _placemark.point.longitude,
              )
          ),
        )
    );
  }
}
