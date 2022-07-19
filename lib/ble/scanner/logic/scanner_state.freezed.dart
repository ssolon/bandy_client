// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'scanner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScannerState {
  bool get scanning => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices) $default, {
    required TResult Function(bool scanning) initial,
    required TResult Function(bool scanning) loading,
    required TResult Function(bool scanning, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScannerStateCopyWith<ScannerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannerStateCopyWith<$Res> {
  factory $ScannerStateCopyWith(
          ScannerState value, $Res Function(ScannerState) then) =
      _$ScannerStateCopyWithImpl<$Res>;
  $Res call({bool scanning});
}

/// @nodoc
class _$ScannerStateCopyWithImpl<$Res> implements $ScannerStateCopyWith<$Res> {
  _$ScannerStateCopyWithImpl(this._value, this._then);

  final ScannerState _value;
  // ignore: unused_field
  final $Res Function(ScannerState) _then;

  @override
  $Res call({
    Object? scanning = freezed,
  }) {
    return _then(_value.copyWith(
      scanning: scanning == freezed
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$DataCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$$DataCopyWith(_$Data value, $Res Function(_$Data) then) =
      __$$DataCopyWithImpl<$Res>;
  @override
  $Res call({bool scanning, List<ScannedDevice> devices});
}

/// @nodoc
class __$$DataCopyWithImpl<$Res> extends _$ScannerStateCopyWithImpl<$Res>
    implements _$$DataCopyWith<$Res> {
  __$$DataCopyWithImpl(_$Data _value, $Res Function(_$Data) _then)
      : super(_value, (v) => _then(v as _$Data));

  @override
  _$Data get _value => super._value as _$Data;

  @override
  $Res call({
    Object? scanning = freezed,
    Object? devices = freezed,
  }) {
    return _then(_$Data(
      scanning: scanning == freezed
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool,
      devices: devices == freezed
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<ScannedDevice>,
    ));
  }
}

/// @nodoc

class _$Data implements Data {
  const _$Data(
      {this.scanning = false, required final List<ScannedDevice> devices})
      : _devices = devices;

  @override
  @JsonKey()
  final bool scanning;
  final List<ScannedDevice> _devices;
  @override
  List<ScannedDevice> get devices {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  String toString() {
    return 'ScannerState(scanning: $scanning, devices: $devices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Data &&
            const DeepCollectionEquality().equals(other.scanning, scanning) &&
            const DeepCollectionEquality().equals(other._devices, _devices));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(scanning),
      const DeepCollectionEquality().hash(_devices));

  @JsonKey(ignore: true)
  @override
  _$$DataCopyWith<_$Data> get copyWith =>
      __$$DataCopyWithImpl<_$Data>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices) $default, {
    required TResult Function(bool scanning) initial,
    required TResult Function(bool scanning) loading,
    required TResult Function(bool scanning, String message) error,
  }) {
    return $default(scanning, devices);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
  }) {
    return $default?.call(scanning, devices);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(scanning, devices);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Data implements ScannerState {
  const factory Data(
      {final bool scanning,
      required final List<ScannedDevice> devices}) = _$Data;

  @override
  bool get scanning;
  List<ScannedDevice> get devices;
  @override
  @JsonKey(ignore: true)
  _$$DataCopyWith<_$Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitialCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$$InitialCopyWith(_$Initial value, $Res Function(_$Initial) then) =
      __$$InitialCopyWithImpl<$Res>;
  @override
  $Res call({bool scanning});
}

/// @nodoc
class __$$InitialCopyWithImpl<$Res> extends _$ScannerStateCopyWithImpl<$Res>
    implements _$$InitialCopyWith<$Res> {
  __$$InitialCopyWithImpl(_$Initial _value, $Res Function(_$Initial) _then)
      : super(_value, (v) => _then(v as _$Initial));

  @override
  _$Initial get _value => super._value as _$Initial;

  @override
  $Res call({
    Object? scanning = freezed,
  }) {
    return _then(_$Initial(
      scanning: scanning == freezed
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$Initial implements Initial {
  const _$Initial({this.scanning = false});

  @override
  @JsonKey()
  final bool scanning;

  @override
  String toString() {
    return 'ScannerState.initial(scanning: $scanning)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Initial &&
            const DeepCollectionEquality().equals(other.scanning, scanning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(scanning));

  @JsonKey(ignore: true)
  @override
  _$$InitialCopyWith<_$Initial> get copyWith =>
      __$$InitialCopyWithImpl<_$Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices) $default, {
    required TResult Function(bool scanning) initial,
    required TResult Function(bool scanning) loading,
    required TResult Function(bool scanning, String message) error,
  }) {
    return initial(scanning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
  }) {
    return initial?.call(scanning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(scanning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements ScannerState {
  const factory Initial({final bool scanning}) = _$Initial;

  @override
  bool get scanning;
  @override
  @JsonKey(ignore: true)
  _$$InitialCopyWith<_$Initial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$$LoadingCopyWith(_$Loading value, $Res Function(_$Loading) then) =
      __$$LoadingCopyWithImpl<$Res>;
  @override
  $Res call({bool scanning});
}

/// @nodoc
class __$$LoadingCopyWithImpl<$Res> extends _$ScannerStateCopyWithImpl<$Res>
    implements _$$LoadingCopyWith<$Res> {
  __$$LoadingCopyWithImpl(_$Loading _value, $Res Function(_$Loading) _then)
      : super(_value, (v) => _then(v as _$Loading));

  @override
  _$Loading get _value => super._value as _$Loading;

  @override
  $Res call({
    Object? scanning = freezed,
  }) {
    return _then(_$Loading(
      scanning: scanning == freezed
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$Loading implements Loading {
  const _$Loading({this.scanning = false});

  @override
  @JsonKey()
  final bool scanning;

  @override
  String toString() {
    return 'ScannerState.loading(scanning: $scanning)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Loading &&
            const DeepCollectionEquality().equals(other.scanning, scanning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(scanning));

  @JsonKey(ignore: true)
  @override
  _$$LoadingCopyWith<_$Loading> get copyWith =>
      __$$LoadingCopyWithImpl<_$Loading>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices) $default, {
    required TResult Function(bool scanning) initial,
    required TResult Function(bool scanning) loading,
    required TResult Function(bool scanning, String message) error,
  }) {
    return loading(scanning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
  }) {
    return loading?.call(scanning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(scanning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements ScannerState {
  const factory Loading({final bool scanning}) = _$Loading;

  @override
  bool get scanning;
  @override
  @JsonKey(ignore: true)
  _$$LoadingCopyWith<_$Loading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$$ErrorCopyWith(_$Error value, $Res Function(_$Error) then) =
      __$$ErrorCopyWithImpl<$Res>;
  @override
  $Res call({bool scanning, String message});
}

/// @nodoc
class __$$ErrorCopyWithImpl<$Res> extends _$ScannerStateCopyWithImpl<$Res>
    implements _$$ErrorCopyWith<$Res> {
  __$$ErrorCopyWithImpl(_$Error _value, $Res Function(_$Error) _then)
      : super(_value, (v) => _then(v as _$Error));

  @override
  _$Error get _value => super._value as _$Error;

  @override
  $Res call({
    Object? scanning = freezed,
    Object? message = freezed,
  }) {
    return _then(_$Error(
      scanning: scanning == freezed
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error implements Error {
  const _$Error({this.scanning = false, this.message = ''});

  @override
  @JsonKey()
  final bool scanning;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'ScannerState.error(scanning: $scanning, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error &&
            const DeepCollectionEquality().equals(other.scanning, scanning) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(scanning),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$ErrorCopyWith<_$Error> get copyWith =>
      __$$ErrorCopyWithImpl<_$Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices) $default, {
    required TResult Function(bool scanning) initial,
    required TResult Function(bool scanning) loading,
    required TResult Function(bool scanning, String message) error,
  }) {
    return error(scanning, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
  }) {
    return error?.call(scanning, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool scanning, List<ScannedDevice> devices)? $default, {
    TResult Function(bool scanning)? initial,
    TResult Function(bool scanning)? loading,
    TResult Function(bool scanning, String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(scanning, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements ScannerState {
  const factory Error({final bool scanning, final String message}) = _$Error;

  @override
  bool get scanning;
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ErrorCopyWith<_$Error> get copyWith => throw _privateConstructorUsedError;
}
