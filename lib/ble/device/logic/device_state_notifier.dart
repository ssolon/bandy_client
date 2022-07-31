part of 'device_provider.dart';

final fitnessServiceUUID = Uuid([0x1826]);
final resistanceCharacteristicUUID =
    Uuid.parse("a6351a0c-f7e0-11ec-b939-0242ac120002");

/// Defines all the Device logic the app will use
class DeviceNotifier extends StateNotifier<DeviceState> with UiLoggy {
  final ScannedDevice device;
  DeviceState deviceState = const DeviceState.disconnected();

  ConnectionStateUpdate? connectionStateUpdate;
  StreamSubscription? connectionSubscription;
  StreamSubscription? resistanceSubscription;

  /// Base constructor expects StateNotifier use_cases to
  /// read its usecases and also defines inital state
  DeviceNotifier(this.device) : super(const DeviceState.initial()) {
    connect();
  }

  bool get isConnected => deviceState == const DeviceState.connected();

  void connect() {
    // Get rid of any previous connection?
    connectionSubscription?.cancel();

    final connectStream = flutterReactiveBle.connectToDevice(
      id: device.deviceId,
      connectionTimeout: const Duration(minutes: 5),
    );

    connectionSubscription = connectStream.listen((event) {
      loggy.debug("connectionStream=$event");
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          state = DeviceState.connecting();
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
    // TODO Will we get a "disconnected" event in stream? Probably not!
    connectionSubscription?.cancel();
    connectionSubscription = null;
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
    for (final element in services) {
      loggy.debug(element.toString());
    }

    // Subscribe to get the values
    final characteristic = QualifiedCharacteristic(
        characteristicId: resistanceCharacteristicUUID,
        serviceId: fitnessServiceUUID,
        deviceId: device.deviceId);
    final resistanceStream =
        flutterReactiveBle.subscribeToCharacteristic(characteristic);
    resistanceSubscription = resistanceStream.listen(_valueHandler);
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
    state = DeviceState(reading: resistance);
  }

  @override
  void dispose() {
    super.dispose();
    disconnect();
  }
}
