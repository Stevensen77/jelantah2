import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserBaru extends StatefulWidget {

  @override
  _UserBaruState createState() => _UserBaruState();
}

class _UserBaruState extends State<UserBaru> {

  var nama = ["Dabiel Ardian","Muhamad Ichsan","Dimas Adi","Steven Sen"];
  var notelp = ["08787876667","08111112121","08111112121","08111112121"];
  var alamat = ["Jalan Cut Meutia No 1, Jakarta Barat, 11146","Tanjung Gedong","Tanjung Gedong","Tanjung Gedong"];

  //List cards = new List.generate( 1, (i)=>new RC_UserBaru(nama: isinama, notelp: isinotelp, alamat: isialamat));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "User Baru",
              style: TextStyle(
                color: Colors.black, // 3
              ),
            ),
            backgroundColor: Colors.grey,
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: Scrollbar(
                  showTrackOnHover: true,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(var i = 0; i < nama.length; i++)
                          RC_UserBaru(nama: nama[i], notelp: notelp[i], alamat: alamat[i],)
                        // RC_UserBaru(nama: 'Dabiel Ardian', notelp: '08787876667', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146',),
                        // RC_UserBaru(nama: 'Muhamad Ichsan', notelp: '08111112121', alamat: 'Tanjung Gedong',),
                        // RC_UserBaru(nama: 'Dimas Adi', notelp: '0822222222', alamat: 'Tanggerang Selatan',),
                        // RC_UserBaru(nama: 'Steven Sen', notelp: '0833333333', alamat: 'Jakarta Barat',),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

class RC_UserBaru extends StatelessWidget {

  RC_UserBaru({required this.nama, required this.notelp, required this.alamat});

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
              fontSize: 10,
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
              fontSize: 10,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            width: 70,
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
                onPressed: () {

                },
                child: Text('Setujui',
                    style:
                    TextStyle(fontSize: 12, color: Colors.white))),
          ),
          TextButton(
              onPressed: () {

              },
              child: Text('Tolak',
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
