import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin _notifications;

  var _dataMap = <String, String>{};
  var _datas = <String>[];
  List<dynamic> _data = [];
  List<dynamic> menuItems = [];

  bool isloading = true;

  @override
  void initState() {
    super.initState();

    // Initialize the notification plugin
    _notifications = FlutterLocalNotificationsPlugin();
    var initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    _notifications.initialize(initializationSettings);

    _connectToSSE();
    final source = EventSource('/sse/coolinart-12345/2');

    source.addEventListener('message', (event) {
      final data = jsonDecode(event.type);
      setState(() {
        menuItems = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body:
          // ListView.builder(
          //     itemCount: menuItems.length,
          //     itemBuilder: (context, index) {
          //       final item = menuItems[index];
          //       return ListTile(
          //         title: Text(item['name']),
          //         subtitle: Text(item['description']),
          //         trailing: Text('\$${item['price']}'),
          //       );
          //     },
          //   ),
          //
          _data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _data[index];
                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['description']),
                      trailing: Text('\$${item['price']}'),
                    );
                  },
                ),
    ));
  }

  void _connectToSSE() async {
    var client = http.Client();
    var request =
        http.Request('GET', Uri.parse('https://qrmenu.testenv.ro/sse/'));
    request.headers.addAll({'Accept': 'text/event-stream'});
    var response = await client.send(request);
    var stream = response.stream;

    stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((event) {
      if (event.isNotEmpty) {
        if (event.startsWith(':')) {
          // This is a comment line, ignore it.
        } else if (event.startsWith('id:')) {
          var parts = event.split(':');
          var key = parts[0];
          var value = parts[1].trim();
          var currentTime =
              DateTime.now(); // Add the current timestamp to the message
          setState(() {
            _dataMap[key] = value;
            _datas.add(
                ' $key: $value \n $currentTime'); // Add the timestamp to the message
          });
          _showNotification(value);
        }
      }
    });
  }

  void _showNotification(String message) async {
    var androidDetails = AndroidNotificationDetails(
        'channel_id', 'Channel Name',
        priority: Priority.high, importance: Importance.max);
    var notificationDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(0, 'New Message', message, notificationDetails);
    setState(() {
      isloading = false;
    });
  }

  // Future<void> _fetchData() async {
  //   final response = await http
  //       .get(Uri.parse('https://qrmenu.testenv.ro/sse/coolinart-12345/2'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _data = jsonDecode(response.body);
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
}
