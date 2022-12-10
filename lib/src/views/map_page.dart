import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  // default to central London

  static const _defaultCenter = LatLng(51.5074, -0.1272);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng>? getLocation() async {
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return _defaultCenter;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return _defaultCenter;
      }
    }

    return await location
        .getLocation()
        .then((value) => LatLng(value.latitude!, value.longitude!));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Skeleton App'),
          backgroundColor: Colors.green[700],
        ),
        body: FutureBuilder<LatLng>(
            future: getLocation(),
            builder: (context, AsyncSnapshot<LatLng> snapshot) {
              LatLng position = snapshot.data ?? _defaultCenter;
              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: position,
                  zoom: 11.0,
                ),
              );
            }),
      ),
    );
  }
}
