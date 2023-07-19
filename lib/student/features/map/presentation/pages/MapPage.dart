import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(52.956158, -1.153108),
              zoom: 14,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                maxZoom: 18,
              ),
              PolygonLayer(
                polygonCulling: false,
                polygons: [
                  Polygon(
                      points: const[
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
                      isFilled: true
                  ),
                ],
              )
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
