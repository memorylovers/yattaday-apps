import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/providers/service_providers.dart';
import '../features/_startup/3_store/startup_store.dart';

part 'router_listenable.freezed.dart';
part 'router_listenable.g.dart';

@freezed
class RouterListenable with _$RouterListenable {
  const factory RouterListenable({
    @Default(false) bool signedIn,
    AsyncValue<void>? startupState,
  }) = _RouterListenable;
}

// リダイレクトに必要な値を監視するためのNotifier
@riverpod
Raw<ValueNotifier<RouterListenable>> refreshListenable(Ref ref) {
  final listenable = ValueNotifier<RouterListenable>(const RouterListenable());

  ref.onDispose(listenable.dispose);

  // アプリの初期化状態を監視
  ref.listen(startupProvider, (_, next) {
    listenable.value = listenable.value.copyWith(startupState: next);
  });

  // ログインアカウントのuidが取得できるまで待つ
  ref.listen(firebaseUserUidProvider.select((e) => e.value), (_, uid) {
    listenable.value = listenable.value.copyWith(signedIn: uid != null);
  });

  // Crashlyticsにuidを設定
  ref.listen(firebaseUserUidProvider.select((e) => e.value), (_, uid) async {
    // Webの場合はなにもしない
    if (kIsWeb) return;

    await ref.watch(crashlyticsServiceProvider).setUserId(uid ?? '');
  });

  return listenable;
}
