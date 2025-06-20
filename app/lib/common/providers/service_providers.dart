import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/services.dart';

// Re-export service types for convenience
export '../../services/services.dart';

// ********************************************************
// * Firebase Services
// ********************************************************

final firebaseServiceProvider = Provider<FirebaseService>(
  (ref) => FirebaseService(),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(),
);

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final analyticsServiceProvider = Provider.autoDispose<AnalyticsService>(
  (ref) => AnalyticsService(),
);

final crashlyticsServiceProvider = Provider<CrashlyticsService>(
  (ref) => CrashlyticsService(),
);

// ********************************************************
// * Auth related providers
// ********************************************************

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).userChanges,
);

final firebaseUserUidProvider = FutureProvider<String?>(
  (ref) => ref.watch(firebaseUserProvider.selectAsync((User? value) => value?.uid)),
);

final firebaseIdTokenProvider = FutureProvider<String?>(
  (ref) async {
    final user = await ref.watch(firebaseUserProvider.future);
    return await user?.getIdToken();
  },
);

// ********************************************************
// * AdMob Services
// ********************************************************

final adMobServiceProvider = Provider.autoDispose<AdMobService>(
  (ref) {
    final service = AdMobService();
    ref.onDispose(service.dispose);
    return service;
  },
);

final adConsentServiceProvider = Provider.autoDispose(
  (ref) => AdConsentService(),
);

// ********************************************************
// * RevenueCat Service
// ********************************************************

final revenueCatServiceProvider = Provider.autoDispose<RevenueCatService>(
  (ref) => RevenueCatService(),
);

// ********************************************************
// * Storage Service
// ********************************************************

final localStorageServiceProvider = Provider.autoDispose<LocalStorageService>(
  (ref) => LocalStorageService(),
);