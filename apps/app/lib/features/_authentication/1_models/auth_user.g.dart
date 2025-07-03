// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      authTypes:
          (json['authTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AuthTypeEnumMap, e))
              .toList() ??
          const [],
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      lastSignInAt:
          json['lastSignInAt'] == null
              ? null
              : DateTime.parse(json['lastSignInAt'] as String),
    );

Map<String, dynamic> _$$AuthUserImplToJson(
  _$AuthUserImpl instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'isAnonymous': instance.isAnonymous,
  'isEmailVerified': instance.isEmailVerified,
  'phoneNumber': instance.phoneNumber,
  'authTypes': instance.authTypes.map((e) => _$AuthTypeEnumMap[e]!).toList(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
};

const _$AuthTypeEnumMap = {
  AuthType.google: 'google',
  AuthType.apple: 'apple',
  AuthType.anonymous: 'anonymous',
};
