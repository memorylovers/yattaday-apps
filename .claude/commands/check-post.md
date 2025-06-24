---
description: 完了条件をチェックし、満たしていない場合は自動修正
allowed-tools:
  - Read
  - Bash
  - MultiEdit
  - LS
  - Glob
---

# 完了条件チェックと自動修正

## app/CLAUDE.mdの完了条件を確認

@app/CLAUDE.md の「完了条件」セクションを読み込み、以下の項目をチェックします：

### 1. フォーマットの適用

```bash
!echo "📝 フォーマットを適用中..."
!make format
```

### 2. コード生成の最新化

```bash
!echo "🔧 コード生成を実行中..."
!make gen
```

### 3. 静的解析のチェック

```bash
!echo "🔍 静的解析を実行中..."
!make lint
```

静的解析でエラーが出た場合は、エラー内容を確認して修正してください。

### 4. テストの実行

```bash
!echo "🧪 テストを実行中..."
!make test
```

テストが失敗した場合は、失敗した原因を確認して修正してください。

### 5. Widgetbook登録の確認

UI層（Page/Component）を追加・変更した場合：

1. 対応するWidgetbookのUseCaseが作成されているか確認
2. `widgetbook/lib/main.directories.g.dart`に自動登録されているか確認

```bash
!echo "📚 Widgetbook登録状況を確認中..."
!if [ -f "widgetbook/lib/main.directories.g.dart" ]; then echo "✅ Widgetbookファイルが存在します"; cat widgetbook/lib/main.directories.g.dart | grep -E "(Page|Component)" | head -20; else echo "❌ Widgetbookファイルが見つかりません"; fi
```

## 完了条件のサマリー

以下のすべての条件が満たされているか確認：

- [ ] **フォーマットが適用されていること**: `make format` ✅
- [ ] **コード生成が最新化されていること**: `make gen` ✅
- [ ] **テストが通過していること**: `make test`
- [ ] **静的解析が通過していること**: `make lint`
- [ ] **Page/ComponentがすべてWidgetbook登録されていること**: `lib/main.directories.g.dart`で確認

## 追加の確認事項

- TDDで実装されているか（ビジネスロジック層）
- ドキュメントコメントが記載されているか
- エラーハンドリングが適切か（AppExceptionの使用）

すべての条件が満たされていない場合は、該当する修正を行ってください。
