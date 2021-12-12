// @dart=2.9

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item.dart';
import 'package:http/http.dart' as http;

class PermintaanPenjemputan extends StatefulWidget {
  @override
  _PermintaanPenjemputanState createState() => _PermintaanPenjemputanState();
}

class _PermintaanPenjemputanState extends State<PermintaanPenjemputan> {
  var orderid = ["123-456-789", "123-456-789", "123-456-789", "123-456-789"];
  var alamat = [
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  ];
  var estimasi = [
    "-",
    "-",
    "-",
    "-",
  ];
  // var status = [
  //   "Selesai",
  //   "Selesai",
  //   "Selesai",
  //   "Selesai",
  // ];
  var volume = [
    "10",
    "10",
    "10",
    "10",
  ];

  // List _isikota = ["Semua Kota", "Jakarta"];
  // List _isiStatus = ["Semua Status", "Berhasil"];
  // late List<DropdownMenuItem<String>> _dropdownKota, _dropdownStatus;
  // late String _kotaterpilih, _statusterpilih;

  var _token;

  var i;

  var id = new List();
  var pickup_order_no = new List();
  var address = new List();
  var pickup_date = new List();
  var estimate_volume = new List();
  var status = new List();

  get_data() async {
    Map bodi = {
      "token": _token,
      "status": ["processed"],
      "start_date": null,
      "end_date": null
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/driver/pickup_orders/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print("ini Pick up : " + data.toString());

    for (i = 0; i < data['pickup_orders']['data'].length; i++) {
      setState(() {
        id.add(data['pickup_orders']['data'][i]['id'].toString());
        pickup_order_no.add(
            data['pickup_orders']['data'][i]['pickup_order_no'].toString());
        address.add(data['pickup_orders']['data'][i]['address']);
        pickup_date.add("-");
        estimate_volume.add(
            data['pickup_orders']['data'][i]['estimate_volume'].toString());
        status.add(data['pickup_orders']['data'][i]['status']);
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString("token");
        // _token = (preferences.getString('token') ?? '');
      },
    );
    get_data();
  }

  @override
  void initState() {
    // _dropdownKota = getDropdownKota();
    // _kotaterpilih = _dropdownKota[0].value!;
    //
    // _dropdownStatus = getDropdownStatus();
    // _statusterpilih = _dropdownStatus[0].value!;
    super.initState();
    getPref();
  }

  // List<DropdownMenuItem<String>> getDropdownKota() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String kota in _isikota) {
  //     items.add(new DropdownMenuItem(value: kota, child: new Text(kota)));
  //   }
  //   return items;
  // }
  //
  // List<DropdownMenuItem<String>> getDropdownStatus() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String status in _isiStatus) {
  //     items.add(new DropdownMenuItem(value: status, child: new Text(status)));
  //   }
  //   return items;
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
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
                "Permintaan Penjemputan",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Scrollbar(
                      showTrackOnHover: true,
                      isAlwaysShown: true,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < id.length; i++)
                              RC_PermintaanPenjemputan(
                                orderid: pickup_order_no[i],
                                alamat: address[i],
                                estimasi: pickup_date[i],
                                status: status[i],
                                volume: estimate_volume[i],
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void changedropdownKota(String? kotaTerpilih) {
  //   setState(() {
  //     _kotaterpilih = kotaTerpilih!;
  //   });
  // }

  // void changedropdownStatus(String? statusTerpilih) {
  //   setState(() {
  //     _statusterpilih = statusTerpilih!;
  //   });
  // }
}

class RC_PermintaanPenjemputan extends StatelessWidget {
  RC_PermintaanPenjemputan({
    this.orderid,
    this.alamat,
    this.estimasi,
    this.status,
    this.volume,
  });

  String orderid, alamat, estimasi, status, volume;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '21 November 2021',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                alamat,
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
                'Estimasi Penjemputan',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                estimasi,
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
                        volume + ' Liter',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (status == 'pending')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Pending",
                        style: TextStyle(color: Color(0xFF125894)),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7EEF4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
  }
}
