import 'dart:io';

import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/views/device_display.dart';
import 'package:bandy_client/views/scanner_page.dart';
import 'package:bandy_client/views/workout_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'ble/scanner/logic/scanned_device.dart';

late final SharedPreferences sharedPreferences;

const prefDefaultDeviceName = 'defaultDeviceName';
const prefDefaultDeviceId = 'defaultDeviceId';

// BLE stuff
final fitnessServiceUUID = Uuid.parse("1826");
final resistanceCharacteristicUUID =
    Uuid.parse("a6351a0c-f7e0-11ec-b939-0242ac120002");

final flutterReactiveBle = FlutterReactiveBle();

late final Talker talker;
late final Directory? storageDirectory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());
  talker = Talker(
    loggerOutput: debugPrint,
  );
  talker.info('Talker initialized!!!!!!!!!');
  sharedPreferences = await SharedPreferences.getInstance();

  // Choose appropriate place to write a file so it's publicly available

  storageDirectory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  // TODO Handle unhandled error like this using talker?
  // runZonedGuarded(
  // () => runApp(const ProviderScope(child: MyApp())),
  // (error, stack) {
  // talker.handle(error, stack, 'Uncaught app exception');
  // },
  // );

  // Setup the database here
  final db = InitBandyDatabase();
  await db.open();

  runApp(ProviderScope(overrides: [
    kaleidaLogDbProvider.overrideWithValue(db),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bandy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bandy Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices),
            tooltip: 'Scan',
            onPressed: () => _gotoScanner(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const WorkoutWidget(),
          Expanded(
            child: device == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('No Bandy device selected. Tap scan to find one'),
                      ],
                    ),
                  )
                : DeviceDisplayWidget(defaultDevice!),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Workout history',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
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
