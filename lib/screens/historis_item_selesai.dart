// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/account.dart';

import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/main_history_semua.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:http/http.dart' as http;

class Historis_Item_Selesai extends StatefulWidget {
  final String orderid;
  Historis_Item_Selesai({Key key, String this.orderid}) : super(key: key);
  @override
  _Historis_Item_SelesaiState createState() => _Historis_Item_SelesaiState();
}

class _Historis_Item_SelesaiState extends State<Historis_Item_Selesai> {
  var _token;

  var id = "";
  var pickup_order_no = "";
  var address = "";
  var pickup_date = "";
  var volume_tertimbang = "";
  var status = "";
  var tanggalOrder = "";
  var driver_id = "";
  var postal_code = "";
  var namaKota = "";
  var pemesan = "";
  var phone_number = "";
  var penerima = "";
  var price = "";
  var total_price = "";
  var i;

  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  get_CityID(idcity) async {
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/cities/$idcity/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var cityName = data['city']['name'].toString();
    setState(() {
      namaKota = cityName;
    });
    print(cityName);
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

  namaDriver(idDriver) async {
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/drivers/$idDriver/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var first_name = data['user']['first_name'];
    var last_name = data['user']['last_name'];
    var phone_number = data['user']['phone_number'];
    var dataDriver =
        first_name + " " + last_name + " " + "(" + phone_number + ")";
    setState(() {
      driver_id = dataDriver;
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

  get_data() async {
    var orderid = widget.orderid;
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/driver/pickup_orders/$orderid/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var tanggal = data['pickup_orders']['created_at'];
    var idcity = data['pickup_orders']['city_id'];
    var tanggalpickup = data['pickup_orders']['pickup_date'];
    var idDriver = data['pickup_orders']['driver_id'];
    setState(() {
      id = data['pickup_orders']['id'].toString();
      pickup_order_no = data['pickup_orders']['pickup_order_no'].toString();
      address = data['pickup_orders']['address'];
      pemesan = data['pickup_orders']['recipient_name'];
      phone_number = data['pickup_orders']['phone_number'];
      penerima = data['pickup_orders']['real_recipient_name'];
      get_CityID(idcity);
      if (data['pickup_orders']['pickup_date'] == null) {
        pickup_date = "-";
      } else {
        pickup_date = formatTanggalPickup(tanggalpickup);
      }
      if (data['pickup_orders']['driver_id'] == null) {
        driver_id = "-";
      } else {
        namaDriver(idDriver);
      }
      postal_code = data['pickup_orders']['postal_code'];
      volume_tertimbang = data['pickup_orders']['weighing_volume'].toString();
      status = data['pickup_orders']['status'];
      tanggalOrder = formatTanggal(tanggal);
      price = data['pickup_orders']['price'].toString();
      total_price = data['pickup_orders']['total_price'].toString();
    });
    print(data);
    // print(latitude);
    // print(longitude);
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString("token");
      },
    );
    get_data();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Order Selesai ID " + widget.orderid,
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Column(
            children: [
              Container(
                  width: 200,
                  child: FittedBox(
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      fit: BoxFit.fill)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              'ID ' + pickup_order_no,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tanggalOrder,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Divider(color: Colors.blue),
                      ),
                      Text(
                        'Penerima Order',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pemesan + " (" + phone_number + ")",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        address + ", " + namaKota + ", " + postal_code,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Tanggal Penjemputan',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pickup_date,
                        style: TextStyle(
                          fontSize: 12,
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
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        driver_id,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
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
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                volume_tertimbang + ' Liter',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga Beli',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                price + '/Liter',
                                style: TextStyle(
                                  fontSize: 12,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Harga',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp. ' + total_price + ',-',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (status == 'closed')
                            TextButton(
                              onPressed: () {},
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
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    );
  }
}
