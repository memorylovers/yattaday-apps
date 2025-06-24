import '../../1_models/account.dart';

/// アカウント情報の更新用リポジトリのインターフェース
///
/// Firestoreへのアカウント情報の作成・更新・削除を行う
/// 書き込み専用のリポジトリインターフェース。
/// CQRSパターンのCommand側を担当する。
abstract class IAccountCommandRepository {
  /// 新規アカウントを作成する
  ///
  /// 認証後の初回ログイン時に呼び出され、
  /// ユーザーのアカウント情報を初期化する。
  ///
  /// [uid] ユーザーID（Firebase AuthのUID）
  ///
  /// 例外:
  /// - アカウントが既に存在する場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.create('user123');
  /// ```
  Future<void> create(String uid);

  /// 既存アカウント情報を更新する
  ///
  /// アカウント設定の変更時に呼び出される。
  /// 更新日時は自動的に現在時刻に設定される。
  ///
  /// [uid] 更新対象のユーザーID
  ///
  /// 注: 現在はupdatedAtのみ更新されるが、将来的に他のフィールドが
  /// 追加された場合は引数を追加する
  ///
  /// 例外:
  /// - アカウントが存在しない場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.update('user123');
  /// ```
  Future<void> update(String uid);

  /// アカウントを削除する
  ///
  /// ユーザーの退会処理時に呼び出される。
  /// 関連するデータの削除は別途処理が必要。
  ///
  /// [uid] 削除対象のユーザーID
  ///
  /// 例外:
  /// - アカウントが存在しない場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.delete('user123');
  /// ```
  Future<void> delete(String uid);

  /// アカウントが存在しない場合のみ作成する
  ///
  /// 認証後の初回ログイン時に呼び出され、
  /// アカウントが既に存在する場合はそのまま返す。
  /// 存在しない場合は新規作成して返す。
  ///
  /// [uid] ユーザーID（Firebase AuthのUID）
  ///
  /// 戻り値: 作成または取得したアカウント情報
  ///
  /// 例外:
  /// - ネットワークエラー: [AppException]
  /// - データベースエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// final account = await repository.createIfNotExists('user123');
  /// ```
  Future<Account> createIfNotExists(String uid);
}
