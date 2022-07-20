class ScannedDevice {
  String deviceId;
  String name;
  int? rssi;

  ScannedDevice({
    required this.deviceId,
    required this.name,
    this.rssi,
  });
}
