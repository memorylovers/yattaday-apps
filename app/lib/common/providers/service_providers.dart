import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/services.dart';

// Re-export service types for convenience
export '../../services/services.dart';

// Re-export service providers
export '../../services/admob/admob_service.dart' show adMobServiceProvider;
export '../../services/admob/ad_consent_service.dart' show adConsentServiceProvider;

// ********************************************************
// * Auth related providers
// ********************************************************
final firebaseUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).userChanges,
);

final firebaseUserUidProvider = FutureProvider<String?>(
  (ref) =>
      ref.watch(firebaseUserProvider.selectAsync((User? value) => value?.uid)),
);

final firebaseIdTokenProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(firebaseUserProvider.future);
  return await user?.getIdToken();
});
