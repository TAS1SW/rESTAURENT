import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:menu/secondscreen.dart';

void main() {
  runApp(MaterialApp(
    home: App(),
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? selectedClientId;
  String? selectedTerminalId;

  List<String> clientIds = [
    'Client1',
    'Client2',
    'Client3',
  ];

  List<String> terminalIds = [
    'Terminal1',
    'Terminal2',
    'Terminal3',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 53.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.2,
              ),
              Text("Welcome"),
              SizedBox(
                height: height * 0.03,
              ),
              Text("Please set the client id and terminal id"),
              SizedBox(
                height: height * 0.03,
              ),
              Text("Client id"),
              DropdownButton2<String>(
                items: clientIds.map((clientId) {
                  return DropdownMenuItem<String>(
                    value: clientId,
                    child: Text(
                      clientId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: selectedClientId,
                onChanged: (value) {
                  setState(() {
                    selectedClientId = value;
                  });
                },
                hint: Text('Select a client id'),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Text("Terminal id"),
              DropdownButton2<String>(
                items: terminalIds.map((terminalId) {
                  return DropdownMenuItem<String>(
                    value: terminalId,
                    child: Text(
                      terminalId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: selectedTerminalId,
                onChanged: (value) {
                  setState(() {
                    selectedTerminalId = value;
                  });
                },
                hint: Text('Select a terminal id'),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: InkWell(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyApp())),
                  child: Container(
                    height: height * 0.04,
                    width: width * 0.6,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
