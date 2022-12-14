part of 'scanner_provider.dart';

/// Defines all the Scanner logic the app will use
class ScannerStateNotifier extends StateNotifier<ScannerState> with UiLoggy {
  Map<String, ScannedDevice> _devices = {};
  bool scanning = false;
  StreamSubscription? scanSubscription;

  /// Base constructor expects StateNotifier use_cases to
  /// read its usecases and also defines inital state
  ScannerStateNotifier() : super(const ScannerState.initial()) {
    loggy.info("CTOR");
  }

  @override
  void dispose() {
    loggy.info("Dispose");
    stopScanning();
    super.dispose();
  }

  startScanning() async {
    // TODO Add bluetooth status handling elsewhere
    // if (!await flutterReactiveBle.) {
    //   state = ScannerState.error(
    //       scanning: scanning, message: "Bluetooth is not available");
    //   return;
    // }

    loggy.info("Start scanning");

    scanning = true;
    _devices = {};
    _updateState();

    scanSubscription = flutterReactiveBle
        .scanForDevices(withServices: [fitnessServiceUUID]).listen(
      (event) => addOrUpdateDevice(event),
      onError: (error) {
        final message = "Error from scanner=$error";
        loggy.error(message);
        state = ScannerState.error(scanning: scanning, message: message);
      },
    );

    loggy.info("Start scanning ended");
  }

  void stopScanning() {
    if (scanning) {
      scanSubscription?.cancel();
      scanSubscription = null;
      scanning = false;
      _updateState();
      loggy.info("Scanning stopped");
    }
  }

  void addOrUpdateDevice(DiscoveredDevice scanResult) {
    final device = ScannedDevice(
        deviceId: scanResult.id, name: scanResult.name, rssi: scanResult.rssi);

    _devices[device.deviceId] = device;
    _updateState();
  }

  void _updateState() {
    state = ScannerState(
        scanning: scanning,
        devices: _devices.values.where(_deviceFilter).toList());
  }

  bool _deviceFilter(ScannedDevice item) {
    return item.name.toLowerCase().contains('bandy');
  }
}
