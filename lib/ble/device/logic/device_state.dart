import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_state.freezed.dart';

class Instant {
  final int reading;
  final DateTime when;
  const Instant({required this.reading, required this.when});
}

@freezed
class DeviceState with _$DeviceState {
  /// Data is present state
  const factory DeviceState({required Instant instant}) = Data;

  /// Button1 has been clicked
  const factory DeviceState.button1Clicked() = Button1Clicked;

  /// Initial/default state
  const factory DeviceState.initial() = Initial;

  /// Device is trying to connect
  const factory DeviceState.connecting() = Connecting;

  /// Device is connected
  const factory DeviceState.connected() = Connected;

  /// Device is disconnect
  const factory DeviceState.disconnected() = Disconnected;

  /// Error when loading data state
  const factory DeviceState.error([@Default('') String message]) = Error;
}
