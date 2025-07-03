/// アカウントプロフィール情報の更新用リポジトリのインターフェース
///
/// Firestoreへのプロフィール情報の作成・更新・削除を行う
/// 書き込み専用のリポジトリインターフェース。
/// CQRSパターンのCommand側を担当する。
abstract class IAccountProfileCommandRepository {
  /// 新規プロフィールを作成する
  ///
  /// アカウント作成と同時に呼び出され、
  /// ユーザーのプロフィール情報を初期化する。
  ///
  /// [uid] ユーザーID（Firebase AuthのUID）
  /// [displayName] 表示名（オプション、デフォルトは空文字列）
  /// [avatarUrl] アバター画像のURL（オプション）
  ///
  /// 例外:
  /// - プロフィールが既に存在する場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.create(
  ///   uid: 'user123',
  ///   displayName: '山田太郎',
  /// );
  /// ```
  Future<void> create({
    required String uid,
    String displayName = '',
    String? avatarUrl,
  });

  /// 既存プロフィール情報を更新する
  ///
  /// ユーザーがプロフィール編集画面で
  /// 情報を変更した際に呼び出される。
  /// 更新日時は自動的に現在時刻に設定される。
  ///
  /// [uid] 更新対象のユーザーID
  /// [displayName] 新しい表示名（nullの場合は更新しない）
  /// [avatarUrl] 新しいアバターURL（nullの場合は更新しない）
  ///
  /// 例外:
  /// - プロフィールが存在しない場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.update(
  ///   uid: 'user123',
  ///   displayName: '山田花子',
  ///   avatarUrl: 'https://example.com/avatar.jpg',
  /// );
  /// ```
  Future<void> update({
    required String uid,
    String? displayName,
    String? avatarUrl,
  });

  /// プロフィールを削除する
  ///
  /// ユーザーの退会処理時に呼び出される。
  /// アカウント削除と連動して実行される。
  ///
  /// [uid] 削除対象のユーザーID
  ///
  /// 例外:
  /// - プロフィールが存在しない場合: [AppException]
  /// - ネットワークエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// await repository.delete('user123');
  /// ```
  Future<void> delete(String uid);

  /// アバター画像をアップロードしてURLを更新する
  ///
  /// プロフィール画像の変更時に使用。
  /// 画像のアップロードとプロフィール更新を
  /// 一連の処理として実行する。
  ///
  /// [uid] 対象のユーザーID
  /// [imagePath] アップロードする画像のパス
  ///
  /// 戻り値:
  /// - アップロードされた画像のURL
  ///
  /// 例外:
  /// - ファイルが存在しない場合: [AppException]
  /// - アップロードエラー: [AppException]
  ///
  /// Example:
  /// ```dart
  /// final avatarUrl = await repository.uploadAvatar(
  ///   'user123',
  ///   '/path/to/image.jpg',
  /// );
  /// print('新しいアバターURL: $avatarUrl');
  /// ```
  Future<String> uploadAvatar(String uid, String imagePath);
}
