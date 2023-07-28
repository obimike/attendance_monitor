import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();
  bool _isInsidePolygon = false;

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void _initLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle the case where the location service is not enabled
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user denied location permission permanently
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user does not grant location permission
        return;
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(52.956158, -1.153108),
              zoom: 15,
              maxZoom: 18,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                print(position.center);
              },
              onMapReady: () {
                mapController.mapEventStream.listen((evt) {

                });
                // And any other `MapController` dependent non-movement methods
              },
            ),
            children: [
              TileLayer(
                // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
                maxZoom: 18,
              ),
              PolygonLayer(
                polygonCulling: false,
                polygons: [
                  Polygon(
                      points: const [
                        LatLng(52.95896, -1.15339),
                        LatLng(52.95835, -1.1556),
                        LatLng(52.95751, -1.15569),
                        LatLng(52.95748, -1.1551),
                        LatLng(52.95723, -1.15511),
                        LatLng(52.95719, -1.15409),
                        LatLng(52.95737, -1.15405),
                        LatLng(52.95748, -1.15383),
                        LatLng(52.95742, -1.15343),
                        LatLng(52.95714, -1.1534),
                        LatLng(52.95713, -1.15325),
                        LatLng(52.95768, -1.15285),
                        LatLng(52.95757, -1.1516),
                        LatLng(52.95761, -1.15132),
                        LatLng(52.9588, -1.15113),
                        LatLng(52.95896, -1.15339),
                      ],
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                      isFilled: true),
                ],
              ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    color: Colors.green,
                    child: FirebaseAuth.instance.currentUser!.photoURL! == ""
                        ? const Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                        : CircleAvatar(
                      radius: 12,
                      foregroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!),
                    ),
                  ),
                  markerSize: const Size.square(40),
                  accuracyCircleColor: Colors.green.withOpacity(0.1),
                  headingSectorColor: Colors.blue.withOpacity(0.8),
                  headingSectorRadius: 120,
                ),
                moveAnimationDuration: Duration.zero,
                positionStream: const LocationMarkerDataStreamFactory()
                    .fromGeolocatorPositionStream(
                  stream: Geolocator.getPositionStream(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.medium,
                      distanceFilter: 50,
                      timeLimit: Duration(minutes: 1),
                    ),
                  ),
                ),
                followScreenPoint: const CustomPoint(0.0, 1.0),
                followScreenPointOffset: const CustomPoint(0.0, -60.0),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 92,
              width: dynamicWidth,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 51, 51, 51),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Current Location",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "You are 6km away from class",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
