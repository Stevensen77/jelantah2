import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';

class ChatList extends StatefulWidget {

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  int _selectedNavbar = 2;

  var nama = ["Daniel Ardian","Muhamad Ichsan","Dimas Adi","Steven Sen","Daniel Ardian"];
  var notelp = ["08787876667","08111112121","08111112121","08111112121","08111112121"];
  var alamat = ["Jalan Cut Meutia No 1, Jakarta Barat, 11146","Tanjung Gedong","Tanjung Gedong","Tanjung Gedong","Tanjung Gedong"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            body: Scrollbar(
              showTrackOnHover: true,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    for(var i = 0; i < nama.length; i++)
                      RC_ChatList(nama: nama[i], notelp: notelp[i], alamat: alamat[i],)

                    // RC_ChatList(nama: 'Dabiel Ardian', notelp: '08787876667', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146',),
                    // RC_ChatList(nama: 'Muhamad Ichsan', notelp: '08111112121', alamat: 'Tanjung Gedong',),
                    // RC_ChatList(nama: 'Dimas Adi', notelp: '0822222222', alamat: 'Tanggerang Selatan',),
                    // RC_ChatList(nama: 'Steven Sen', notelp: '0833333333', alamat: 'Jakarta Barat',),
                    // RC_ChatList(nama: 'Dimas', notelp: '0822222222', alamat: 'Tanggerang Selatan',),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: kIsWeb ? 500.0 : double.infinity,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.date_range_sharp),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mail_outline_rounded),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.video_collection_rounded),
                    title: Text(''),
                  ),
                ],
                currentIndex: _selectedNavbar,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => LoginPage(),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 200),
                        ),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Historis(),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 300),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => ChatList(),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 300),
                        ),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Tutorial(),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
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
      ),
    );
  }
}

class RC_ChatList extends StatelessWidget {

  RC_ChatList({required this.nama, required this.notelp, required this.alamat});

  String nama, notelp, alamat;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            ),
            child: Text(
              nama,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No Telp',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            notelp,
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
        ],
      ),
    );
  }
}
