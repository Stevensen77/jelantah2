import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  var _email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _email = (preferences.getString('email')??'');
      print(_email);
    },
    );
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
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Account",
              style: TextStyle(
                color: Colors.black, // 3
              ),
            ),
            backgroundColor: Colors.grey,
          ),
          body: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10,),
                    Text('Email', style: TextStyle(color: Colors.grey),),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextField(
                        controller: TextEditingController(text: "${_email}"),
                        //onSaved: (e) => email = e,
                        decoration: InputDecoration(
                          hintStyle:
                          TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 200),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                          onPressed: () {

                          },
                          child: Text('  Ubah Password  ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.white))),
                    ),
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
            },
            child: Icon(Icons.arrow_right_alt_sharp),
          ),
        ),
      ),
    );
  }
}
