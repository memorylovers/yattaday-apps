#!/bin/bash

set -e

# hotfix worktree作成スクリプト
# Usage: ./create_worktree_hotfix.sh <issue-number>
# Example: ./create_worktree_hotfix.sh 456

# 引数チェック
if [ $# -ne 1 ]; then
    echo "Usage: $0 <issue-number>"
    echo "  issue-number: GitHub Issue番号"
    echo ""
    echo "Example:"
    echo "  $0 456"
    exit 1
fi

ISSUE_NUMBER=$1
BRANCH_TYPE="hotfix"

# パラメータ検証
if ! [[ "$ISSUE_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Error: Issue番号は数字である必要があります"
    exit 1
fi

# ブランチ名とディレクトリ名を構築
BRANCH_NAME="${BRANCH_TYPE}/issue-${ISSUE_NUMBER}"
WORKTREE_DIR="../yattaday-apps-${BRANCH_TYPE}-${ISSUE_NUMBER}"

# 現在のリポジトリルートを取得
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")

echo "========================================="
echo "Hotfix Worktree作成中..."
echo "========================================="
echo "Issue番号: #${ISSUE_NUMBER}"
echo "ブランチタイプ: ${BRANCH_TYPE}"
echo "ブランチ名: ${BRANCH_NAME}"
echo "ワークツリーディレクトリ: ${WORKTREE_DIR}"
echo "========================================="

# 既存のブランチをチェック
if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
    echo "Warning: ブランチ '${BRANCH_NAME}' は既に存在します"
    read -p "既存のブランチを使用しますか? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "処理を中止しました"
        exit 1
    fi
fi

# 既存のワークツリーディレクトリをチェック
if [ -d "$WORKTREE_DIR" ]; then
    echo "Warning: ディレクトリ '${WORKTREE_DIR}' は既に存在します"
    read -p "既存のディレクトリを削除して続行しますか? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree remove "$WORKTREE_DIR" 2>/dev/null || true
        rm -rf "$WORKTREE_DIR"
    else
        echo "処理を中止しました"
        exit 1
    fi
fi

# mainブランチから最新の変更を取得
echo "mainブランチを最新に更新中..."
git checkout main
git pull origin main

# ワークツリーを作成
echo "ワークツリーを作成中..."
git worktree add "$WORKTREE_DIR" -b "$BRANCH_NAME"

echo "========================================="
echo "✓ Hotfix Worktreeが正常に作成されました!"
echo "========================================="
echo ""
echo "ワークツリーディレクトリに移動しています..."
cd "$WORKTREE_DIR"

echo "現在のディレクトリ: $(pwd)"
echo ""
echo "作業完了後のクリーンアップ:"
echo "   git worktree remove ${WORKTREE_DIR}"
echo "   git branch -d ${BRANCH_NAME}"
echo ""
echo "プルリクエスト作成時のタイトル例:"
echo "   fix #${ISSUE_NUMBER}: 緊急修正の説明"
echo ""

# 新しいシェルセッションを開始
exec "$SHELL"