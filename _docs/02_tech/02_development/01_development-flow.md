# 開発フロー

## 概要

本プロジェクトでは、品質とスピードのバランスを取った「軽量化TDD戦略」を採用しています。層によってテスト手法を使い分けることで、効率的な品質保証を実現します。

## 開発の基本サイクル

### 1. 計画フェーズ

```bash
# 計画ドキュメントの作成
make plan-new name=<機能名>
```

- `_planning/`ディレクトリに計画ドキュメントを作成
- 命名規則: `YYMMDD_HHMM_<説明>.md`
- 実装前に設計を明確化

### 2. 実装フェーズ（TDDサイクル）

#### Red フェーズ（テスト作成）

**TDD対象層のみ:**
- 1_models
- 2_repository
- 3_store
- 4_flow
- 5_view_model（複雑なロジックがある場合）

```dart
// test/features/record_item/models/record_item_test.dart
void main() {
  group('RecordItem', () {
    test('should calculate streak correctly', () {
      final item = RecordItem(id: '1', title: 'Test');
      final dates = [DateTime(2024, 1, 1), DateTime(2024, 1, 2)];
      
      expect(item.calculateStreak(dates), equals(2));
    });
  });
}
```

#### Green フェーズ（実装）

最小限のコードでテストを通す：

```dart
// lib/features/record_item/1_models/record_item.dart
int calculateStreak(List<DateTime> dates) {
  return dates.length; // 最小限の実装
}
```

#### Refactor フェーズ（リファクタリング）

テストが通る状態を維持しながら改善：

```dart
int calculateStreak(List<DateTime> dates) {
  if (dates.isEmpty) return 0;
  
  final sortedDates = dates.toList()..sort();
  int streak = 1;
  
  for (int i = 1; i < sortedDates.length; i++) {
    final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
    if (diff == 1) {
      streak++;
    } else {
      break;
    }
  }
  
  return streak;
}
```

### 3. UI実装フェーズ

#### Widgetbook実装（Page/Component）

```dart
// widgetbook/lib/features/record_item/record_item_card.dart
@UseCase(name: 'Default', type: RecordItemCard)
Widget buildRecordItemCardDefaultUseCase(BuildContext context) {
  return RecordItemCard(
    item: RecordItem(
      id: '1',
      title: 'サンプルアイテム',
      unit: '回',
    ),
  );
}
```

### 4. 品質保証フェーズ

```bash
# フォーマット
make format

# コード生成
make gen

# リント
make lint

# テスト実行
make test
```

## 複雑なロジックの判断基準

以下のいずれかに該当する場合は「複雑なロジック」としてTDDを適用：

1. **条件分岐が3つ以上**
   ```dart
   if (condition1) {
     // 処理1
   } else if (condition2) {
     // 処理2
   } else if (condition3) {
     // 処理3
   } else {
     // デフォルト処理
   }
   ```

2. **非同期処理の組み合わせ**
   ```dart
   final result1 = await api1();
   final result2 = await api2(result1);
   final result3 = await api3(result2);
   ```

3. **エラーハンドリングが必要**
   ```dart
   try {
     await riskyOperation();
   } on SpecificException catch (e) {
     // 特定のエラー処理
   } catch (e) {
     // 一般的なエラー処理
   }
   ```

4. **状態遷移が複雑（3つ以上の状態）**
   ```dart
   enum ProcessState {
     initial,
     loading,
     processing,
     completed,
     error,
   }
   ```

5. **ビジネスルールの実装**
   - 料金計算
   - 権限チェック
   - バリデーションルール

## 完了条件チェックリスト

- [ ] **フォーマットが適用されていること**: `make format`
- [ ] **コード生成が最新化されていること**: `make gen`
- [ ] **テストが通過していること**: `make test`
- [ ] **静的解析が通過していること**: `make lint`
- [ ] **Page/ComponentがすべてWidgetbook登録されていること**
  - `lib/main.directories.g.dart`で確認

## トラブルシューティング

### コード生成でエラーが出る場合

```bash
# キャッシュクリア
cd app && dart run build_runner clean
cd app && dart run build_runner build --delete-conflicting-outputs
```

### テストが失敗する場合

```bash
# 特定のテストのみ実行
cd app && flutter test test/features/record_item/models/record_item_test.dart
```

### Widgetbookが更新されない場合

```bash
# Widgetbookのコード生成
cd widgetbook && dart run build_runner build
make book
```

## ベストプラクティス

1. **小さいコミット**: 機能単位で細かくコミット
2. **継続的な実行**: 各フェーズ後に`make test`を実行
3. **早期フィードバック**: CIでの自動チェックを活用
4. **ペアプログラミング**: 複雑な実装は2人で実施
5. **定期的なリファクタリング**: 技術的負債を溜めない