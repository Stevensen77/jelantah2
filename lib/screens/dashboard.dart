import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jelantah/screens/historis_item_map.dart';
import 'package:jelantah/screens/main_history_proses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/permintaan_penjemputan.dart';
import 'package:jelantah/screens/user_baru.dart';
import 'package:jelantah/screens/main_history_proses.dart';
import 'package:jelantah/screens/account.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/main_history_semua.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jelantah/screens/ubah_tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

import 'historis_item.dart';

import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback signOut;

  Dashboard(this.signOut);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var url = [
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw"
  ];
  var idyoutube = ["LvUYbxlSGHw", "LvUYbxlSGHw", "LvUYbxlSGHw"];
  var judul = [
    "Semua yang perlu kamu ketahui, Jelantah App",
    "judul2",
    "judul3"
  ];
  var deskripsi = ["youtube1", "youtube1", "youtube1"];
  var tanggal = ["10 Oktober 2021", "10 Oktober 2021", "10 Oktober 2021"];

  var orderid = ["123-456-789", "123-456-789", "123-456-789", "123-456-789"];

  var volume = [
    "10",
    "10",
    "10",
    "10",
  ];

  var nama;
  var token;
  var i;

  var id = [];
  var pickup_order_no = [];
  var nama_customer = [];
  var driver_id = [];
  var address = [];
  var pickup_date = [];
  var estimate_volume = [];
  var estimasi = [];
  var created_at = [];
  var status = [];
  var longitude = [];
  var latitude = [];

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  get_order() async {
    Map bodi = {
      "token": token,
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
        nama_customer.add(data['pickup_orders']['data'][i]['recipient_name']);
        driver_id.add(data['pickup_orders']['data'][i]['driver_id']);
        pickup_date.add(data['pickup_orders']['data'][i]['pickup_date']);
        created_at.add(data['pickup_orders']['data'][i]['created_at']);
        estimate_volume.add(
            data['pickup_orders']['data'][i]['estimate_volume'].toString());
        status.add(data['pickup_orders']['data'][i]['status']);
        latitude.add(data['pickup_orders']['data'][i]['latitude']);
        longitude.add(data['pickup_orders']['data'][i]['longitude']);
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        token = preferences.getString("token");
        nama = preferences.getString("nama");
        print("ini getpref token :" + token);
        get_nama();
        get_order();
      },
    );
  }

  get_nama() async {
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
      nama = data['user']['first_name'];
    });

    print("ini nama baru : " + nama);
  }

  savePref(String nama) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("nama", nama);
      preferences.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPref();
  }

  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate1)
      setState(() {
        String date1 = new DateFormat("d MMMM yyyy", "id_ID")
            .format(selectedDate1)
            .toString();
        selectedDate1 = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          body: Container(
            color: Color(0xFFF9FBFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo,",
                            style: TextStyle(
                              color: Colors.black, fontSize: 15, // 3
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            nama.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold // 3
                                ),
                          ),
                        ],
                      ),

                      /* Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingDataMaster()));
                            },
                            icon: Icon(
                              FlutterIcons.sliders_faw,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Account()));
                            },
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                          )
                        ],
                      )*/
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Divider(color: Colors.grey),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.card_travel,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Permintaan Penjemputan',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Historis()));
                            },
                            child: Text(
                              'Lihat semua',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Align(
                        child: Column(
                          children: [
                            for (var i = 0; i < id.length; i++)
                              RC_order(
                                  orderid: pickup_order_no[i],
                                  nama_customer: nama_customer[i],
                                  driver_id: driver_id[i],
                                  alamat: address[i],
                                  estimasi: pickup_date[i],
                                  created_at: created_at[i],
                                  status: status[i],
                                  volume: estimate_volume[i],
                                  latitude: latitude[i],
                                  longitude: longitude[i]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Video',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kelola Video',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < url.length; i++)
                            RC_Video(
                                url: url[i],
                                idyoutube: idyoutube[i],
                                judul: judul[i],
                                deskripsi: deskripsi[i],
                                tanggal: tanggal[i]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
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
    );
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
        signOut();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("Apakah anda ingin keluar dari apps?"),
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

class RC_Video extends StatelessWidget {
  RC_Video(
      {required this.url,
      required this.idyoutube,
      required this.judul,
      required this.deskripsi,
      required this.tanggal});

  String url, idyoutube, judul, deskripsi, tanggal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var urllaunchable =
            await canLaunch(url); //canLaunch is from url_launcher package
        if (urllaunchable) {
          await launch(url); //launch is from url_launcher package to launch URL
        } else {
          print("URL can't be launched.");
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://img.youtube.com/vi/$idyoutube/0.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: 230,
                  child: Row(
                    children: [
                      Flexible(
                        child: new Text(
                          judul,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RC_order extends StatelessWidget {
  RC_order(
      {required this.orderid,
      required this.alamat,
      required this.status,
      required this.volume,
      required this.estimasi,
      required this.created_at,
      required this.nama_customer,
      required this.driver_id,
      required this.latitude,
      required this.longitude});

  String orderid,
      alamat,
      estimasi,
      status,
      volume,
      nama_customer,
      latitude,
      longitude;
  int driver_id;
  var created_at;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await Permission.location.isGranted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Historis_Item_Map(
                  orderid: orderid,
                  alamat: alamat,
                  estimasi: estimasi,
                  created_at: created_at,
                  status: status,
                  volume: volume,
                  nama_customer: nama_customer,
                  driver_id: driver_id,
                  latitude: latitude,
                  longitude: longitude)));
        } else {
          await Permission.location.request();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Historis_Item_Map(
                  orderid: orderid,
                  alamat: alamat,
                  estimasi: estimasi,
                  created_at: created_at,
                  status: status,
                  volume: volume,
                  nama_customer: nama_customer,
                  driver_id: driver_id,
                  latitude: latitude,
                  longitude: longitude)));
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(1.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama_customer,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    alamat,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Volume : ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2F9EFC),
                        ),
                      ),
                      Text(
                        volume,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2F9EFC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
