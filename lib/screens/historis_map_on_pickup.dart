import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jelantah/screens/historis_item_selesai.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item_batal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Historis_Map_On_Pickup extends StatefulWidget {
  final String orderid;

  Historis_Map_On_Pickup({required String this.orderid});

  @override
  _Historis_Map_On_PickupState createState() => _Historis_Map_On_PickupState();
}

class _Historis_Map_On_PickupState extends State<Historis_Map_On_Pickup> {
  Completer<GoogleMapController> _controller = Completer();
  final _key = new GlobalKey<FormState>();
  final _key2 = new GlobalKey<FormState>();

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

  var id;
  var pickup_order_no;
  var nama_customer;
  var driver_id;
  var address;
  var created_at;
  var pickup_date;
  var estimate_volume;
  var estimasi;
  var status;
  var weighing_volume;
  var longitude_customer;
  var latitude_customer;
  var i;
  var nama_driver;
  late String input_penerima, input_volume_timbang, input_alasan;
  late TextEditingController _c = TextEditingController(),
      _d = TextEditingController(),
      _alasan = TextEditingController();

  late Timer looping_lokasi;

  //LatLng _currentPosition = LatLng(-6.168128517426338, 106.79157069327144);

  @override
  void initState() {
    super.initState();
    get_order();

    //getPref();

    polylinePoints = PolylinePoints();

    // set up initial locations
    //this.setInitialLocation();
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  inputLocation() async {
    // SIMPAN LOKASI DRIVER KE TABEL CHANGE LOCATION
    Map bodi = {"token": token, "latitude": lat, "longitude": lng};
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/driver/location/put"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String message = data['message'];
    print("Ini status Simpan lokasi : " + status);
    print("Ini Lat simpan lokasi driver : " + lat);
    print("Ini Long simpan lokasi driver : " + lng);
    print('center $_currentLocation');
  }

  getUserLocation() async {
    _currentLocation = await locateUser();
    // if (mounted) {
    setState(() {
      /* _currentPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);*/
      lat = _currentLocation.latitude.toString();
      lng = _currentLocation.longitude.toString();

      currentLocation = LatLng(double.parse(lat), double.parse(lng));
      DEST_LOCATION = LatLng(
          double.parse(latitude_customer), double.parse(longitude_customer));
      print("ini dest location map on pickup : " + DEST_LOCATION.toString());

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
    // }

    /*_markers.add(
      Marker(
        markerId: MarkerId("Lokasi"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );*/
  }

  get_order() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = (preferences.getString('token'));
      nama_driver = (preferences.getString("nama"));
    });

    Map bodi = {"token": token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2:8000/api/driver/pickup_orders/${widget.orderid}/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print("ini Pick up detail: " + data.toString());
    print("ini created date detail: " + data['pickup_orders']['created_at']);

    setState(() {
      id = data['pickup_orders']['id'].toString();
      pickup_order_no = data['pickup_orders']['pickup_order_no'].toString();
      address = data['pickup_orders']['address'];
      nama_customer = data['pickup_orders']['recipient_name'];
      driver_id = data['pickup_orders']['driver_id'];
      pickup_date = data['pickup_orders']['pickup_date'];
      created_at = data['pickup_orders']['created_at'];
      estimate_volume = data['pickup_orders']['estimate_volume'].toString();
      status = data['pickup_orders']['status'];
      weighing_volume = data['pickup_orders']['weighing_volume'];
      latitude_customer = data['pickup_orders']['latitude'];
      longitude_customer = data['pickup_orders']['longitude'];
    });

    get_nama();
    looping_lokasi = Timer.periodic(Duration(seconds: 5), (timer) {
      getUserLocation();
      inputLocation();
    });
    //getUserLocation();
  }

  void stop_update_lokasi() {
    looping_lokasi.cancel();
  }

  get_nama() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    token = (preferences.getString('token'));
    nama_driver = (preferences.getString("nama"));

    Map bodi = {"token": token};
    print("dibawah map bodi :" + token);
    var body = json.encode(bodi);

    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/driver/user/get"),
        body: body);
    final data = jsonDecode(response.body);
    print(data);
    String status = data['status'];

    print("Ini status : " + status);
    //print("Ini snama : " + nama);

    setState(() {
      nama_driver = data['user']['first_name'];
    });

