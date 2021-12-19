import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/main_history_semua.dart';
import 'package:jelantah/screens/tambah_tutorial.dart';
import 'package:jelantah/screens/ubah_tutorial.dart';
import 'package:jelantah/screens/login_page.dart';

import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:url_launcher/url_launcher.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  var url = [
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw"
  ];
  var idyoutube = ["LvUYbxlSGHw", "LvUYbxlSGHw", "LvUYbxlSGHw"];
  var judul = ["judul1", "judul2", "judul3"];
  var deskripsi = ["youtube1", "youtube1", "youtube1"];
  var tanggal = ["10 Oktober 2021", "10 Oktober 2021", "10 Oktober 2021"];

  int _selectedNavbar = 3;

  List _isikategori = ["Tutorial", "Edukasi"];
  late List<DropdownMenuItem<String>> _dropdownKategori;
  late String _kategoriterpilih;

  @override
  void initState() {
    _dropdownKategori = getDropdownKategori();
    _kategoriterpilih = _dropdownKategori[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropdownKategori() {
    List<DropdownMenuItem<String>> items = [];
    for (String kategori in _isikategori) {
      items.add(
          new DropdownMenuItem(value: kategori, child: new Text(kategori)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 20),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    child: DropdownButton(
                      isExpanded: true,
                      value: _kategoriterpilih,
                      items: _dropdownKategori,
                      onChanged: changedropdownKategori,
                    ),
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
                            RC_Tutorial(
                                url: url[i],
                                idyoutube: idyoutube[i],
                                judul: judul[i],
                                deskripsi: deskripsi[i],
                                tanggal: tanggal[i]),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey,
                          //         offset: const Offset(1.0, 1.0),
                          //         blurRadius: 1.0,
                          //         spreadRadius: 1.0,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () async {
                          //           String url = "https://www.youtube.com/watch?v=LvUYbxlSGHw";
                          //           var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                          //           if(urllaunchable){
                          //             await launch(url); //launch is from url_launcher package to launch URL
                          //           }else{
                          //             print("URL can't be launched.");
                          //           }
                          //         },
                          //         child: Container(
                          //           padding: EdgeInsets.only(top: 70, bottom: 50, ),
                          //           decoration: BoxDecoration(
                          //             image: DecorationImage(
                          //               image: NetworkImage("https://img.youtube.com/vi/LvUYbxlSGHw/0.jpg"),
                          //               fit: BoxFit.cover,
                          //             ),
                          //             borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                          //           ),
                          //         ),
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //         children: [
                          //           Column(
                          //             children: [
                          //               Text(
                          //                 'Title',
                          //                 style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 'Description',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(width: 50),
                          //           Column(
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   IconButton(
                          //                     onPressed: () {
                          //                       Navigator.of(context).push(
                          //                           MaterialPageRoute(
                          //                               builder: (context) =>
                          //                                   UbahTutorial()));
                          //                     },
                          //                     icon: Icon(Icons.settings, color: Colors.black,),
                          //                   ),
                          //                   IconButton(
                          //                     onPressed: () {},
                          //                     icon: Icon(Icons.delete, color: Colors.black,),
                          //                   ),
                          //
                          //                 ],
                          //               ),
                          //               Text(
                          //                 '8 Oktober 2021',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey,
                          //         offset: const Offset(1.0, 1.0),
                          //         blurRadius: 1.0,
                          //         spreadRadius: 1.0,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.only(top: 70, bottom: 50, ),
                          //         decoration: BoxDecoration(
                          //           image: DecorationImage(
                          //             image: AssetImage("assets/images/truck.jpg"),
                          //             fit: BoxFit.cover,
                          //           ),
                          //           borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                          //         ),
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //         children: [
                          //           Column(
                          //             children: [
                          //               Text(
                          //                 'Title',
                          //                 style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 'Description',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(width: 50),
                          //           Column(
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   IconButton(
                          //                     onPressed: () {
                          //                       Navigator.of(context).push(
                          //                           MaterialPageRoute(
                          //                               builder: (context) =>
                          //                                   UbahTutorial()));
                          //                     },
                          //                     icon: Icon(Icons.settings, color: Colors.black,),
                          //                   ),
                          //                   IconButton(
                          //                     onPressed: () {},
                          //                     icon: Icon(Icons.delete, color: Colors.black,),
                          //                   ),
                          //
                          //                 ],
                          //               ),
                          //               Text(
                          //                 '8 Oktober 2021',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey,
                          //         offset: const Offset(1.0, 1.0),
                          //         blurRadius: 1.0,
                          //         spreadRadius: 1.0,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.only(top: 70, bottom: 50, ),
                          //         decoration: BoxDecoration(
                          //           image: DecorationImage(
                          //             image: AssetImage("assets/images/truck.jpg"),
                          //             fit: BoxFit.cover,
                          //           ),
                          //           borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                          //         ),
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //         children: [
                          //           Column(
                          //             children: [
                          //               Text(
                          //                 'Title',
                          //                 style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 'Description',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(width: 50),
                          //           Column(
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   IconButton(
                          //                     onPressed: () {
                          //                       Navigator.of(context).push(
                          //                           MaterialPageRoute(
                          //                               builder: (context) =>
                          //                                   UbahTutorial()));
                          //                     },
                          //                     icon: Icon(Icons.settings, color: Colors.black,),
                          //                   ),
                          //                   IconButton(
                          //                     onPressed: () {},
                          //                     icon: Icon(Icons.delete, color: Colors.black,),
                          //                   ),
                          //
                          //                 ],
                          //               ),
                          //               Text(
                          //                 '8 Oktober 2021',
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 30),
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tambah Tutorial\n& Edukasi',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 100),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TambahTutorial()));
                            },
                            elevation: 2.0,
                            fillColor: Colors.blue,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
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

  void changedropdownKategori(String? kategoriTerpilih) {
    setState(() {
      _kategoriterpilih = kategoriTerpilih!;
    });
  }
}

class RC_Tutorial extends StatelessWidget {
  RC_Tutorial(
      {required this.url,
      required this.idyoutube,
      required this.judul,
      required this.deskripsi,
      required this.tanggal});
  String url, idyoutube, judul, deskripsi, tanggal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
          GestureDetector(
            onTap: () async {
              var urllaunchable =
                  await canLaunch(url); //canLaunch is from url_launcher package
              if (urllaunchable) {
                await launch(
                    url); //launch is from url_launcher package to launch URL
              } else {
                print("URL can't be launched.");
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 70,
                bottom: 50,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://img.youtube.com/vi/$idyoutube/0.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    judul,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    deskripsi,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 50),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UbahTutorial()));
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    tanggal,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
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
        ],
      ),
    );
  }
}
