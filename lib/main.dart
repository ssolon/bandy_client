import 'dart:async';
import 'dart:io';

import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/views/device_display.dart';
import 'package:bandy_client/views/scanner_page.dart';
import 'package:bandy_client/views/session_page.dart';
import 'package:bandy_client/views/sessions_page.dart';
import 'package:bandy_client/views/workout_display.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe/swipe.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
      // : await getApplicationSupportDirectory();
      : await getApplicationDocumentsDirectory(); // so we can access via app

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

  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    talker.error("Error PlatformDispatcher.onError", exception, stackTrace);
    return true;
  };

  FlutterError.onError =
      (details) => talker.error("Caught by FlutterError=$details");

  runZonedGuarded(
    () => runApp(
      ProviderScope(overrides: [
        kaleidaLogDbProvider.overrideWithValue(db),
      ], child: MyApp()),
    ),
    (error, stack) => talker.handle(error, stack, "From runZoneGuarded"),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = BeamerDelegate(
    initialPath: '/exercise',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const ScaffoldWithBottomNavBar(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bandy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: routerDelegate),
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

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key}) : super(key: key);

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  late int _currentIndex;
  int baseIndex = 0;

  final _routerDelegates = [
    BeamerDelegate(
      initialPath: '/exercise',
      locationBuilder: (RouteInformation routeInformation, _) {
        if (routeInformation.location!.contains('/exercise')) {
          return ExerciseLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/sessions',
      locationBuilder: (RouteInformation routeInformation, _) {
        if (routeInformation.location!.contains('/sessions')) {
          return SessionsLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/settings',
      locationBuilder: (RouteInformation routeInformation, _) {
        if (routeInformation.location!.contains('/settings')) {
          return SettingsLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
        initialPath: '/log',
        locationBuilder: (RouteInformation routeInformation, _) {
          if (routeInformation.location!.contains('/log')) {
            return LogLocation(routeInformation);
          }
          return NotFound(path: routeInformation.location!);
        }),
  ];

  // update the _currentIndex if necessary
  // TODO Does this work for three?
  // TODO Needs more investigation
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    _currentIndex = uriString.contains('/exercise') ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Swipe(
      onSwipeLeft: () {
        if (baseIndex == 0) {
          setState(() {
            baseIndex = 1;
          });
        }
      },
      onSwipeRight: () {
        if (baseIndex == 1) {
          setState(() {
            baseIndex = 0;
          });
        }
      },
      child: IndexedStack(index: baseIndex, children: [
        TalkerWrapper(
          talker: talker,
          options: const TalkerWrapperOptions(enableErrorAlerts: true),
          child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: [
              Beamer(
                routerDelegate: _routerDelegates[0],
              ),
              Beamer(
                routerDelegate: _routerDelegates[1],
              ),
              Beamer(
                routerDelegate: _routerDelegates[2],
              ),
            ]),

            // use an IndexedStack to choose which child to show
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
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
              onTap: (index) {
                if (index != _currentIndex) {
                  setState(() => _currentIndex = index);
                  _routerDelegates[_currentIndex].update(rebuild: false);
                }
              },
            ),
          ),
        ),
        Beamer(
          routerDelegate: _routerDelegates[3],
        ),
      ]),
    );
  }
}

class LogLocation extends BeamLocation<BeamState> {
  LogLocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('log'),
          title: 'Log',
          type: BeamPageType.slideRightTransition,
          child: TalkerScreen(talker: talker),
        ),
      ];

  @override
  List<Pattern> get pathPatterns => ['/log'];
}

class ExerciseLocation extends BeamLocation<BeamState> {
  ExerciseLocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('exercise'),
          title: 'Exercise',
          type: BeamPageType.noTransition,
          child: ExercisePage(title: 'Exercise'),
        ),
      ];

  @override
  List<Pattern> get pathPatterns => ['/exercise'];
}

class SessionsLocation extends BeamLocation<BeamState> {
  SessionsLocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      const BeamPage(
        key: ValueKey('sessions'),
        title: 'Sessions',
        type: BeamPageType.noTransition,
        child: SessionsPage(),
      ),
    ];

    if (state.uri.pathSegments.length == 2) {
      final id = state.uri.pathSegments[1];
      pages.add(BeamPage(
        key: ValueKey("sessions/$id"),
        title: 'Session',
        type: BeamPageType.slideRightTransition,
        child: const SessionPage(),
      ));
    }
    return pages;
  }

  @override
  List<Pattern> get pathPatterns => ['/sessions/:sessionId'];
}

class SettingsLocation extends BeamLocation<BeamState> {
  SettingsLocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('settings'),
          title: 'Sessions',
          type: BeamPageType.noTransition,
          child: SettingsPage(),
        ),
      ];

  @override
  List<Pattern> get pathPatterns => ['/settings'];
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Throw exception!'),
          onPressed: () async {
            return Future.delayed(const Duration(),
                () => throw (Exception("Dummy exception for testing")));
          },
        ),
      ),
    );
  }
}
