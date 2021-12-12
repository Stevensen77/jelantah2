import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';

class Historis_Map_Input_Penerima extends StatefulWidget {
  @override
  _Historis_Map_Input_PenerimaState createState() =>
      _Historis_Map_Input_PenerimaState();
}

class _Historis_Map_Input_PenerimaState
    extends State<Historis_Map_Input_Penerima> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  var _currentLocation;
  var lng;
  var lat;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  double pinPillPosition = PIN_VISIBLE_POSITION;
  bool userBadgeSelected = false;

  static const LatLng DEST_LOCATION =
      LatLng(-6.167522793690853, 106.79111424124224);

  static const double CAMERA_ZOOM = 14;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 0;
  static const double PIN_VISIBLE_POSITION = 20;
  static const double PIN_INVISIBLE_POSITION = -220;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  var id_order = "ID 1111";
  DateTime now1 = DateTime.now();
  late String formattedDate;
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  //LatLng _currentPosition = LatLng(-6.168128517426338, 106.79157069327144);

  @override
  void initState() {
    super.initState();
    getUserLocation();
    getPref();
    polylinePoints = PolylinePoints();
    setWaktu();

    // set up initial locations
    //this.setInitialLocation();
  }

  setWaktu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var formatter = new DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(now1);

    setState(() {
      preferences.setString("formattedDate", formattedDate);
    });
    print('date $formattedDate');
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    _currentLocation = await locateUser();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      /* _currentPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);*/
      preferences.setString("lat", _currentLocation.latitude.toString());
      preferences.setString("lng", _currentLocation.longitude.toString());
      //currentLocation = currentLocation;
    });
    print('center $_currentLocation');
    print('lat' + _currentLocation.longitude.toString());

    /*_markers.add(
      Marker(
        markerId: MarkerId("Lokasi"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );*/
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lat = preferences.getString("lat");
      lng = preferences.getString('lng');
    });

    currentLocation = LatLng(double.parse(lat), double.parse(lng));

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: LatLng(double.parse(lat), double.parse(lng)));

    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Data Permintaan",
              style: TextStyle(
                color: Colors.black, // 3
              ),
            ),
            backgroundColor: Colors.grey,
          ),
          body: Stack(
            children: [
              Container(
                child: GoogleMap(
                  mapType: MapType.normal,
                  polylines: _polylines,
                  markers: _markers,
                  initialCameraPosition: initialCameraPosition,
                  onTap: (LatLng loc) {
                    setState(() {
                      this.pinPillPosition = PIN_INVISIBLE_POSITION;
                      this.userBadgeSelected = false;
                    });
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);

                    showPinsOnMap();
                    setPolylines();
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: FractionalOffset.bottomCenter,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${id_order}" + "  ${formattedDate}",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Jalan Cut Meutia No 1, Jakarta Barat, 11146',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Estimasi Penjemputan',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Jumat, 30 Agustus 2021',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Driver',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ichsan (087654321)',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dalam Perjalanan',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            children: [
                              Text(
                                'Total Volume',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10' + ' L',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xffD61C1C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Historis_Item_Selesai()));
                                  },
                                  child: Text('Batalkan Pengambilan',
                                      style: TextStyle(color: Colors.white))),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: currentLocation,
          onTap: () {
            setState(() {
              this.userBadgeSelected = true;
            });
          }));

      _markers.add(Marker(
          markerId: MarkerId('destinationPin'),
          position: destinationLocation,
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyB5owSM6kOg8kISR455OprFqmKlrqXCDVA",
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            color: Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }
}
