import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase/firebase_account_command_repository.dart';
import 'firebase/firebase_account_profile_command_repository.dart';
import 'firebase/firebase_account_profile_query_repository.dart';
import 'firebase/firebase_account_query_repository.dart';
import 'interfaces/account_command_repository.dart';
import 'interfaces/account_profile_command_repository.dart';
import 'interfaces/account_profile_query_repository.dart';
import 'interfaces/account_query_repository.dart';

/// Account Query Repositoryのプロバイダー
///
/// アカウント情報の参照用リポジトリを提供する
final accountQueryRepositoryProvider = Provider<IAccountQueryRepository>((ref) {
  return FirebaseAccountQueryRepository(FirebaseFirestore.instance);
});

/// Account Command Repositoryのプロバイダー
///
/// アカウント情報の更新用リポジトリを提供する
final accountCommandRepositoryProvider = Provider<IAccountCommandRepository>((
  ref,
) {
  return FirebaseAccountCommandRepository(FirebaseFirestore.instance);
});

/// AccountProfile Query Repositoryのプロバイダー
///
/// プロフィール情報の参照用リポジトリを提供する
final accountProfileQueryRepositoryProvider =
    Provider<IAccountProfileQueryRepository>((ref) {
      return FirebaseAccountProfileQueryRepository(FirebaseFirestore.instance);
    });

/// AccountProfile Command Repositoryのプロバイダー
///
/// プロフィール情報の更新用リポジトリを提供する
final accountProfileCommandRepositoryProvider =
    Provider<IAccountProfileCommandRepository>((ref) {
      return FirebaseAccountProfileCommandRepository(
        FirebaseFirestore.instance,
      );
    });
