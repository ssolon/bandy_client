part of 'device_provider.dart';

/// Notifier to only provide value updates for a device

class ValueNotifier extends StateNotifier<Instant> with UiLoggy {
  final Ref ref;
  final ScannedDevice device;

  ValueNotifier(this.ref, this.device)
      : super(Instant(reading: 0, when: DateTime.now())) {
    ref.listen(deviceNotifierProvider(device),
        (DeviceState? oldState, DeviceState newState) {
      loggy.debug("newState=$newState");
      final newValue = newState.whenOrNull((value) => value);
      if (newValue != null) {
        state = newValue;
      }
    });
  }
}
