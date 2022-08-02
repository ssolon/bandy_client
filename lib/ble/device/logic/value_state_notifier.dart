part of 'device_provider.dart';

/// Notifier to only provide value updates for a device

class ValueNotifier extends StateNotifier<int> with UiLoggy {
  final Ref ref;
  final ScannedDevice device;

  ValueNotifier(this.ref, this.device) : super(0) {
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
