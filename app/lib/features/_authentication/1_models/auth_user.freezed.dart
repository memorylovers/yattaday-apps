// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthUser.fromJson(json);
}

/// @nodoc
mixin _$AuthUser {
  /// ユーザーID
  String get uid => throw _privateConstructorUsedError;

  /// メールアドレス
  String? get email => throw _privateConstructorUsedError;

  /// 表示名
  String? get displayName => throw _privateConstructorUsedError;

  /// プロフィール画像URL
  String? get photoUrl => throw _privateConstructorUsedError;

  /// 匿名ユーザーかどうか
  bool get isAnonymous => throw _privateConstructorUsedError;

  /// メールアドレスが確認済みかどうか
  bool get isEmailVerified => throw _privateConstructorUsedError;

  /// 電話番号
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// 認証プロバイダーの種類
  List<AuthType> get authTypes => throw _privateConstructorUsedError;

  /// アカウント作成日時
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 最終ログイン日時
  DateTime? get lastSignInAt => throw _privateConstructorUsedError;

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call({
    String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool isAnonymous,
    bool isEmailVerified,
    String? phoneNumber,
    List<AuthType> authTypes,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  });
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? isAnonymous = null,
    Object? isEmailVerified = null,
    Object? phoneNumber = freezed,
    Object? authTypes = null,
    Object? createdAt = freezed,
    Object? lastSignInAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid:
                null == uid
                    ? _value.uid
                    : uid // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayName:
                freezed == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String?,
            photoUrl:
                freezed == photoUrl
                    ? _value.photoUrl
                    : photoUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isAnonymous:
                null == isAnonymous
                    ? _value.isAnonymous
                    : isAnonymous // ignore: cast_nullable_to_non_nullable
                        as bool,
            isEmailVerified:
                null == isEmailVerified
                    ? _value.isEmailVerified
                    : isEmailVerified // ignore: cast_nullable_to_non_nullable
                        as bool,
            phoneNumber:
                freezed == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            authTypes:
                null == authTypes
                    ? _value.authTypes
                    : authTypes // ignore: cast_nullable_to_non_nullable
                        as List<AuthType>,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastSignInAt:
                freezed == lastSignInAt
                    ? _value.lastSignInAt
                    : lastSignInAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthUserImplCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$$AuthUserImplCopyWith(
    _$AuthUserImpl value,
    $Res Function(_$AuthUserImpl) then,
  ) = __$$AuthUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool isAnonymous,
    bool isEmailVerified,
    String? phoneNumber,
    List<AuthType> authTypes,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  });
}

/// @nodoc
class __$$AuthUserImplCopyWithImpl<$Res>
    extends _$AuthUserCopyWithImpl<$Res, _$AuthUserImpl>
    implements _$$AuthUserImplCopyWith<$Res> {
  __$$AuthUserImplCopyWithImpl(
    _$AuthUserImpl _value,
    $Res Function(_$AuthUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? isAnonymous = null,
    Object? isEmailVerified = null,
    Object? phoneNumber = freezed,
    Object? authTypes = null,
    Object? createdAt = freezed,
    Object? lastSignInAt = freezed,
  }) {
    return _then(
      _$AuthUserImpl(
        uid:
            null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
        photoUrl:
            freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isAnonymous:
            null == isAnonymous
                ? _value.isAnonymous
                : isAnonymous // ignore: cast_nullable_to_non_nullable
                    as bool,
        isEmailVerified:
            null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                    as bool,
        phoneNumber:
            freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        authTypes:
            null == authTypes
                ? _value._authTypes
                : authTypes // ignore: cast_nullable_to_non_nullable
                    as List<AuthType>,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastSignInAt:
            freezed == lastSignInAt
                ? _value.lastSignInAt
                : lastSignInAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserImpl implements _AuthUser {
  const _$AuthUserImpl({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
    this.isEmailVerified = false,
    this.phoneNumber,
    final List<AuthType> authTypes = const [],
    this.createdAt,
    this.lastSignInAt,
  }) : _authTypes = authTypes;

  factory _$AuthUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserImplFromJson(json);

  /// ユーザーID
  @override
  final String uid;

  /// メールアドレス
  @override
  final String? email;

  /// 表示名
  @override
  final String? displayName;

  /// プロフィール画像URL
  @override
  final String? photoUrl;

  /// 匿名ユーザーかどうか
  @override
  @JsonKey()
  final bool isAnonymous;

  /// メールアドレスが確認済みかどうか
  @override
  @JsonKey()
  final bool isEmailVerified;

  /// 電話番号
  @override
  final String? phoneNumber;

  /// 認証プロバイダーの種類
  final List<AuthType> _authTypes;

  /// 認証プロバイダーの種類
  @override
  @JsonKey()
  List<AuthType> get authTypes {
    if (_authTypes is EqualUnmodifiableListView) return _authTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authTypes);
  }

  /// アカウント作成日時
  @override
  final DateTime? createdAt;

  /// 最終ログイン日時
  @override
  final DateTime? lastSignInAt;

  @override
  String toString() {
    return 'AuthUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, isAnonymous: $isAnonymous, isEmailVerified: $isEmailVerified, phoneNumber: $phoneNumber, authTypes: $authTypes, createdAt: $createdAt, lastSignInAt: $lastSignInAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality().equals(
              other._authTypes,
              _authTypes,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSignInAt, lastSignInAt) ||
                other.lastSignInAt == lastSignInAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    email,
    displayName,
    photoUrl,
    isAnonymous,
    isEmailVerified,
    phoneNumber,
    const DeepCollectionEquality().hash(_authTypes),
    createdAt,
    lastSignInAt,
  );

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      __$$AuthUserImplCopyWithImpl<_$AuthUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserImplToJson(this);
  }
}

abstract class _AuthUser implements AuthUser {
  const factory _AuthUser({
    required final String uid,
    final String? email,
    final String? displayName,
    final String? photoUrl,
    final bool isAnonymous,
    final bool isEmailVerified,
    final String? phoneNumber,
    final List<AuthType> authTypes,
    final DateTime? createdAt,
    final DateTime? lastSignInAt,
  }) = _$AuthUserImpl;

  factory _AuthUser.fromJson(Map<String, dynamic> json) =
      _$AuthUserImpl.fromJson;

  /// ユーザーID
  @override
  String get uid;

  /// メールアドレス
  @override
  String? get email;

  /// 表示名
  @override
  String? get displayName;

  /// プロフィール画像URL
  @override
  String? get photoUrl;

  /// 匿名ユーザーかどうか
  @override
  bool get isAnonymous;

  /// メールアドレスが確認済みかどうか
  @override
  bool get isEmailVerified;

  /// 電話番号
  @override
  String? get phoneNumber;

  /// 認証プロバイダーの種類
  @override
  List<AuthType> get authTypes;

  /// アカウント作成日時
  @override
  DateTime? get createdAt;

  /// 最終ログイン日時
  @override
  DateTime? get lastSignInAt;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
