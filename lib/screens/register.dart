import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String email, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response = await http.post(Uri.parse("http://192.168.8.102/flutter/register.php"),
        headers: {
          "Access-Control-Allow-Origin": "*"
        },
        body: {"nama": nama, "email": email, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Container(
          width: kIsWeb ? 500.0 : double.infinity,
          child: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert fullname";
                    }
                  },
                  onSaved: (e) => nama = e!,
                  decoration: InputDecoration(labelText: "Nama Lengkap"),
                ),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert email";
                    }
                  },
                  onSaved: (e) => email = e!,
                  decoration: InputDecoration(labelText: "email"),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e!,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert Password";
                    }
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Register"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}