    print("Nama driver : " + nama_driver);
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      selesaikan();
      stop_update_lokasi();
    } else {
      print("gagal");
    }
  }

  check_pembatalan() {
    final form2 = _key.currentState;
    if (form2!.validate()) {
      form2.save();
      pembatalan();
      stop_update_lokasi();
    } else {
      print("gagal");
    }
  }

  selesaikan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");

    Map bodi = {
      "token": token,
      "real_recipient_name": input_penerima,
      "weighing_volume": input_volume_timbang
    };
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/driver/pickup_orders/${widget.orderid}/close/post"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String message = data['message'];
    print("Ini status SELESAI : " + status);

    if (status == "success") {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Historis_Item_Selesai(orderid: widget.orderid)));
      });
    } else {
      print(message);
    }
  }

  pembatalan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");

    Map bodi = {"token": token, "cancel_reason": input_alasan};
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/driver/pickup_orders/${widget.orderid}/cancel/post"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String message = data['message'];
    print("Ini status PEMBATALAN : " + status);

    if (status == "success") {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Historis_Item_Batal(orderid: widget.orderid)));
      });
    } else {
      print(message);
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
    String tanggal_created_order = formatTanggal(created_at);
    String tanggal_pickup_order = formatTanggalPickup(pickup_date);

    /*var waktu_pickup = DateFormat("yyyy-MM-dd hh:mm:ss").format(pickup_date);
    print("ini waktu pickup " + waktu_pickup);*/

    /*   var date = DateTime.fromMillisecondsSinceEpoch(created_at * 1000);
    var tanggal_order_dibuat = DateFormat("dd MMMM yyyy").format(date);
    print("ini waktu order " + tanggal_order_dibuat);*/

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
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${widget.orderid}",
                            style: TextStyle(
                              fontSize: 20,
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
                              fontSize: 15,
                              color: Color(0xff70AFE5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                        " ${address}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
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
                        height: 10,
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
                        " ${nama_driver}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ${status}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Volume',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff70AFE5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " ${estimate_volume}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff002B50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _key,
                        child: GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff125894),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(45),
                                                topRight: Radius.circular(45)),
                                          ),
                                          backgroundColor: Colors.white,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              padding: EdgeInsets.all(30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            child: Divider(
                                                              color:
                                                                  Colors.blue,
                                                              thickness: 5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        child: Divider(
                                                            color: Colors.blue),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        'Penerima *',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff283c71)),
                                                        validator: (e) {
                                                          if (e!.isEmpty) {
                                                            return "Please insert penerima";
                                                          }
                                                        },
                                                        onSaved: (e) =>
                                                            input_penerima = e!,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Masukan nama penerima..",
                                                        ),
                                                        controller: _c,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        'Total Volume Timbang *',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff283c71)),
                                                        onSaved: (e) =>
                                                            input_volume_timbang =
                                                                e!,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Masukan volume timbang..",
                                                        ),
                                                        controller: _d,
                                                        validator: (e) {
                                                          if (e!.isEmpty) {
                                                            return "Please insert volume";
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff125894),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                input_penerima =
                                                                    _c.text;
                                                                input_volume_timbang =
                                                                    _d.text;
                                                              });
                                                              showAlertDialog(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                'Selesai Pengambilan',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Text('Selesai',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20))),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Form(
                              key: _key2,
                              child: Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(45),
                                                  topRight:
                                                      Radius.circular(45)),
                                            ),
                                            backgroundColor: Colors.white,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.all(30),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              child: Divider(
                                                                color:
                                                                    Colors.blue,
                                                                thickness: 5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Container(
                                                          child: Divider(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          'Alasan Pembatalan *',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff283c71)),
                                                          onSaved: (e) =>
                                                              input_alasan = e!,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Masukan alasan..",
                                                          ),
                                                          controller: _alasan,
                                                          validator: (e) {
                                                            if (e!.isEmpty) {
                                                              return "Please insert reason";
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffD61C1C),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  input_alasan =
                                                                      _alasan
                                                                          .text;
                                                                });

                                                                showAlertDialog_pembatalan(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Batalkan Pengambilan',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white))),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Text("Batalkan Pengambilan",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20)))))),
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

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        check();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Selesaikan order"),
      content: Text("Apakah ingin menyelesaikan order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialog_pembatalan(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        check_pembatalan();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Batalkan order"),
      content: Text("Apakah ingin membatalkan order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
