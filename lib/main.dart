import 'package:bandy_client/views/device_display.dart';
import 'package:bandy_client/views/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ble/scanner/logic/scanned_device.dart';

late final SharedPreferences sharedPreferences;

const prefDefaultDeviceName = 'defaultDeviceName';
const prefDefaultDeviceId = 'defaultDeviceId';

// BLE stuff
final fitnessServiceUUID = Uuid.parse("1826");
final resistanceCharacteristicUUID =
    Uuid.parse("a6351a0c-f7e0-11ec-b939-0242ac120002");

final flutterReactiveBle = FlutterReactiveBle();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bandy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bandy Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScannedDevice? defaultDevice;

  _MyHomePageState() {
    defaultDevice = getDefaultDevice();
  }

  @override
  Widget build(BuildContext context) {
    final device = defaultDevice;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.devices),
              tooltip: 'Scan',
              onPressed: () => _gotoScanner(context),
            ),
          ],
        ),
        body: device == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('No Bandy device selected. Tap scan to find one'),
                  ],
                ),
              )
            : DeviceDisplayWidget(defaultDevice!));
  }

  _gotoScanner(BuildContext context) async {
    final selected = await Navigator.push<ScannedDevice?>(
        context,
        MaterialPageRoute(
          builder: (context) => const ScannerResultsRoute(),
        ));

    if (selected != null) {
      saveDefaultDevice(selected);
      setState(() {
        defaultDevice = selected;
      });
    }
  }
}

void saveDefaultDevice(ScannedDevice? device) {
  if (device != null) {
    sharedPreferences.setString(prefDefaultDeviceName, device.name);
    sharedPreferences.setString(prefDefaultDeviceId, device.deviceId);
  }
}

ScannedDevice? getDefaultDevice() {
  final name = sharedPreferences.getString(prefDefaultDeviceName);
  final id = sharedPreferences.getString(prefDefaultDeviceId);

  return (name != null && id != null)
      ? ScannedDevice(deviceId: id, name: name)
      : null;
}