// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsPageStateCopyWith<SettingsPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsPageStateCopyWith<$Res> {
  factory $SettingsPageStateCopyWith(
    SettingsPageState value,
    $Res Function(SettingsPageState) then,
  ) = _$SettingsPageStateCopyWithImpl<$Res, SettingsPageState>;
  @useResult
  $Res call({bool isLoading, String? errorMessage});
}

/// @nodoc
class _$SettingsPageStateCopyWithImpl<$Res, $Val extends SettingsPageState>
    implements $SettingsPageStateCopyWith<$Res> {
  _$SettingsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? errorMessage = freezed}) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsPageStateImplCopyWith<$Res>
    implements $SettingsPageStateCopyWith<$Res> {
  factory _$$SettingsPageStateImplCopyWith(
    _$SettingsPageStateImpl value,
    $Res Function(_$SettingsPageStateImpl) then,
  ) = __$$SettingsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$SettingsPageStateImplCopyWithImpl<$Res>
    extends _$SettingsPageStateCopyWithImpl<$Res, _$SettingsPageStateImpl>
    implements _$$SettingsPageStateImplCopyWith<$Res> {
  __$$SettingsPageStateImplCopyWithImpl(
    _$SettingsPageStateImpl _value,
    $Res Function(_$SettingsPageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? errorMessage = freezed}) {
    return _then(
      _$SettingsPageStateImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SettingsPageStateImpl implements _SettingsPageState {
  const _$SettingsPageStateImpl({this.isLoading = false, this.errorMessage});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SettingsPageState(isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, errorMessage);

  /// Create a copy of SettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsPageStateImplCopyWith<_$SettingsPageStateImpl> get copyWith =>
      __$$SettingsPageStateImplCopyWithImpl<_$SettingsPageStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SettingsPageState implements SettingsPageState {
  const factory _SettingsPageState({
    final bool isLoading,
    final String? errorMessage,
  }) = _$SettingsPageStateImpl;

  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of SettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsPageStateImplCopyWith<_$SettingsPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
