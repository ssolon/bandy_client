part of 'device_provider.dart';

/// Notifier to only provide button1 clicks for a device. We keep a count so
/// that we can generate a changed value.

class Button1Notifier extends StateNotifier<int> with UiLoggy {
  final Ref ref;
  final ScannedDevice device;
  int count = 0;

  Button1Notifier(this.ref, this.device) : super(0) {
    ref.listen(deviceNotifierProvider(device),
        (DeviceState? oldState, DeviceState newState) {
      loggy.debug("newState=$newState");
      final newValue = newState.whenOrNull(null, button1Clicked: () => ++count);
      if (newValue != null) {
        state = newValue;
      }
    });
  }
}
