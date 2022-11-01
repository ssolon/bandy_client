// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'device_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DeviceState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceStateCopyWith<$Res> {
  factory $DeviceStateCopyWith(
          DeviceState value, $Res Function(DeviceState) then) =
      _$DeviceStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DeviceStateCopyWithImpl<$Res> implements $DeviceStateCopyWith<$Res> {
  _$DeviceStateCopyWithImpl(this._value, this._then);

  final DeviceState _value;
  // ignore: unused_field
  final $Res Function(DeviceState) _then;
}

/// @nodoc
abstract class _$$DataCopyWith<$Res> {
  factory _$$DataCopyWith(_$Data value, $Res Function(_$Data) then) =
      __$$DataCopyWithImpl<$Res>;
  $Res call({Instant instant});
}

/// @nodoc
class __$$DataCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$DataCopyWith<$Res> {
  __$$DataCopyWithImpl(_$Data _value, $Res Function(_$Data) _then)
      : super(_value, (v) => _then(v as _$Data));

  @override
  _$Data get _value => super._value as _$Data;

  @override
  $Res call({
    Object? instant = freezed,
  }) {
    return _then(_$Data(
      instant: instant == freezed
          ? _value.instant
          : instant // ignore: cast_nullable_to_non_nullable
              as Instant,
    ));
  }
}

/// @nodoc

class _$Data implements Data {
  const _$Data({required this.instant});

  @override
  final Instant instant;

  @override
  String toString() {
    return 'DeviceState(instant: $instant)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Data &&
            const DeepCollectionEquality().equals(other.instant, instant));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(instant));

  @JsonKey(ignore: true)
  @override
  _$$DataCopyWith<_$Data> get copyWith =>
      __$$DataCopyWithImpl<_$Data>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return $default(instant);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return $default?.call(instant);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(instant);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Data implements DeviceState {
  const factory Data({required final Instant instant}) = _$Data;

  Instant get instant;
  @JsonKey(ignore: true)
  _$$DataCopyWith<_$Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Button1ClickedCopyWith<$Res> {
  factory _$$Button1ClickedCopyWith(
          _$Button1Clicked value, $Res Function(_$Button1Clicked) then) =
      __$$Button1ClickedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$Button1ClickedCopyWithImpl<$Res>
    extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$Button1ClickedCopyWith<$Res> {
  __$$Button1ClickedCopyWithImpl(
      _$Button1Clicked _value, $Res Function(_$Button1Clicked) _then)
      : super(_value, (v) => _then(v as _$Button1Clicked));

  @override
  _$Button1Clicked get _value => super._value as _$Button1Clicked;
}

/// @nodoc

class _$Button1Clicked implements Button1Clicked {
  const _$Button1Clicked();

  @override
  String toString() {
    return 'DeviceState.button1Clicked()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Button1Clicked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return button1Clicked();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return button1Clicked?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (button1Clicked != null) {
      return button1Clicked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return button1Clicked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return button1Clicked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (button1Clicked != null) {
      return button1Clicked(this);
    }
    return orElse();
  }
}

abstract class Button1Clicked implements DeviceState {
  const factory Button1Clicked() = _$Button1Clicked;
}

/// @nodoc
abstract class _$$InitialCopyWith<$Res> {
  factory _$$InitialCopyWith(_$Initial value, $Res Function(_$Initial) then) =
      __$$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$InitialCopyWith<$Res> {
  __$$InitialCopyWithImpl(_$Initial _value, $Res Function(_$Initial) _then)
      : super(_value, (v) => _then(v as _$Initial));

  @override
  _$Initial get _value => super._value as _$Initial;
}

/// @nodoc

class _$Initial implements Initial {
  const _$Initial();

  @override
  String toString() {
    return 'DeviceState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements DeviceState {
  const factory Initial() = _$Initial;
}

/// @nodoc
abstract class _$$ConnectingCopyWith<$Res> {
  factory _$$ConnectingCopyWith(
          _$Connecting value, $Res Function(_$Connecting) then) =
      __$$ConnectingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectingCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$ConnectingCopyWith<$Res> {
  __$$ConnectingCopyWithImpl(
      _$Connecting _value, $Res Function(_$Connecting) _then)
      : super(_value, (v) => _then(v as _$Connecting));

  @override
  _$Connecting get _value => super._value as _$Connecting;
}

/// @nodoc

class _$Connecting implements Connecting {
  const _$Connecting();

  @override
  String toString() {
    return 'DeviceState.connecting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Connecting);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return connecting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return connecting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class Connecting implements DeviceState {
  const factory Connecting() = _$Connecting;
}

/// @nodoc
abstract class _$$ConnectedCopyWith<$Res> {
  factory _$$ConnectedCopyWith(
          _$Connected value, $Res Function(_$Connected) then) =
      __$$ConnectedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectedCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$ConnectedCopyWith<$Res> {
  __$$ConnectedCopyWithImpl(
      _$Connected _value, $Res Function(_$Connected) _then)
      : super(_value, (v) => _then(v as _$Connected));

  @override
  _$Connected get _value => super._value as _$Connected;
}

/// @nodoc

class _$Connected implements Connected {
  const _$Connected();

  @override
  String toString() {
    return 'DeviceState.connected()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Connected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return connected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return connected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class Connected implements DeviceState {
  const factory Connected() = _$Connected;
}

/// @nodoc
abstract class _$$DisconnectedCopyWith<$Res> {
  factory _$$DisconnectedCopyWith(
          _$Disconnected value, $Res Function(_$Disconnected) then) =
      __$$DisconnectedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectedCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$DisconnectedCopyWith<$Res> {
  __$$DisconnectedCopyWithImpl(
      _$Disconnected _value, $Res Function(_$Disconnected) _then)
      : super(_value, (v) => _then(v as _$Disconnected));

  @override
  _$Disconnected get _value => super._value as _$Disconnected;
}

/// @nodoc

class _$Disconnected implements Disconnected {
  const _$Disconnected();

  @override
  String toString() {
    return 'DeviceState.disconnected()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Disconnected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class Disconnected implements DeviceState {
  const factory Disconnected() = _$Disconnected;
}

/// @nodoc
abstract class _$$ErrorCopyWith<$Res> {
  factory _$$ErrorCopyWith(_$Error value, $Res Function(_$Error) then) =
      __$$ErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$ErrorCopyWithImpl<$Res> extends _$DeviceStateCopyWithImpl<$Res>
    implements _$$ErrorCopyWith<$Res> {
  __$$ErrorCopyWithImpl(_$Error _value, $Res Function(_$Error) _then)
      : super(_value, (v) => _then(v as _$Error));

  @override
  _$Error get _value => super._value as _$Error;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$Error(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error implements Error {
  const _$Error([this.message = '']);

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'DeviceState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$ErrorCopyWith<_$Error> get copyWith =>
      __$$ErrorCopyWithImpl<_$Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Instant instant) $default, {
    required TResult Function() button1Clicked,
    required TResult Function() initial,
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Instant instant)? $default, {
    TResult Function()? button1Clicked,
    TResult Function()? initial,
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Button1Clicked value) button1Clicked,
    required TResult Function(Initial value) initial,
    required TResult Function(Connecting value) connecting,
    required TResult Function(Connected value) connected,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Button1Clicked value)? button1Clicked,
    TResult Function(Initial value)? initial,
    TResult Function(Connecting value)? connecting,
    TResult Function(Connected value)? connected,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements DeviceState {
  const factory Error([final String message]) = _$Error;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorCopyWith<_$Error> get copyWith => throw _privateConstructorUsedError;
}
