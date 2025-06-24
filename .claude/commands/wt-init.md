---
description: git worktree初期化 - 必要なファイルをrootからコピー
allowed-tools:
  - Read
  - Bash
  - LS
  - Write
---

# Git Worktree初期化

## 1. 現在の状況確認

```bash
!echo "🔍 現在のディレクトリ: $(pwd)"
!echo "📋 Git worktree状況:"
!git worktree list
```

## 2. worktreeかどうかの確認

```bash
!if git rev-parse --git-common-dir 2>/dev/null | grep -q "\.git/worktrees"; then echo "✅ このディレクトリはworktreeです"; else echo "❌ このディレクトリはworktreeではありません。worktreeディレクトリで実行してください。"; exit 1; fi
```

## 3. rootディレクトリのパス取得

```bash
!ROOT_DIR=$(git worktree list | head -1 | awk '{print $1}'); echo "📁 Rootディレクトリ: $ROOT_DIR"
```

## 4. コピー対象ファイルの読み込みとコピー

```bash
!echo "📝 コピー対象ファイルを確認中..."
!ROOT_DIR=$(git worktree list | head -1 | awk '{print $1}'); \
if [ -f "$ROOT_DIR/.claude/wt-copy-files.txt" ]; then \
  echo "✅ コピー対象ファイルリストが見つかりました"; \
  echo ""; \
  while IFS= read -r line || [ -n "$line" ]; do \
    # コメント行と空行をスキップ
    if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$(echo "$line" | tr -d '[:space:]')" ]]; then \
      continue; \
    fi; \
    # ファイル/ディレクトリをコピー
    FILE_PATH="$line"; \
    SOURCE="$ROOT_DIR/$FILE_PATH"; \
    DEST="$FILE_PATH"; \
    if [ -e "$SOURCE" ]; then \
      echo "📋 $FILE_PATH をコピー中..."; \
      # ディレクトリの場合
      if [ -d "$SOURCE" ]; then \
        mkdir -p "$(dirname "$DEST")" 2>/dev/null; \
        cp -r "$SOURCE" "$DEST"; \
        echo "  ✅ ディレクトリをコピーしました"; \
      # ファイルの場合
      else \
        mkdir -p "$(dirname "$DEST")" 2>/dev/null; \
        cp "$SOURCE" "$DEST"; \
        echo "  ✅ ファイルをコピーしました"; \
      fi; \
    else \
      echo "⏭️  $FILE_PATH は存在しません（スキップ）"; \
    fi; \
  done < "$ROOT_DIR/.claude/wt-copy-files.txt"; \
else \
  echo "❌ コピー対象ファイルリストが見つかりません: $ROOT_DIR/.claude/wt-copy-files.txt"; \
fi
```

## 5. Flutter依存関係の取得

```bash
!echo ""
!echo "🔧 Flutter依存関係を取得中..."
!if [ -f "pubspec.yaml" ]; then \
  flutter pub get; \
  echo "✅ Flutter依存関係の取得が完了しました"; \
else \
  echo "ℹ️  pubspec.yamlが見つかりません。Flutterプロジェクトのルートではない可能性があります"; \
fi
```

## 6. melosの初期化（monorepoの場合）

```bash
!if [ -f "melos.yaml" ]; then \
  echo ""; \
  echo "🔧 Melosを初期化中..."; \
  melos bootstrap; \
  echo "✅ Melosの初期化が完了しました"; \
fi
```

## 7. 完了メッセージ

```bash
!echo ""
!echo "🎉 Worktreeの初期化が完了しました！"
!echo ""
!echo "次のステップ:"
!echo "  1. 必要に応じて追加の設定ファイルを手動でコピーしてください"
!echo "  2. 'make gen' でコード生成を実行してください"
!echo "  3. 開発を開始できます！"
```
