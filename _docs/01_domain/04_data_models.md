# データモデル

## 概要

YattaDayアプリで使用するデータモデルを定義します。各モデルはCloud Firestoreにドキュメントとして保存され、Dartのfreezedクラスとして実装されます。

## ユーザー管理

### User (ユーザー)

ユーザーアカウント情報を管理します。

```dart
class User {
  String id;              // ユーザーID（Firebase Auth UID）
  String? displayName;    // 表示名（Googleアカウント等から取得）
  String? email;          // メールアドレス
  String? photoURL;       // プロフィール画像URL
  AuthType authProvider; // 認証プロバイダー（anonymous, google, apple）
  DateTime createdAt;     // アカウント作成日時
  DateTime updatedAt;     // 最終更新日時
  bool isPremium;         // プレミアム会員フラグ
}

enum AuthType {
  anonymous,
  google,
  apple,
}
```

**Firestoreパス**: `/users/{userId}`

## 記録項目管理

### RecordItem (記録項目)

やったことを記録するための項目を定義します。

```dart
class RecordItem {
  String id;              // 記録項目ID（uuid v7）
  String userId;          // 所有者のユーザーID
  String title;           // 名前
  String? description;    // 説明
  String? unit;           // 単位（例：回、分、ページなど）
  int sortOrder;          // 表示順序
  DateTime createdAt;     // 作成日時
  DateTime updatedAt;     // 最終更新日時
}
```

**Firestoreパス**: `/users/{userId}/recordItems/{id}`

## 記録データ管理

### RecordItemHistory (記録)

特定の日の記録項目の完了状態を管理します。

```dart
class RecordItemHistory {
  String id;              // 日次記録ID（uuid v7）
  String userId;          // ユーザーID
  String date;            // 記録日（yyyy-MM-dd）
  String recordItemId;    // 記録項目ID
  String? note;           // メモ（将来拡張用）
  DateTime createdAt;     // 作成日時
  DateTime updatedAt;     // 最終更新日時
}
```

**Firestoreパス**: `/users/{userId}/recordItems/{recordItemId}/histories/{id}`

## 設定・プリファレンス

### UserSettings (ユーザー設定)

ユーザーの設定やプリファレンスを管理します。

```dart
class UserSettings {
  String userId;          // ユーザーID
  String locale;          // 言語設定（ja, en）
  bool notificationsEnabled; // 通知有効フラグ
  String? notificationTime; // 通知時刻（HH:mm形式）
  DateTime createdAt;     // 作成日時
  DateTime updatedAt;     // 最終更新日時
}
```

**Firestoreパス**: `/user_settings/{userId}`

## データアクセスパターン

### 読み取りパターン

1. **今日の記録一覧表示**
   - `recordItems` コレクションから項目を取得
   - 各記録項目の `histories` サブコレクションから今日の記録を取得
   - コレクショングループクエリで `histories` を一括取得も可能
   - 両者をマージして表示

2. **カレンダー表示**
   - コレクショングループクエリで `histories` を指定月で範囲取得
   - 各日の完了項目数を集計

3. **記録項目詳細**
   - `recordItems/{id}` を取得
   - 履歴表示用に `recordItems/{id}/histories` を範囲クエリ
   - 統計情報はクライアントサイドでリアルタイム計算

### 書き込みパターン

1. **記録の追加/削除**
   - `recordItems/{recordItemId}/histories/{id}` を更新

2. **記録項目の作成/更新**
   - `recordItems/{id}` を更新
   - `sortOrder` を適切に設定

### インデックス設計

以下のFirestoreコンポジットインデックスが必要です：

```
users/{userId}/recordItems/{recordItemId}/histories
- date (ascending)

コレクショングループインデックス:
histories (コレクショングループ)
- userId (ascending), date (ascending)
- recordItemId (ascending), date (ascending)

users/{userId}/recordItems  
- deletedAt (ascending), sortOrder (ascending)
- isArchived (ascending), sortOrder (ascending)
- createdAt (descending)

```

## セキュリティルール

Firestoreセキュリティルールで以下を制御：

- ユーザーは自分のデータのみアクセス可能
- 認証済みユーザーのみ読み書き可能
- 必須フィールドの検証
- データ型の検証

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /recordItems/{itemId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        match /histories/{historyId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      } 
    }
    
    match /user_settings/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
