import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jelantah/models/responseChatCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer A',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatCustomerPage(title: 'Customer 1'),
    );
  }
}

class ChatCustomerPage extends StatefulWidget {
  final String title;
  ChatCustomerPage({Key? key, required this.title}) : super(key: key);

  @override
  _ChatCustomerPageState createState() => _ChatCustomerPageState();
}

class _ChatCustomerPageState extends State<ChatCustomerPage> {
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  var _id;
  var _message;
  var _image;
  var _pickuporderid;
  var _status;
  var _senduserid;
  var _touserid;
  var _ispush;
  var _isread;
  var _created_date;
  var mentokAtas;
  var detectMentok;

  late String _messagePesan;

  late bool _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _defaultPerPageCount = 40;
  late List<Datum> _pickuporderno;
  final int _nextPageThreshold = 0;

  var _token;

  final _key = new GlobalKey<FormState>();

  checkAndSave() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      saveText();
    }
  }

  saveText() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    Map bodi = {
      "token": _token,
      "message": _messagePesan,
    };
    var body = jsonEncode(bodi);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/contributor/chats/admin/post/"),
        body: body);
    final data = jsonDecode(response.body);

    String token = data['token'];
    String status = data['status'];
    String pesan = data['message'];

    print(status + pesan);

    if (status == "success") {
      print(status);
    } else {
      print(pesan);
    }
  }

  Future<void> fetchDataChatCustomer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    //try {
    Map bodi = {"token": _token};
    var body = jsonEncode(bodi);

    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/driver/chats/get?page=$_pageNumber"),
        body: body);
    ResponseChatCustomer _data = responseChatCustomerFromJson(response.body);
    //developer.log(response.body);
    String statusrespon = _data.status;
    print("statusnnyaa: " + statusrespon);
    // int current_page = _data.pickupOrders.currentPage;
    // print("current_page: " + current_page.toString());
    // String pno = _data.pickupOrders.data[0].pickupOrderNo;
    // print("data: " + pno);
    // print("length " + _data.pickupOrders.data.length.toString());

    setState(() {
      _hasMore = _data.chats.data.length == _defaultPerPageCount;
      //print("hasmoreChat" + _hasMore.toString());
      _loading = false;
      _pageNumber = _pageNumber + 1;
      //print("pagenumberChat:" + _pageNumber.toString());

      for (int i = 0; i < _data.chats.data.length; i++) {
        _id.add(_data.chats.data[i].id.toString());
        _message.add(_data.chats.data[i].message.toString());
        _image.add(_data.chats.data[i].image.toString());
        _pickuporderid.add(_data.chats.data[i].pickupOrderId.toString());
        _senduserid.add(_data.chats.data[i].sendUserId.toString());
        _touserid.add(_data.chats.data[i].id.toString());
        _ispush.add(_data.chats.data[i].id.toString());
        _isread.add(_data.chats.data[i].id.toString());
        _status.add(_data.status.toString());
        // var _GETestimasi = _data.pickupOrders.data[i].pickupDate;
        // if (_GETestimasi == null) {
        //   _estimasi.add("-");
        // } else {
        //   _estimasi.add(_GETestimasi);
        // }
        // _volume.add(_data.pickupOrders.data[i].estimateVolume.toString());
        // _status.add(_data.pickupOrders.data[i].status.toString());

        String date = _data.chats.data[i].createdAt.toString();
        var dateTime = DateTime.parse(date);
        _created_date.add(DateFormat('yyyy-MM-dd').format(dateTime).toString());
      }
      //print("tanggalan: " + _created_date.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPref();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _id = [];
    _message = [];
    _image = [];
    _pickuporderid = [];
    _status = [];
    _senduserid = [];
    _touserid = [];
    _ispush = [];
    _isread = [];
    _created_date = [];

    mentokAtas = 1;

    fetchDataChatCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: getBody(),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Form(
                    key: _key,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // First child is enter comment text input
                          Expanded(
                            child: TextFormField(
                              autocorrect: false,
                              decoration: new InputDecoration(
                                labelText: "Pesan...",
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                fillColor: Colors.blue,
                                border: OutlineInputBorder(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.zero(5.0)),
                                    borderSide:
                                        BorderSide(color: Colors.purpleAccent)),
                              ),
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "";
                                }
                              },
                              onSaved: (e) => _messagePesan = e!,
                            ),
                          ),
                          // Second child is button
                          IconButton(
                            icon: Icon(Icons.send),
                            iconSize: 20.0,
                            onPressed: () {
                              checkAndSave();
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => ChatCustomer(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 100),
                                ),
                              );
                            },
                          )
                        ]),
                  )),
            ],
          ),
        ),

        // SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       BubbleNormalAudio(
        //         color: Color(0xFFE8E8EE),
        //         duration: duration.inSeconds.toDouble(),
        //         position: position.inSeconds.toDouble(),
        //         isPlaying: isPlaying,
        //         isLoading: isLoading,
        //         isPause: isPause,
        //         onSeekChanged: _changeSeek,
        //         onPlayPauseButtonClick: _playAudio,
        //         sent: true,
        //       ),
        //       BubbleNormal(
        //         text: 'bubble normal with tail',
        //         isSender: false,
        //         color: Color(0xFF1B97F3),
        //         tail: true,
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.white,
        //         ),
        //       ),
        //       BubbleNormal(
        //         text: 'bubble normal with tail',
        //         isSender: true,
        //         color: Color(0xFFE8E8EE),
        //         tail: true,
        //         sent: true,
        //       ),
        //       DateChip(
        //         date: new DateTime(now.year, now.month, now.day - 2),
        //       ),
        //       BubbleNormal(
        //         text: 'bubble normal without tail',
        //         isSender: false,
        //         color: Color(0xFF1B97F3),
        //         tail: false,
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.white,
        //         ),
        //       ),
        //       Container(
        //         width: 100,
        //         height: 100,
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             image: NetworkImage(
        //                 "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
        //             //fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //       BubbleNormal(
        //         text: 'bubble normal without tail',
        //         color: Color(0xFFE8E8EE),
        //         tail: false,
        //         sent: true,
        //         seen: true,
        //         delivered: true,
        //       ),
        //       BubbleSpecialOne(
        //         text: 'bubble special one with tail',
        //         isSender: false,
        //         color: Color(0xFF1B97F3),
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.white,
        //         ),
        //       ),
        //       DateChip(
        //         date: new DateTime(now.year, now.month, now.day - 1),
        //       ),
        //       BubbleSpecialOne(
        //         text: 'bubble special one with tail',
        //         color: Color(0xFFE8E8EE),
        //         seen: true,
        //       ),
        //       BubbleSpecialOne(
        //         text: 'bubble special one without tail',
        //         isSender: false,
        //         tail: false,
        //         color: Color(0xFF1B97F3),
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.black,
        //         ),
        //       ),
        //       BubbleSpecialOne(
        //         text: 'bubble special one without tail',
        //         tail: false,
        //         color: Color(0xFFE8E8EE),
        //         sent: true,
        //       ),
        //       BubbleSpecialTwo(
        //         text: 'bubble special tow with tail',
        //         isSender: false,
        //         color: Color(0xFF1B97F3),
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.black,
        //         ),
        //       ),
        //       DateChip(
        //         date: now,
        //       ),
        //       BubbleSpecialTwo(
        //         text: 'bubble special tow with tail',
        //         isSender: true,
        //         color: Color(0xFFE8E8EE),
        //         sent: true,
        //       ),
        //       BubbleSpecialTwo(
        //         text: 'bubble special tow without tail',
        //         isSender: false,
        //         tail: false,
        //         color: Color(0xFF1B97F3),
        //         textStyle: TextStyle(
        //           fontSize: 20,
        //           color: Colors.black,
        //         ),
        //       ),
        //       BubbleSpecialTwo(
        //         text: 'bubble special tow without tail',
        //         tail: false,
        //         color: Color(0xFFE8E8EE),
        //         delivered: true,
        //       ),
        //       Container(
        //           padding: EdgeInsets.symmetric(vertical: 2.0),
        //           child:
        //               Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        //             // First child is enter comment text input
        //             Expanded(
        //               child: TextFormField(
        //                 autocorrect: false,
        //                 decoration: new InputDecoration(
        //                   labelText: "Some Text",
        //                   labelStyle:
        //                       TextStyle(fontSize: 20.0, color: Colors.white),
        //                   fillColor: Colors.blue,
        //                   border: OutlineInputBorder(
        //                       // borderRadius:
        //                       //     BorderRadius.all(Radius.zero(5.0)),
        //                       borderSide:
        //                           BorderSide(color: Colors.purpleAccent)),
        //                 ),
        //               ),
        //             ),
        //             // Second child is button
        //             IconButton(
        //               icon: Icon(Icons.send),
        //               iconSize: 20.0,
        //               onPressed: () {},
        //             )
        //           ])),
        //     ],
        //   ),
        // ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    final url =
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await audioPlayer.play(url);
      setState(() {
        isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
        duration = new Duration();
        position = new Duration();
      });
    });
  }

  Widget getBody() {
    final now = new DateTime.now();
    if (_id.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchDataChatCustomer();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error ketika loading, coba kembali..."),
          ),
        ));
      }
    } else {
      return ListView.builder(
          reverse: true,
          itemCount: _id.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _id.length - _nextPageThreshold) {
              fetchDataChatCustomer();
            }
            if (index == _id.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _error = false;
                      fetchDataChatCustomer();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error ketika loading, coba kembali..."),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            //final Photo photo = _photos[index];
            final id = _id[index];
            final image = _image[index];
            final message = _message[index];
            final pickuporder = _pickuporderid[index];
            final senduserid = _senduserid[index];
            final touserid = _touserid[index];
            final isread = _isread[index];
            final ispush = _ispush[index];
            final status = _status[index];
            if (index == _id.length - 1) {
              mentokAtas = 0;
              detectMentok = true;
            } else {
              mentokAtas = 1;
              detectMentok = false;
            }
            final created_dateNewer = _created_date[index];
            final created_dateOlder = _created_date[index + mentokAtas];
            DateTime dtNewer = DateTime.parse(created_dateNewer);
            DateTime dtOlder = DateTime.parse(created_dateOlder);
            bool bandingTanggal = dtNewer.isAfter(dtOlder);
            final date = DateFormat('dd MMMM yyyy', "id_ID").format(dtNewer);
            //print("idlength" + _id.length.toString());
            //print("banding: " + index.toString() + bandingTanggal.toString());
            //print("pesan: " + message);

            // return Card(
            //   child: Column(
            //     children: <Widget>[
            //       Image.network(
            //         photo.thumbnailUrl,
            //         fit: BoxFit.fitWidth,
            //         width: double.infinity,
            //         height: 160,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(16),
            //         child: Text(photo.title,
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 16)),
            //       ),
            //     ],
            //   ),
            // );

            return GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => Historis_Item_Selesai()));
              },
              child: Column(
                children: [
                  if (detectMentok == true) ...[
                    DateChip(
                      date: dtNewer,
                    ),
                  ],
                  if (bandingTanggal == true) ...[
                    DateChip(
                      date: dtNewer,
                    ),
                  ],
                  if (senduserid == "1") ...[
                    BubbleSpecialOne(
                      text: message,
                      isSender: false,
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ] else if (senduserid != "1") ...[
                    BubbleSpecialOne(
                      text: message,
                      color: Color(0xFFE8E8EE),
                      //seen: true,
                    ),
                  ],
                ],
              ),
            );
          });
    }
    return Container();
  }
}
