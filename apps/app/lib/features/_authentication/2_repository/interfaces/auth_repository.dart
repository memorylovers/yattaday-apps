import '../../1_models/auth_type.dart';
import '../../1_models/auth_user.dart';

/// 認証関連のリポジトリのインターフェース
///
/// Firebase Authに依存しない認証機能の抽象化。
/// 具体的な認証プロバイダーの実装詳細を隐蔽する。
abstract class IAuthRepository {
  /// 認証状態の監視
  ///
  /// 認証状態の変化をリアルタイムで監視するStreamを返す。
  /// ログイン/ログアウト時に自動的に更新される。
  ///
  /// 戻り値:
  /// - ログイン中: [AuthUser]インスタンス
  /// - 未ログイン: null
  Stream<AuthUser?> watchAuthState();

  /// 現在の認証ユーザーを取得
  ///
  /// 現在ログインしているユーザー情報を取得する。
  ///
  /// 戻り値:
  /// - ログイン中: [AuthUser]インスタンス
  /// - 未ログイン: null
  Future<AuthUser?> getCurrentUser();

  /// サインイン
  ///
  /// 指定された認証プロバイダーでサインインする。
  ///
  /// [type] 認証プロバイダーの種類
  ///
  /// 例外:
  /// - 認証失敗: [AppException]
  /// - ネットワークエラー: [AppException]
  Future<void> signIn(AuthType type);

  /// サインアウト
  ///
  /// 現在のユーザーをサインアウトさせる。
  ///
  /// 例外:
  /// - サインアウト失敗: [AppException]
  Future<void> signOut();

  /// アカウントのリンク
  ///
  /// 現在のアカウントに別の認証プロバイダーをリンクする。
  ///
  /// [type] リンクする認証プロバイダーの種類
  ///
  /// 例外:
  /// - 既にリンク済み: [AppException]
  /// - リンク失敗: [AppException]
  Future<void> linkAccount(AuthType type);

  /// アカウントの削除
  ///
  /// 現在のユーザーアカウントを完全に削除する。
  ///
  /// 例外:
  /// - 削除失敗: [AppException]
  Future<void> delete();
}
