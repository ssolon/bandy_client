import 'package:freezed_annotation/freezed_annotation.dart';
import 'scanned_device.dart';

part 'scanner_state.freezed.dart';

@freezed
class ScannerState with _$ScannerState {
  /// Data is present state
  const factory ScannerState({
    @Default(false) bool scanning,
    required List<ScannedDevice> devices,
  }) = Data;

  /// Initial/default state
  const factory ScannerState.initial({
    @Default(false) bool scanning,
  }) = Initial;

  /// Data is loading state
  const factory ScannerState.loading({@Default(false) bool scanning}) = Loading;

  /// Error when loading data state
  const factory ScannerState.error(
      {@Default(false) bool scanning, @Default('') String message}) = Error;
}
