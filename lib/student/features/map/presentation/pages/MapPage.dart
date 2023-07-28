import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<LatLng> _polygonPoints = const [
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
  ];
  bool _isInsidePolygon = false;
  double distance = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void _initLocationService() async {
    Geolocator.getPositionStream().listen((Position position) {
      // Update the marker position on the map
      _mapController.move(LatLng(position.latitude, position.longitude), 16.0);

      // Check if the user's location is inside the defined polygon
      setState(() {
        _isInsidePolygon = isPointInsidePolygon(
            LatLng(position.latitude, position.longitude), _polygonPoints);

        distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _polygonPoints[0].latitude,
          _polygonPoints[0].longitude,
        );
      });

      // Trigger an event or perform actions based on _isInsidePolygon
      if (_isInsidePolygon) {
        // The user is inside the polygon, do something
        print("The user is inside the polygon");
      } else {
        // The user is outside the polygon, do something else
        print("The user is outside the polygon");
      }
      setState(() {});
    });
  }

// Check if a point is inside a polygon using the Ray-Casting algorithm
  bool isPointInsidePolygon(LatLng point, List<LatLng> polygonPoints) {
    int intersectCount = 0;
    for (int i = 0; i < polygonPoints.length - 1; i++) {
      if (rayCastIntersect(point, polygonPoints[i], polygonPoints[i + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  bool rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    final double aY = vertA.latitude;
    final double bY = vertB.latitude;
    final double pY = point.latitude;
    final double aX = vertA.longitude;
    final double bX = vertB.longitude;
    final double pX = point.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // no crossing of the ray
    }

    final double m = (aY - bY) / (aX - bX); // slop of the line
    final double bee = (-aX) * m + aY; // y-intercept of the line

    final double x = (pY - bee) / m; // x coordinate of intersection

    return x > pX;
  }

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: const LatLng(0, 0),
              zoom: 15,
              maxZoom: 18,
              onPositionChanged: (MapPosition position, bool hasGesture) {},
              onMapReady: () {
                _mapController.mapEventStream.listen((evt) {});
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
                      points: _polygonPoints,
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
                      accuracy: LocationAccuracy.high,
                      distanceFilter: 100,
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
            child: Container(
              height: 120,
              width: dynamicWidth,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 51, 51, 51),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Cloud Computing Class",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Class Start: 8:00 PM",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.start,
                    ),
                    Text("Class End: 8:00 PM",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.start,
                    ),
                  ],),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "(by: Lolu Paul)",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
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
                    _isInsidePolygon
                        ? "Welcome, You are now in class"
                        : "You are  ${NumberFormat('##0.0#', 'en_US').format(distance / 1000)} km away from class",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 108,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () => (isLoading) ? null : clockIn(),
                  icon: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : const Icon(Icons.feedback,
                          color: Colors.transparent, size: 0),
                  label: SizedBox(
                    width: dynamicWidth,
                    child: isLoading
                        ? const Text(
                            "Clocking In...",
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            "Clock In",
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clockIn() async {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> getClass() async {
    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? classID = prefs.getString('classID');

    } catch (e) {}
  }
}
