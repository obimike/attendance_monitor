import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isClockedOutLoading = false;
  bool isClass = false;
  bool hasAttendance_ = false;
  bool hasClockedOut_ = false;
  String classCit = "";
  String classCot = "";
  String name = "";
  String adminName = "";

  @override
  void initState() {
    super.initState();
    _checkForTodayClass();
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

  void _checkForTodayClass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAttendance = prefs.getBool("hasAttended") ?? false;
    bool hasClockedOut = prefs.getBool("hasClockedOut") ?? false;
    final String? classCit_ = prefs.getString('classCit');
    final String? classCot_ = prefs.getString('classCot');
    final String? name_ = prefs.getString('className');
    final String? adminName_ = prefs.getString('adminName');
    final List<String>? days_ = prefs.getStringList('classDays');

    //get what day it is today
    DateTime today = DateTime.now();
    var format = DateFormat.EEEE();
    var dayOfTheWeek = format.format(today);

    List<String> daysNotnull = days_ ?? [];
    String nameNotnull = name_ ?? "";

    print(daysNotnull.contains(dayOfTheWeek));
    print(days_);
    print(classCot_);
    print(daysNotnull);
    print((dayOfTheWeek));

    print("----------------------------------------------------------------");

    // check if it matches the any in the selected class day
    if (daysNotnull.contains(dayOfTheWeek)) {
      setState(() {
        hasClockedOut_ = hasClockedOut;
        hasAttendance_ = hasAttendance;
        isClass = true;
        classCit = classCit_!;
        classCot = classCot_!;
        name = nameNotnull;
        adminName = adminName_!;
      });
    } else {
      setState(() {
        isClass = false;
      });
    }
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
          isClass
              ? Positioned(
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
                          "$name Class",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Class Starts: $classCit",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Class Ends:  $classCot",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "(by:  $adminName)",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  child: Container(
                    height: 64,
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
                          "You have no class today",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
          isClass
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 84,
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
                )
              : const SizedBox(),
          _isInsidePolygon
              ? isClass
                  ? Positioned(
                      bottom: 100,
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
                                  : Text(
                                      hasAttendance_
                                          ? "Clocked In"
                                          : "Clock In",
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
          _isInsidePolygon
              ? isClass
                  ? Positioned(
                      bottom: 100,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 180,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                (isClockedOutLoading) ? null : clockOut(),
                            icon: isClockedOutLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                                : const Icon(Icons.feedback,
                                    color: Colors.transparent, size: 0),
                            label: SizedBox(
                              width: dynamicWidth,
                              child: isClockedOutLoading
                                  ? const Text(
                                      "Clocking Out...",
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      hasClockedOut_
                                          ? "Clocked Out"
                                          : "Clock Out",
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
        ],
      ),
    );
  }

  clockIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAttendance = prefs.getBool("hasAttended") ?? false;
    String classCotTimestamp = prefs.getString("classCotTimestamp") ?? "";
    String classCitTimestamp = prefs.getString("classCitTimestamp") ?? "";
    String? classID_ = prefs.getString('classID');
    final db = FirebaseFirestore.instance;

    if (_isInsidePolygon) {
      if (hasAttendance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'You have clocked in already!',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        //  set isLoading to true
        setState(() {
          isLoading = true;
        });

        //  set a timestamp for current time and date in UTC
        DateTime citTime = DateTime.now();

        //  add 10min to the set a timestamp
        DateTime cotTime = citTime.add(const Duration(minutes: 10));

        //  get studentID
        final userid = await FirebaseAuth.instance.currentUser?.uid;
        DateTime endOfClassTime = DateTime.parse(classCotTimestamp);
        DateTime startOfClassTime = DateTime.parse(classCitTimestamp);

        if(isTimeGreaterOrEqual(startOfClassTime, citTime)){
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                'Class has not started, you cant clock In now!',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          if (isTimeGreaterThanDateTimeBy10Minutes(endOfClassTime, citTime)) {
            //  if true save data to firebase firestore
            final attendance = <String, dynamic>{
              "cit": citTime,
              "cot": cotTime,
              "classID": classID_,
              "date": citTime,
              "studentID": userid,
            };
            print(attendance);
            try {
              final attendanceID = await db
                  .collection("attendance")
                  .add(attendance)
                  .onError((e, _) => throw (e.toString()));

              // set attendance ID
              print(attendanceID.id);
              prefs.setString("attendanceID", attendanceID.id);
              //  set hasAttendance to true
              prefs.setBool("hasAttended", true);
              prefs.setBool("hasClockedOut", false);

              _checkForTodayClass();

              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    'You have successfully clocked in!',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            } catch (e) {
              //  if error handle with snack bar
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    'An error has occurred while clocking In!',
                    style: TextStyle(fontSize: 20, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 5), //
                ),
              );
            }
          } else {
            setState(() {
              isLoading = false;
            });
            //  if false denial student from clocking In
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Class is over for today, you cant clock In!',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      }
    }
  }

  clockOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAttendance = prefs.getBool("hasAttended") ?? false;
    bool hasClockedOut = prefs.getBool("hasClockedOut") ?? false;
    String classCotTimestamp = prefs.getString("classCotTimestamp") ?? "";
    String attendanceID = prefs.getString("attendanceID") ?? "";
    DateTime currentTime = DateTime.now();
    final db = FirebaseFirestore.instance;

    if (_isInsidePolygon) {
      if (hasAttendance) {
        //set loading to true
        setState(() {
          isClockedOutLoading = true;
        });
        DateTime endOfClassTime = DateTime.parse(classCotTimestamp);
        //check if class ends time is equal or less than clocked out time
        print(endOfClassTime);
        print(currentTime);

        if (hasClockedOut) {
          setState(() {
            isClockedOutLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                'You have ClockedOut Already!',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          if (isTimeGreaterOrEqual(endOfClassTime, currentTime)) {
            //if true clocked out - update firestore

            try {
              await db
                  .collection("attendance")
                  .doc(attendanceID)
                  .update({"cot": currentTime}).catchError((e) {
                throw Exception(e.toString());
              });
              prefs.setBool("hasClockedOut", true);
              //refresh state
              _checkForTodayClass();

              setState(() {
                isClockedOutLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    'You have successfully clocked Out!',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            } catch (e) {
              //  if error handle with snack bar
              setState(() {
                isClockedOutLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    'An error has occurred while clocking Out!',
                    style: TextStyle(fontSize: 20, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 5), //
                ),
              );
            }
          } else {
            setState(() {
              isClockedOutLoading = false;
            });
            //if false display a snack bar saying Class is over for today, you cant clock out!
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Class is over for today, you cant clock out!',
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'You cant ClockOut, When you are yet to ClockIn!',
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  bool isTimeGreaterOrEqual(DateTime dateTime1, DateTime dateTime2) {
    // Get the time components from each DateTime
    int hour1 = dateTime1.hour;
    int minute1 = dateTime1.minute;
    int second1 = dateTime1.second;

    print("dateTime 1 : $hour1 $minute1 $second1");

    int hour2 = dateTime2.hour;
    int minute2 = dateTime2.minute;
    int second2 = dateTime2.second;


    print("dateTime 2 : $hour2 $minute2 $second2");

    // Compare the time components
    if (hour1 > hour2) {
      return true;
    } else if (hour1 == hour2) {
      if (minute1 > minute2) {
        return true;
      } else if (minute1 == minute2) {
        if (second1 >= second2) {
          return true;
        }
      }
    }

    return false;
  }

  bool isTimeGreaterThanDateTimeBy10Minutes(DateTime time, DateTime dateTime) {
    // Extract the hour and minute components from the TimeOfDay
    int hour = time.hour;
    int minute = time.minute;

    // Get the hour and minute components from the DateTime
    int dateTimeHour = dateTime.hour;
    int dateTimeMinute = dateTime.minute;

    // Calculate the difference in minutes between the time and DateTime
    int differenceInMinutes = (hour - dateTimeHour) * 60 + (minute - dateTimeMinute);

    // Check if the difference is greater than or equal to 10 minutes
    return differenceInMinutes >= 10;
  }
}
