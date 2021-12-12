import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Historis extends StatefulWidget {
  @override
  _HistorisState createState() => _HistorisState();
}

class _HistorisState extends State<Historis> {
  var orderid = ["123-456-789", "123-456-789", "123-456-789", "123-456-789"];
  var alamat = [
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  ];
  var estimasi = [
    "Senin, 22 November 2021",
    "Senin, 22 November 2021",
    "Senin, 22 November 2021",
    "Senin, 22 November 2021",
  ];
  var status = [
    "Selesai",
    "Batal",
    "Proses",
    "Dalam Perjalanan",
  ];
  var volume = [
    "10",
    "10",
    "10",
    "10",
  ];

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _selectedNavbar = 1;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                      color: Colors.white,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text("Semua"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xffE7EEF4),
                              ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                    )
                                )
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Selesai"),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Proses"),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Konfirmasi"),
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
                              for (var i = 0; i < orderid.length; i++)
                                RC_Historis(
                                  orderid: orderid[i],
                                  alamat: alamat[i],
                                  estimasi: estimasi[i],
                                  status: status[i],
                                  volume: volume[i],
                                  color: Colors.blue,
                                )
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                              // RC_Historis(orderid: '123-456-111', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Batal', volume: '10', color: Colors.red,),
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                            ],
                          ),
                        ),
                      ),
                    )
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
                        pageBuilder: (c, a1, a2) => Tutorial(),
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
  }
}

class RC_Historis extends StatelessWidget {
  RC_Historis(
      {required this.orderid,
      required this.alamat,
      required this.estimasi,
      required this.status,
      required this.volume,
      required this.color});

  String orderid, alamat, estimasi, status, volume;
  Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Historis_Item_Selesai()));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
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
                  if (status == 'Selesai')
                    TextButton(
                    onPressed: () {},
                    child: Text("Selesai", style: TextStyle(color: Colors.green),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xffECF8ED),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                  ),
                  if (status == 'Batal')
                    TextButton(
                    onPressed: () {},
                    child: Text("Batal", style: TextStyle(color: Colors.red),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xffFBE8E8),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                  ),
                  if (status == 'Proses')
                    TextButton(
                      onPressed: () {},
                      child: Text("Proses", style: TextStyle(color: Colors.blueAccent),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffE7EEF4),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                          )
                      ),
                    ),
                  if (status == 'Dalam Perjalanan')
                    TextButton(
                      onPressed: () {},
                      child: Text("Dalam Perjalanan", style: TextStyle(color: Colors.orange),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffFEF5E8),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                          )
                      ),
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
