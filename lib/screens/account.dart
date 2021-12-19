import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jelantah/screens/main_history_semua.dart';
//import 'package:jelantah/screens/pengaturan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/login_page.dart';

import 'package:jelantah/screens/chat_list.dart';
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

enum LoginStatus { notSignIn, signIn }

class _AccountState extends State<Account> {
  int _selectedNavbar = 3;
  var _token;

  var _first_name = "";
  var _last_name = "";
  var _email = "";
  var _address = "";
  var _phone_number = "";

  var status, _loginStatus;

  signOut() async {
    print("signout jalan");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("status", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  check() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/driver/session/delete"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    if (status == "success") {
      signOut();
    }
  }

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/driver/user/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(_token);
    setState(() {
      _first_name = data['user']['first_name'];
      _last_name = data['user']['last_name'];
      _email = data['user']['email'];
      _phone_number = data['user']['phone_number'];
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString('token');
        print(_token);
        status = preferences.getString("status");
        _loginStatus =
            status == "success" ? LoginStatus.signIn : LoginStatus.notSignIn;
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
        color: Color(0xffFDFEFF),
        // width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/mobil.PNG"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _first_name + " " + _last_name,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _address,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _email,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Nomer Telepon',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _phone_number,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 30.0,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Ubah Kata Sandi',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  child: Divider(
                color: Color(0xffF0F8FF),
                thickness: 15,
              )),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings,
                                size: 30.0,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Pengaturan',
                                style: TextStyle(
                                  fontSize: 20,
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
                                  /*   Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Pengaturan()));*/
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 30.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.only(right: 10.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.blue,
                    )),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
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
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Tentang aplikasi',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RawMaterialButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 30.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.only(right: 10.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.blue,
                    )),
                    GestureDetector(
                      onTap: () {
                        showAlertDialog(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 30.0,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
