import 'dart:io';

import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/views/device_display.dart';
import 'package:bandy_client/views/scanner_page.dart';
import 'package:bandy_client/views/session_details_page.dart';
import 'package:bandy_client/views/sessions_page.dart';
import 'package:bandy_client/views/workout_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

// Go router setups
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

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
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/exercise',
    routes: <RouteBase>[
      /// Application shell
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              redirect: (context, state) => '/exercise',
            ),
            GoRoute(
                path: '/exercise',
                builder: (BuildContext context, GoRouterState state) {
                  return const ExercisePage(title: 'Exercise');
                }),
            GoRoute(
                path: '/sessions',
                builder: (BuildContext context, GoRouterState state) {
                  return const SessionsPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                      path: 'details/:sessionId',
                      builder: (BuildContext context, GoRouterState state) {
                        return const SessionDetailsPage();
                      }),
                ]),
          ]),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bandy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  ScannedDevice? defaultDevice;

  _ExercisePageState() {
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

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) => _onItemTapped(index, context),
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

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/exercise')) {
      return 0;
    }
    if (location.startsWith('/sessions')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    final paths = ['/exercise', '/sessions', '/settings'];

    if (index < paths.length) {
      GoRouter.of(context).go(paths[index]);
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
