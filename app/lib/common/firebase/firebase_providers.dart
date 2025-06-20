import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/service_providers.dart';

// ********************************************************
// * 注意: Auth関連のプロバイダーはservices/firebase/auth_service.dartに移動しました
// ********************************************************

// ********************************************************
// * Firestore
// ********************************************************
final firebaseFirestoreProvider = Provider<FirestoreService>(
  (ref) => ref.read(firestoreServiceProvider),
);

// Raw Firebase Firestore instance for backward compatibility
final firebaseFirestoreInstanceProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// ********************************************************
// * Crashlytics
// ********************************************************
final firebaseCrashlyticsProvider = Provider<CrashlyticsService>(
  (ref) => ref.read(crashlyticsServiceProvider),
);

// Raw Firebase Crashlytics instance for backward compatibility
final firebaseCrashlyticsInstanceProvider = Provider<FirebaseCrashlytics>(
  (ref) => FirebaseCrashlytics.instance,
);

// ********************************************************
// * Analytics
// ********************************************************
final firebaseAnalyticsProvider = Provider.autoDispose<AnalyticsService>(
  (ref) => ref.read(analyticsServiceProvider),
);

// Raw Firebase Analytics instance for backward compatibility
final firebaseAnalyticsInstanceProvider = Provider.autoDispose<FirebaseAnalytics>(
  (ref) => FirebaseAnalytics.instance,
);

// ********************************************************
// * Functions
// ********************************************************
// @Riverpod(keepAlive: true)
// FirebaseFunctions firebaseFunctions(Ref ref) => FirebaseFunctions.instanceFor(
//       region: 'asia-northeast1',
//     );

// ********************************************************
// * Storage
// ********************************************************
// @Riverpod(keepAlive: true)
// FirebaseStorage firebaseStorage(Ref ref) => FirebaseStorage.instance;

// @riverpod
// Future<String> firebaseStorageGsFileDownloadUrl(
//   Ref ref, {
//   required String fileUri,
// }) async {
//   ref.cacheFor(const Duration(minutes: 5));

//   if (fileUri.startsWith('gs://')) {
//     return ref
//         .watch(firebaseStorageProvider)
//         .refFromURL(fileUri)
//         .getDownloadURL();
//   } else {
//     return fileUri;
//   }
// }
