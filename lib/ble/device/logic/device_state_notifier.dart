part of 'device_provider.dart';

const fitnessServiceUUID = '00001826-0000-1000-8000-00805f9b34fb';
const resistanceCharacteristicUUID = "a6351a0c-f7e0-11ec-b939-0242ac120002";

/// Defines all the Device logic the app will use
class DeviceNotifier extends StateNotifier<DeviceState> with UiLoggy {
  final ScannedDevice device;
  BlueConnectionState connectionState = BlueConnectionState.disconnected;

  /// Base constructor expects StateNotifier use_cases to
  /// read its usecases and also defines inital state
  DeviceNotifier(this.device) : super(const DeviceState.initial()) {
    loggy.debug("CTOR for deviceId=${device.deviceId}");

    _setupHandlers(true);
    QuickBlue.connect(device.deviceId);
  }

  void _setupHandlers(bool setIt) {
    QuickBlue.setConnectionHandler(setIt ? _connectionHandler : null);
    QuickBlue.setServiceHandler(setIt ? _serviceHandler : null);
    QuickBlue.setValueHandler(setIt ? _valueHandler : null);
  }

  void _connectionHandler(String deviceId, BlueConnectionState newState) {
    loggy.debug("Connection deviceId=$deviceId state=${newState.value}");
    connectionState = newState;
    if (isConnected) {
      state = const DeviceState.connected();
      QuickBlue.discoverServices(device.deviceId);
    } else {
      state = const DeviceState.disconnected();
    }
  }

  void _serviceHandler(String deviceId, String serviceId) {
    loggy.debug("Service discovered deviceId=$deviceId serviceId=$serviceId");
    if (deviceId == device.deviceId && serviceId == fitnessServiceUUID) {
      // Prime the pump by getting the current value
      QuickBlue.readValue(
          device.deviceId, fitnessServiceUUID, resistanceCharacteristicUUID);
      loggy.debug("Setup notify");
      QuickBlue.setNotifiable(device.deviceId, fitnessServiceUUID,
          resistanceCharacteristicUUID, BleInputProperty.notification);
    }
  }

  void _valueHandler(
      String deviceId, String characteristicId, Uint8List value) {
    ByteData byteData = ByteData.sublistView(value);
    double resistance = byteData.getUint16(0, Endian.little) / 10;
    loggy.debug(
        "Value deviceId=$deviceId characteristicId=$characteristicId value=$resistance");
    state = DeviceState(reading: resistance);
  }

  @override
  void dispose() {
    super.dispose();
    disconnect();
    _setupHandlers(false);
  }

  bool get isConnected => connectionState == BlueConnectionState.connected;

  void disconnect() {
    if (isConnected) {
      QuickBlue.disconnect(device.deviceId);
    }
  }
}
