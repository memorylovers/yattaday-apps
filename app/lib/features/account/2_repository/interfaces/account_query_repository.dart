import '../../1_models/account.dart';

/// アカウント情報の参照用リポジトリのインターフェース
///
/// Firestoreからアカウント情報を取得するための
/// 読み取り専用のリポジトリインターフェース。
/// CQRSパターンのQuery側を担当する。
abstract class IAccountQueryRepository {
  /// 指定されたUIDのアカウント情報を取得する
  ///
  /// [uid] 取得対象のユーザーID
  ///
  /// 戻り値:
  /// - アカウントが存在する場合: [Account]インスタンス
  /// - アカウントが存在しない場合: null
  ///
  /// Example:
  /// ```dart
  /// final account = await repository.getById('user123');
  /// if (account != null) {
  ///   print('アカウント作成日: ${account.createdAt}');
  /// }
  /// ```
  Future<Account?> getById(String uid);

  /// 指定されたUIDのアカウント情報をリアルタイムで監視する
  ///
  /// Firestoreのリアルタイムリスナーを使用して、
  /// アカウント情報の変更を監視するStreamを返す。
  ///
  /// [uid] 監視対象のユーザーID
  ///
  /// 戻り値:
  /// - アカウント情報の変更を通知するStream
  /// - アカウントが削除された場合はnullを流す
  ///
  /// Example:
  /// ```dart
  /// repository.watchById('user123').listen((account) {
  ///   if (account != null) {
  ///     print('アカウント更新: ${account.updatedAt}');
  ///   }
  /// });
  /// ```
  Stream<Account?> watchById(String uid);

  /// 指定されたUIDのアカウントが存在するかチェックする
  ///
  /// アカウントの存在確認のみを行う軽量なメソッド。
  /// 詳細情報が不要な場合はこちらを使用する。
  ///
  /// [uid] 確認対象のユーザーID
  ///
  /// 戻り値:
  /// - アカウントが存在する場合: true
  /// - アカウントが存在しない場合: false
  ///
  /// Example:
  /// ```dart
  /// final exists = await repository.exists('user123');
  /// if (!exists) {
  ///   // 新規アカウント作成処理
  /// }
  /// ```
  Future<bool> exists(String uid);
}
