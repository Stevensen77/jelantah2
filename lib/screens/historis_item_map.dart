import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:jelantah/screens/historis_map_on_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';

class Historis_Item_Map extends StatefulWidget {
  final String orderid;
  var alamat;
  var estimasi;
  var status;
  var volume;
  var nama_customer;
  var driver_id;

  Historis_Item_Map(
      {required String this.orderid,
      required String this.alamat,
      required String this.estimasi,
      required String this.status,
      required String this.volume,
      required String this.nama_customer,
      required int this.driver_id});

  @override
  _Historis_Item_MapState createState() => _Historis_Item_MapState();
}

class _Historis_Item_MapState extends State<Historis_Item_Map> {
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
  bool _loading = true;

  var initialCameraPosition;
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

  DateTime now1 = DateTime.now();
  var formatter = new DateFormat('dd MMMM yyyy');

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

    //getPref();

    polylinePoints = PolylinePoints();

    // set up initial locations
    //this.setInitialLocation();
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
      lat = _currentLocation.latitude.toString();
      lng = _currentLocation.longitude.toString();

      currentLocation = LatLng(double.parse(lat), double.parse(lng));
      destinationLocation =
          LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
      _loading = false;

      initialCameraPosition = CameraPosition(
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          //target: LatLng(6, 6)
          target: LatLng(double.parse(lat), double.parse(lng)));
      //currentLocation = currentLocation;
    });
    print('center $_currentLocation');

    /*_markers.add(
      Marker(
        markerId: MarkerId("Lokasi"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );*/
  }

  getPref() async {
    currentLocation = LatLng(double.parse(lat), double.parse(lng));

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    DateTime tgl_sementara =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.estimasi);
    var formattedDate = formatter.format(tgl_sementara);

    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Detail Permintaan",
              style: TextStyle(
                color: Color(0xff002B50), // 3
              ),
            ),
            backgroundColor: Colors.white70,
          ),
          body: Stack(
            children: [
              Container(child: getBody()
                  // GoogleMap(
                  //   mapType: MapType.normal,
                  //   polylines: _polylines,
                  //   markers: _markers,
                  //   initialCameraPosition: initialCameraPosition,
                  //   onTap: (LatLng loc) {
                  //     setState(() {
                  //       this.pinPillPosition = PIN_INVISIBLE_POSITION;
                  //       this.userBadgeSelected = false;
                  //     });
                  //   },
                  //   onMapCreated: (GoogleMapController controller) {
                  //     _controller.complete(controller);
                  //
                  //     showPinsOnMap();
                  //     setPolylines();
                  //   },
                  // ),
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
                        color: Color(0xff70AFE5),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${widget.orderid}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Color(0xff002B50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            " ${formattedDate}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff70AFE5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ${widget.alamat}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Estimasi Penjemputan',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ${widget.estimasi}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Driver',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ${widget.driver_id}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Total Volume',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ${widget.volume}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*   INI UNTUK YANG ROW KEBAGI 2 HORIZONTAL
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff70AFE5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dalam Perjalanan',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff002B50),
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
                                  color: Color(0xff70AFE5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10' + ' L',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff002B50),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),*/
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff125894),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Historis_Map_On_Pickup()));
                              },
                              child: Text('Pick Up Sekarang',
                                  style: TextStyle(color: Colors.white))),
                        ),
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

  Widget getBody() {
    if (_loading) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ));
    } else {
      // CameraPosition initialCameraPosition = CameraPosition(
      //     zoom: CAMERA_ZOOM,
      //     tilt: CAMERA_TILT,
      //     bearing: CAMERA_BEARING,
      //     //target: LatLng(6, 6)
      //     target: LatLng(double.parse(lat), double.parse(lng)));
      return GoogleMap(
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
      );
    }
    return Container();
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
