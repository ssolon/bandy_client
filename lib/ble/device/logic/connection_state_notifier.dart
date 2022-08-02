part of 'device_provider.dart';

/// Notifier to provide connection state updates.
///
/// This avoids watchers getting notified for values, whey they don't care about.
class ConnectionNotifier extends StateNotifier<DeviceState> {
  final Ref ref;
  final ScannedDevice device;

  ConnectionNotifier(this.ref, this.device)
      : super(const DeviceState.disconnected()) {
    ref.listen(deviceNotifierProvider(device),
        (DeviceState? oldState, DeviceState newState) {
      final connectionState = newState.maybeMap(
          (value) => null, // ignore data states
          orElse: () => newState); // Anything else should be connection status
      if (connectionState != null) {
        state = newState;
      }
    });
  }
}
