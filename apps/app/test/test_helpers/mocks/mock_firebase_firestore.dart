import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// FirebaseFirestore用のモック実装
///
/// テストで使用するためのFirebaseFirestoreのモック実装。
/// 実際にはFakeFirebaseFirestoreを拡張して使用する。
class MockFirebaseFirestore extends FakeFirebaseFirestore {
  MockFirebaseFirestore() : super();

  // FakeFirebaseFirestoreがすでに完全な実装を提供しているため、
  // 追加の実装は不要
}
