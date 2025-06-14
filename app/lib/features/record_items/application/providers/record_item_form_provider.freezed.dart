// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemFormState {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemFormStateCopyWith<RecordItemFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemFormStateCopyWith<$Res> {
  factory $RecordItemFormStateCopyWith(
    RecordItemFormState value,
    $Res Function(RecordItemFormState) then,
  ) = _$RecordItemFormStateCopyWithImpl<$Res, RecordItemFormState>;
  @useResult
  $Res call({
    String title,
    String description,
    String icon,
    String unit,
    bool isSubmitting,
    String? errorMessage,
  });
}

/// @nodoc
class _$RecordItemFormStateCopyWithImpl<$Res, $Val extends RecordItemFormState>
    implements $RecordItemFormStateCopyWith<$Res> {
  _$RecordItemFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? unit = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            icon:
                null == icon
                    ? _value.icon
                    : icon // ignore: cast_nullable_to_non_nullable
                        as String,
            unit:
                null == unit
                    ? _value.unit
                    : unit // ignore: cast_nullable_to_non_nullable
                        as String,
            isSubmitting:
                null == isSubmitting
                    ? _value.isSubmitting
                    : isSubmitting // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RecordItemFormStateImplCopyWith<$Res>
    implements $RecordItemFormStateCopyWith<$Res> {
  factory _$$RecordItemFormStateImplCopyWith(
    _$RecordItemFormStateImpl value,
    $Res Function(_$RecordItemFormStateImpl) then,
  ) = __$$RecordItemFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    String icon,
    String unit,
    bool isSubmitting,
    String? errorMessage,
  });
}

/// @nodoc
class __$$RecordItemFormStateImplCopyWithImpl<$Res>
    extends _$RecordItemFormStateCopyWithImpl<$Res, _$RecordItemFormStateImpl>
    implements _$$RecordItemFormStateImplCopyWith<$Res> {
  __$$RecordItemFormStateImplCopyWithImpl(
    _$RecordItemFormStateImpl _value,
    $Res Function(_$RecordItemFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? unit = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$RecordItemFormStateImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        icon:
            null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                    as String,
        unit:
            null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                    as String,
        isSubmitting:
            null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
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

class _$RecordItemFormStateImpl extends _RecordItemFormState {
  const _$RecordItemFormStateImpl({
    this.title = '',
    this.description = '',
    this.icon = '📝',
    this.unit = '',
    this.isSubmitting = false,
    this.errorMessage,
  }) : super._();

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RecordItemFormState(title: $title, description: $description, icon: $icon, unit: $unit, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemFormStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    icon,
    unit,
    isSubmitting,
    errorMessage,
  );

  /// Create a copy of RecordItemFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemFormStateImplCopyWith<_$RecordItemFormStateImpl> get copyWith =>
      __$$RecordItemFormStateImplCopyWithImpl<_$RecordItemFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RecordItemFormState extends RecordItemFormState {
  const factory _RecordItemFormState({
    final String title,
    final String description,
    final String icon,
    final String unit,
    final bool isSubmitting,
    final String? errorMessage,
  }) = _$RecordItemFormStateImpl;
  const _RecordItemFormState._() : super._();

  @override
  String get title;
  @override
  String get description;
  @override
  String get icon;
  @override
  String get unit;
  @override
  bool get isSubmitting;
  @override
  String? get errorMessage;

  /// Create a copy of RecordItemFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemFormStateImplCopyWith<_$RecordItemFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
