import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_state.dart';
part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  FutureOr<SettingsState> build() {
    return const SettingsState();
  }
}
