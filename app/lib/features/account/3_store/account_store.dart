import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/providers/service_providers.dart';
import '../../../common/types/types.dart';
import '../1_models/account.dart';

part 'account_store.g.dart';

// TODO: Providersではなく、Repositoryにできないか？

/// Account: collectionのreference
@Riverpod(keepAlive: true)
CollectionReference<Account> accountCollectionReference(Ref ref) {
  return FirebaseFirestore.instance
      .collection(Account.collectionPath)
      .withConverter(
        fromFirestore: Account.fromFirestore,
        toFirestore: Account.toFirestore,
      );
}

/// Account: docのreference
@riverpod
Stream<DocumentSnapshot<Account>> accountDocumentSnapshot(Ref ref, String uid) {
  return ref.watch(accountCollectionReferenceProvider).doc(uid).snapshots();
}

/// Account: ログインアカウントのdoc stream
@riverpod
Stream<DocumentPair<Account>?> myAccount(Ref ref) async* {
  final uid = await ref.watch(firebaseUserUidProvider.future);
  if (uid == null) {
    yield null;
    return;
  }

  final snapshot = await ref.watch(accountDocumentSnapshotProvider(uid).future);
  final user = snapshot.data();

  if (user == null) {
    yield null;
  } else {
    yield (data: user, reference: snapshot.reference);
  }
}
