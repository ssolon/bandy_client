import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_state.freezed.dart';

@freezed
class DeviceState with _$DeviceState {
  /// Data is present state
  const factory DeviceState({required double reading}) = Data;

  /// Initial/default state
  const factory DeviceState.initial() = Initial;

  /// Device is connected
  const factory DeviceState.connected() = Connected;

  /// Device is disconnect
  const factory DeviceState.disconnected() = Disconnected;

  /// Error when loading data state
  const factory DeviceState.error([@Default('') String message]) = Error;
}
