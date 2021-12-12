import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/historis.dart';
import 'screens/chat_list.dart';
import 'screens/tutorial.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
/*
void main() {
  runApp(MaterialApp(
    locale: Locale('de'),
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => LoginPage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/historis': (context) =>  Historis(),
      '/chatlist': (context) => ChatList(),
      '/tutorial': (context) => Tutorial(),
    },
  ));
}
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null).then((_) =>
      runApp(MaterialApp(
        locale: Locale('de'),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => LoginPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/historis': (context) =>  Historis(),
          '/chatlist': (context) => ChatList(),
          '/tutorial': (context) => Tutorial(),
        },
      )));
}
