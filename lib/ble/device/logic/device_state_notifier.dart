part of 'device_provider.dart';

final fitnessServiceUUID = Uuid.parse('1826');
final resistanceCharacteristicUUID =
    Uuid.parse("a6351a0c-f7e0-11ec-b939-0242ac120002");
final button1CharacteristicUUID =
    Uuid.parse("5b0d3458-d6f5-4ac4-936b-18654e9db83b");

/// Defines all the Device logic the app will use
class DeviceNotifier extends StateNotifier<DeviceState> with UiLoggy {
  final ScannedDevice device;
  DeviceState deviceState = const DeviceState.disconnected();

  ConnectionStateUpdate? connectionStateUpdate;
  StreamSubscription? connectionSubscription;
  StreamSubscription? resistanceSubscription;
  StreamSubscription? button1Subscription;

  /// Base constructor expects StateNotifier use_cases to
  /// read its usecases and also defines inital state
  DeviceNotifier(this.device) : super(const DeviceState.initial());

  bool get isConnected => deviceState == const DeviceState.connected();

  void connect() {
    // Get rid of any previous connection?
    connectionSubscription?.cancel();

    final connectStream = flutterReactiveBle.connectToDevice(
      id: device.deviceId,
      // connectionTimeout: const Duration(minutes: 5),
    );

    connectionSubscription = connectStream.listen((event) {
      loggy.debug("connectionStream=$event");
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          state = const DeviceState.connecting();
          break;

        case DeviceConnectionState.connected:
          deviceState = const DeviceState.connected();
          state = deviceState;
          _discoverServices();
          break;

        case DeviceConnectionState.disconnected:
          deviceState = const DeviceState.disconnected();
          state = deviceState;
          break;

        case DeviceConnectionState.disconnecting:
          // Ignore and wait until something actionable happens
          break;
      }
    }, onDone: () {
      deviceState = const DeviceState.disconnected();
      connectionSubscription = null;
    }, onError: (error) {
      //TODO Better error handling
      loggy.error("Error on connectStream=$error");
      return null;
    });
  }

  void disconnect() {
    // Avoid error on notification stream by cancelling it first
    resistanceSubscription?.cancel();
    resistanceSubscription = null;

    button1Subscription?.cancel();
    button1Subscription = null;

    // Will shutdown the connection (not sure if there's another way)
    connectionSubscription?.cancel();
    connectionSubscription = null;

    // Notify that we've disconnected since we've cancelled the connectionStream
    state = const DeviceState.disconnected();
  }

  // void _connectionHandler(String deviceId, BlueConnectionState newState) {
  //   loggy.debug("Connection deviceId=$deviceId state=${newState.value}");
  //   connectionState = newState;
  //   if (isConnected) {
  //     state = const DeviceState.connected();
  //     QuickBlue.discoverServices(device.deviceId);
  //   } else {
  //     state = const DeviceState.disconnected();
  //   }
  // }

  /// Apparently it's necessary to retrieve the services before we can do
  /// with them.
  _discoverServices() async {
    final services = await flutterReactiveBle.discoverServices(device.deviceId);
    for (final service in services) {
      loggy.debug(serviceToString(service));
    }

    // Subscribe to get the resistance values
    final characteristic = QualifiedCharacteristic(
        characteristicId: resistanceCharacteristicUUID,
        serviceId: fitnessServiceUUID,
        deviceId: device.deviceId);
    final resistanceStream =
        flutterReactiveBle.subscribeToCharacteristic(characteristic);
    resistanceSubscription = resistanceStream.listen(_valueHandler);

    // Subscribe to get button1 notifications
    final button1Characteristic = QualifiedCharacteristic(
        characteristicId: button1CharacteristicUUID,
        serviceId: fitnessServiceUUID,
        deviceId: device.deviceId);
    final button1Stream =
        flutterReactiveBle.subscribeToCharacteristic(button1Characteristic);
    button1Subscription = button1Stream.listen(_button1Handler);
  }
  // void _serviceHandler(String deviceId, String serviceId) {
  //   loggy.debug("Service discovered deviceId=$deviceId serviceId=$serviceId");
  //   if (deviceId == device.deviceId && serviceId == fitnessServiceUUID) {
  //     loggy.debug("Setup notify");
  //     QuickBlue.setNotifiable(device.deviceId, fitnessServiceUUID,
  //         resistanceCharacteristicUUID, BleInputProperty.notification);
  //     // TODO This blows up (sometimes?) with an unknown characteristic.
  //     //      It appears that the characteristic hasn't been processed yet?
  //     //      Some better way or just give up since in real use a value will
  //     //      come soon enough.
  //     // Prime the pump by getting the current value
  //     // QuickBlue.readValue(
  //     // device.deviceId, fitnessServiceUUID, resistanceCharacteristicUUID);
  //   }
  // }

  void _valueHandler(List<int> newValue) {
    final bytes = Uint8List.fromList(newValue);
    final ints = bytes.buffer.asInt16List();
    final resistance = (ints[0] / 10).round();
    loggy.debug("Value=$resistance");
    state = DeviceState(
        instant: Instant(reading: resistance, when: DateTime.now()));
  }

  void _button1Handler(_) {
    loggy.debug("Button1 notification");
    state = const DeviceState.button1Clicked();
  }

  @override
  void dispose() {
    super.dispose();
    disconnect();
  }

  String serviceToString(DiscoveredService service) {
    String res = "serviceId=${service.serviceId}"
        "${service.characteristics.map((e) => "\n    characteristicId=${e.characteristicId}"
            "${e.isIndicatable ? ' indicatable' : ''}"
            "${e.isNotifiable ? ' notifiable' : ''}"
            "${e.isReadable ? ' readable' : ''}"
            "${e.isWritableWithResponse ? ' writableWithResponse' : ''}"
            "${e.isWritableWithoutResponse ? ' writable' : ''}").toList(growable: false).join()}";

    return res;
  }
}
