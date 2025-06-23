import '../../1_models/profile.dart';

/// アカウントプロフィール情報の参照用リポジトリのインターフェース
///
/// Firestoreからプロフィール情報を取得するための
/// 読み取り専用のリポジトリインターフェース。
/// CQRSパターンのQuery側を担当する。
abstract class IAccountProfileQueryRepository {
  /// 指定されたUIDのプロフィール情報を取得する
  ///
  /// [uid] 取得対象のユーザーID
  ///
  /// 戻り値:
  /// - プロフィールが存在する場合: [AccountProfile]インスタンス
  /// - プロフィールが存在しない場合: null
  ///
  /// Example:
  /// ```dart
  /// final profile = await repository.getById('user123');
  /// if (profile != null) {
  ///   print('表示名: ${profile.displayName}');
  /// }
  /// ```
  Future<AccountProfile?> getById(String uid);

  /// 指定されたUIDのプロフィール情報をリアルタイムで監視する
  ///
  /// Firestoreのリアルタイムリスナーを使用して、
  /// プロフィール情報の変更を監視するStreamを返す。
  ///
  /// [uid] 監視対象のユーザーID
  ///
  /// 戻り値:
  /// - プロフィール情報の変更を通知するStream
  /// - プロフィールが削除された場合はnullを流す
  ///
  /// Example:
  /// ```dart
  /// repository.watchById('user123').listen((profile) {
  ///   if (profile != null) {
  ///     print('プロフィール更新: ${profile.displayName}');
  ///   }
  /// });
  /// ```
  Stream<AccountProfile?> watchById(String uid);

  /// 表示名で検索してプロフィール一覧を取得する
  ///
  /// ユーザー検索機能で使用される。
  /// 部分一致検索をサポートする。
  ///
  /// [query] 検索クエリ（表示名の一部）
  /// [limit] 取得件数の上限（デフォルト: 20）
  ///
  /// 戻り値:
  /// - 検索条件に一致するプロフィールのリスト
  /// - 一致するものがない場合は空のリスト
  ///
  /// Example:
  /// ```dart
  /// final profiles = await repository.searchByDisplayName('太郎');
  /// print('検索結果: ${profiles.length}件');
  /// ```
  Future<List<AccountProfile>> searchByDisplayName(
    String query, {
    int limit = 20,
  });

  /// 複数のUIDからプロフィール情報を一括取得する
  ///
  /// フレンドリストやグループメンバーの
  /// プロフィール情報を効率的に取得する際に使用。
  ///
  /// [uids] 取得対象のユーザーIDリスト
  ///
  /// 戻り値:
  /// - 存在するプロフィールのリスト
  /// - 存在しないUIDは結果に含まれない
  ///
  /// Example:
  /// ```dart
  /// final profiles = await repository.getByIds(['user1', 'user2', 'user3']);
  /// print('取得できたプロフィール: ${profiles.length}件');
  /// ```
  Future<List<AccountProfile>> getByIds(List<String> uids);
}
