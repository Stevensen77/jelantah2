import 'dart:async';
import 'dart:convert';

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
import 'package:http/http.dart' as http;

class Historis_Item_Map extends StatefulWidget {
  final String orderid;
  var alamat;
  var estimasi;
  var created_at;
  var status;
  var volume;
  var nama_customer;
  var driver_id;
  var latitude;
  var longitude;

  Historis_Item_Map(
      {required String this.orderid,
      required String this.alamat,
      required String this.estimasi,
      required String this.created_at,
      required String this.status,
      required String this.volume,
      required String this.nama_customer,
      required int this.driver_id,
      required String this.latitude,
      required String this.longitude});

  @override
  _Historis_Item_MapState createState() => _Historis_Item_MapState();
}

class _Historis_Item_MapState extends State<Historis_Item_Map> {
  Completer<GoogleMapController> _controller = Completer();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Set<Marker> _markers = {};

  var _currentLocation;
  var lng;
  var lat;
  var token;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  double pinPillPosition = PIN_VISIBLE_POSITION;
  bool userBadgeSelected = false;
  bool _loading = true;

  var initialCameraPosition;
  late LatLng DEST_LOCATION = LatLng(0, 0);

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
      DEST_LOCATION =
          LatLng(double.parse(widget.latitude), double.parse(widget.longitude));
      print("ini dest location dari API : " + DEST_LOCATION.toString());

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
  }

  pickup_order() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = (preferences.getString('token'));
    });

    Map bodi = {"token": token};
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/driver/pickup_orders/${widget.orderid}/approve/post"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String pesan = data['message'];

    if (status == "success") {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Historis_Map_On_Pickup(
                  orderid: widget.orderid,
                )));
        savePref(status, pesan);
      });
      print("PickupOrderPesan" + pesan);
      print("PickupOrderStatus" + status);
    } else {
      //showAlertDialog(context);
      print("PickupOrderPesan" + pesan);
      print("PickupOrderStatus" + status);
    }
  }

  savePref(String status, String pesan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("status", status);
      preferences.setString("pesan", pesan);
    });
  }

  formatTanggal(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(datestring);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("d MMMM yyyy", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  formatTanggalPickup(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(datestring);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("d MMMM yyyy", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    String tanggal_created_order = formatTanggal(widget.created_at);
    String tanggal_pickup_order = formatTanggalPickup(widget.estimasi);

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
                            tanggal_created_order,
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
                        tanggal_pickup_order,
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
                                pickup_order();
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
        zoomGesturesEnabled: true,
        markers: _markers,
        initialCameraPosition: initialCameraPosition,
        minMaxZoomPreference: MinMaxZoomPreference(6, 19),
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
