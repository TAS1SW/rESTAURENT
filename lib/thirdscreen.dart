import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(thirdscreen());

class thirdscreen extends StatefulWidget {
  @override
  _thirdscreenState createState() => _thirdscreenState();
}

class _thirdscreenState extends State<thirdscreen> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://qrmenu.testenv.ro/sse/coolinart-12345/2'));
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coolinart Menu',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Coolinart Menu'),
        ),
        body: _data.isEmpty
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
      ),
    );
  }
}
