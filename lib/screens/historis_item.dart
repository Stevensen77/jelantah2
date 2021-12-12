import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item_map.dart';
import 'package:intl/intl.dart';

class Historis_Item extends StatefulWidget {
  @override
  _Historis_ItemState createState() => _Historis_ItemState();
}

class _Historis_ItemState extends State<Historis_Item> {
  DateTime selectedDate1 = DateTime.now();

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

  List _isiDriver = ["Driver", "Ichsan", "Dimas", "steven"];
  late List<DropdownMenuItem<String>> _dropdownDriver;
  late String _driverterpilih;

  @override
  void initState() {
    _dropdownDriver = getDropdownDriver();
    _driverterpilih = _dropdownDriver[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropdownDriver() {
    List<DropdownMenuItem<String>> items = [];
    for (String driver in _isiDriver) {
      items.add(new DropdownMenuItem(value: driver, child: new Text(driver)));
    }
    return items;
  }

  void changedropdownDriver(String? driverTerpilih) {
    setState(() {
      _driverterpilih = driverTerpilih!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "123-456-789",
              style: TextStyle(
                color: Colors.black, // 3
              ),
            ),
            backgroundColor: Colors.grey,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 200,
                  child: FittedBox(
                      child: Icon(
                        Icons.timer,
                        color: Colors.black,
                      ),
                      fit: BoxFit.fill)),
              Container(
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
                      'Jalan Cut Meutia No 1, Jakarta Barat, 11146',
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
                      '-',
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Selesai',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
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
                              '10' + ' L',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
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
                    Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: kIsWeb
                          ? EdgeInsets.only(left: 135, right: 135)
                          : EdgeInsets.only(left: 85, right: 85),
                      color: Colors.white,
                      child: SizedBox(
                        height: 25,
                        child: OutlineButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${DateFormat("d MMMM yyyy", "id_ID").format(selectedDate1)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          onPressed: () => _selectDate1(context),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Pilih Driver',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: kIsWeb
                          ? EdgeInsets.only(left: 135, right: 135)
                          : EdgeInsets.only(left: 85, right: 85),
                      child: SizedBox(
                        height: 25,
                        child: OutlineButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {},
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: _driverterpilih,
                              items: _dropdownDriver,
                              onChanged: changedropdownDriver,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {},
            child: Icon(Icons.arrow_right_alt_sharp),
          ),
        ),
      ),
    );
  }
}
