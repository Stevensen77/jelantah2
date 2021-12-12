import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TambahBerhasil extends StatefulWidget {

  @override
  _TambahBerhasilState createState() => _TambahBerhasilState();
}

class _TambahBerhasilState extends State<TambahBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 200),
                  width: 200,
                  child: FittedBox(
                      child: Icon(Icons.check_circle_outline, color: Colors.green,),
                      fit: BoxFit.fill)),
              Container(
                margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Column(
                  children: [
                    Text(
                      'Berhasil membuat tutorial dan edukasi baru',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
