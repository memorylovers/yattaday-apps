import '../../../../common/types/types.dart';

/// 認証関連のリポジトリのインターフェース
abstract class IAuthRepository {
  /// 現在のログイン情報の取得
  Future<void> me();

  /// サインイン
  Future<void> signIn(AuthType type);

  /// サインアウト
  Future<void> signOut();

  /// アカウントのリンク
  Future<void> linkAccount(AuthType type);

  /// アカウントの削除
  Future<void> delete();
}
