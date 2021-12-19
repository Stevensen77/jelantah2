import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/models/responsePickup.dart';
import 'package:jelantah/screens/chat_list.dart';

import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:jelantah/screens/main_history_batal.dart';

import 'package:jelantah/screens/main_history_proses.dart';
import 'package:jelantah/screens/main_history_selesai.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
// import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:intl/intl.dart';
// import 'package:jelantah/screens/login_page.dart';
// import 'package:jelantah/screens/historis.dart';
// import 'package:jelantah/screens/chat_list.dart';
// import 'package:jelantah/screens/tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/account.dart';

import 'dashboard.dart';
import 'package:jelantah/screens/historis_item_batal.dart';
import 'package:jelantah/screens/login_page.dart';
//import 'package:jelantah/screens/main_history_batal.dart';
//import 'package:jelantah/screens/main_history_selesai.dart';

class Historis extends StatefulWidget {
  @override
  _HistorisState createState() => _HistorisState();
}

enum LoginStatus { notSignIn, signIn }

class _HistorisState extends State<Historis> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  var _orderid;
  var _alamat;
  var _estimasi;
  var _status;
  var _volume;
  var _created_date;

  var status;
  late final VoidCallback signOut;

  late bool _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _defaultPerPageCount = 15;
  late List<Datum> _pickuporderno;
  final int _nextPageThreshold = 0;

  var _token;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    //setState(
    //  () {},
    //);
  }

  Future<void> fetchDataPickupOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        status = preferences.getString("status");
        _token = (preferences.getString('token') ?? '');

        _loginStatus =
            status == "success" ? LoginStatus.signIn : LoginStatus.notSignIn;
      });
    }
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    try {
      Map bodi = {
        "token": _token,
        "status": [
          "processed",
          "cancelled_by_driver",
          "on_pickup",
          "driver",
          "rejected",
          "closed"
        ]
      };
      var body = jsonEncode(bodi);

      //print("bodyy: " + body);
      final response = await http.post(
          Uri.parse(
              "http://10.0.2.2:8000/api/driver/pickup_orders/get?page=$_pageNumber"),
          body: body);
      ResponsePickup _data = responsePickupFromJson(response.body);
      //developer.log(response.body);
      String statusrespon = _data.status;
      //print("statusnnyaa: " + statusrespon);
      // int current_page = _data.pickupOrders.currentPage;
      // print("current_page: " + current_page.toString());
      // String pno = _data.pickupOrders.data[0].pickupOrderNo;
      // print("data: " + pno);
      // print("length " + _data.pickupOrders.data.length.toString());

      setState(() {
        for (int i = 0; i < _data.pickupOrders.data.length; i++) {
          _orderid.add(_data.pickupOrders.data[i].pickupOrderNo.toString());
          _alamat.add(_data.pickupOrders.data[i].address.toString());
          var _GETestimasi = _data.pickupOrders.data[i].pickupDate;
          if (_GETestimasi == null) {
            _estimasi.add("-");
          } else {
            _estimasi.add(_GETestimasi);
          }
          _volume.add(_data.pickupOrders.data[i].estimateVolume.toString());
          _status.add(_data.pickupOrders.data[i].status.toString());

          String date = _data.pickupOrders.data[i].createdAt.toString();
          var dateTime = DateTime.parse(date);
          _created_date.add(
              DateFormat('dd MMMM yyyy', "id_ID").format(dateTime).toString());
        }
        _hasMore = _data.pickupOrders.data.length == _defaultPerPageCount;
        print("hasmoreee" + _hasMore.toString());
        _loading = false;
        _pageNumber = _pageNumber + 1;
        print("pagenumber:" + _pageNumber.toString());
        print("orderid: " + _orderid.toString());
      });

      // print("orderid: " + _orderid.toString());
    } catch (e) {
      print("catch main history: " + e.toString());
      setState(() {
        _loading = false;
        _error = true;
      });
    }
    // print("hasmore bwh: " + _hasMore.toString());
    // print("pagenumber bwh: " + _pageNumber.toString());
    // print("orderid: " + _orderid.toString());
    // print("alamat: " + _alamat.toString());
    // print("volume: " + _volume.toString());
    // print("status: " + _status.toString());
    // print("estimasi" + _estimasi.toString());
    // print("created_date: " + _created_date.toString());
  }

  pembatalan(String getorderid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");

    Map bodi = {"token": _token};
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/contributor/pickup_orders/$getorderid/cancel/post"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String message = data['message'];
    //print("Ini status PEMBATALAN : " + status);

    if (status == "success") {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Historis_Item_Batal(orderid: getorderid)));
      });
    } else {
      print(message);
    }
  }

  changedate(String getorderid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");

    Map bodi = {"token": _token};
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/contributor/pickup_orders/$getorderid/reschedule/post"),
        body: body);
    final data = jsonDecode(response.body);

    String status = data['status'];
    String message = data['message'];
    //print("Ini status PEMBATALAN : " + status);

    if (status == "success") {
      setState(() {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => Historis(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      });
    } else {
      print(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPref();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _orderid = [];
    _alamat = [];
    _estimasi = [];
    _status = [];
    _volume = [];
    _created_date = [];

    fetchDataPickupOrder();
  }

  int _selectedNavbar = 1;

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.signIn:
        return Center(
          child: Container(
            width: kIsWeb ? 500.0 : double.infinity,
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                    title: Text(
                      "Riwayat",
                      style: TextStyle(
                        color: Colors.blue, // 3
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0),
                body: Center(
                  child: Container(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          color: Colors.white,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => Historis(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: Text("Semua"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xffE7EEF4),
                                    ),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          HistorisProses(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: Text("Proses"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          HistorisSelesai(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: Text("Selesai"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          HistorisBatal(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: Text("Batal"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: getBody(),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      title: Text('Beranda'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FlutterIcons.file_text_o_faw),
                      title: Text('Riwayat'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_outlined),
                      title: Text('Pesan'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      title: Text('Profil'),
                    ),
                  ],
                  currentIndex: _selectedNavbar,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.blueGrey,
                  showUnselectedLabels: true,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => LoginPage(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 200),
                          ),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => Historis(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 300),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => ChatList(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 300),
                          ),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => Account(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 300),
                          ),
                        );
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        );
      case LoginStatus.notSignIn:
        return Dashboard(this.signOut);
    }
  }

  Widget getBody() {
    if (_orderid.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchDataPickupOrder();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Gagal loading, coba kembali..."),
          ),
        ));
      }
    } else {
      return ListView.builder(
          itemCount: _orderid.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            var itemcount = _orderid.length + (_hasMore ? 1 : 0);
            print("itemcount: " + itemcount.toString());
            print("idlength: " + _orderid.length.toString());
            print("indexke: " + index.toString());
            if (index == _orderid.length - _nextPageThreshold) {
              fetchDataPickupOrder();
            }
            if (index == _orderid.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _error = false;
                      fetchDataPickupOrder();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error ketika loading, coba kembali..."),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            //final Photo photo = _photos[index];
            final orderid = _orderid[index];
            final alamat = _alamat[index];
            final estimasi = _estimasi[index];
            final volume = _volume[index];
            final status = _status[index];
            final created_date = _created_date[index];

            // return Card(
            //   child: Column(
            //     children: <Widget>[
            //       Image.network(
            //         photo.thumbnailUrl,
            //         fit: BoxFit.fitWidth,
            //         width: double.infinity,
            //         height: 160,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(16),
            //         child: Text(photo.title,
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 16)),
            //       ),
            //     ],
            //   ),
            // );
            return GestureDetector(
              onTap: () {
                // CONTAINER SELESAI + METHOD KE DETAIL ITEM SELESAI
                if (status == 'closed') {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>
                          Historis_Item_Selesai(orderid: orderid),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                }
                //CONTAINER BATAL/TOLAK + METHOD ITEM BATAL/TOLAK
                if (status == 'rejected' ||
                    status == "cancelled" ||
                    status == "cancelled_by_driver" ||
                    status == "cancelled_by_contributor") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>
                          Historis_Item_Batal(orderid: orderid),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                }

                // CONTAINER PENDING + METHOD CANCEL
                if (status == "pending") {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        child: Divider(
                                          color: Colors.blue,
                                          thickness: 5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Divider(color: Colors.blue),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Text(
                                      'Apa anda yakin ingin membatalkannya?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xffD61C1C),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          showAlertDialog_pembatalan(
                                              context, orderid);
                                        },
                                        child: Text('Batalkan Pengambilan',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
                // CONTAINER PROCESSED + METHOD CHANGE DATE
                if (status == "processed") {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        child: Divider(
                                          color: Colors.blue,
                                          thickness: 5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Divider(color: Colors.blue),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(231, 238, 244, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        showAlertDialog_changedate(
                                            context, orderid);
                                      },
                                      child: Text(
                                        'Permintaan Perubahan Jadwal',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(18, 88, 148, 1)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }

                if (status == "cancelled_by_contributor") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>
                          Historis_Item_Batal(orderid: orderid),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                }
                if (status == "cancelled_by_driver") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>
                          Historis_Item_Batal(orderid: orderid),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID ' + orderid,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 43, 80, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              created_date,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(155, 199, 237, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(155, 199, 237, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        alamat,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(77, 107, 132, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Estimasi Penjemputan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(155, 199, 237, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        estimasi,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(77, 107, 132, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Volume',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(155, 199, 237, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                volume + ' Liter',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(77, 107, 132, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (status == 'closed')
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        Historis_Item_Selesai(),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Selesai",
                                style: TextStyle(color: Colors.green),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffECF8ED),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == 'rejected')
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        Historis_Item_Batal(orderid: orderid),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Ditolak",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFBE8E8),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == "cancelled")
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        Historis_Item_Batal(orderid: orderid),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Dibatalkan Admin",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFBE8E8),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == "cancelled_by_contributor")
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        Historis_Item_Batal(orderid: orderid),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Dibatalkan Pengguna",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFBE8E8),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == "cancelled_by_driver")
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        Historis_Item_Batal(orderid: orderid),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Dibatalkan Driver",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFBE8E8),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == 'processed')
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Diproses",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffE7EEF4),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == "on_pickup")
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Dalam Perjalanan",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffE7EEF4),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          if (status == "change_date")
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Proses Ubah Tanggal",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffE7EEF4),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          // TOMBOL KECIL PENDING + METHOD CANCEL
                          if (status == 'pending')
                            TextButton(
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      child: Divider(
                                                        color: Colors.blue,
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
                                                  'Apa anda yakin ingin membatalkannya?',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffD61C1C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        showAlertDialog_pembatalan(
                                                            context, orderid);
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
                              child: Text(
                                "Menunggu Konfirmasi",
                                style: TextStyle(color: Colors.orange),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFEF5E8),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }
    return Container();
  }

  void showAlertDialog_pembatalan(BuildContext context, String orderid) {
    // set up the buttons
    String getorderid = orderid;
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        pembatalan(getorderid);
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

  void showAlertDialog_changedate(BuildContext context, String orderid) {
    // set up the buttons
    String getorderid = orderid;
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        changedate(getorderid);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ubah Tanggal Penjemputan"),
      content: Text("Apakah yakin ingin meminta perubahan tanggal jemput?"),
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

// class RC_Historis extends StatelessWidget {
//   RC_Historis({
//     required this.orderid,
//     required this.alamat,
//     required this.estimasi,
//     required this.status,
//     required this.volume,
//     required this.color,
//     required this.created_date,
//   });
//
//   String orderid, alamat, estimasi, status, volume, created_date;
//   Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigator.of(context).push(
//         //     MaterialPageRoute(builder: (context) => Historis_Item_Selesai()));
//       },
//       child: Container(
//         margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(10)),
//         child: Container(
//           margin: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.only(
//                   top: 10,
//                   bottom: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(10.0)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'ID ' + orderid,
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       created_date,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 'Alamat',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 alamat,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Estimasi Penjemputan',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 estimasi,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Total Volume',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         volume + ' Liter',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (status == 'Selesai')
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Selesai",
//                         style: TextStyle(color: Colors.green),
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             Color(0xffECF8ED),
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ))),
//                     ),
//                   if (status == 'Batal')
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Batal",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             Color(0xffFBE8E8),
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ))),
//                     ),
//                   if (status == 'Proses')
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Proses",
//                         style: TextStyle(color: Colors.blueAccent),
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             Color(0xffE7EEF4),
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ))),
//                     ),
//                   if (status == 'Dalam Perjalanan')
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Dalam Perjalanan",
//                         style: TextStyle(color: Colors.orange),
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             Color(0xffFEF5E8),
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ))),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
