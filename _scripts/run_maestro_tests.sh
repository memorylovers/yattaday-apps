#!/bin/bash

# Maestro E2Eテスト実行スクリプト
# 使用方法:
#   ./run_maestro_tests.sh                    # 全てのテストを実行
#   ./run_maestro_tests.sh login             # ログインテストのみ実行
#   ./run_maestro_tests.sh --ios            # iOSシミュレータで実行
#   ./run_maestro_tests.sh --android        # Androidエミュレータで実行

set -e

# カラー出力の設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# プロジェクトルートディレクトリへ移動
cd "$(dirname "$0")/.."

# デフォルト設定
PLATFORM=""
TEST_FLOW=""
DEVICE_ID=""

# 引数の解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --ios)
            PLATFORM="ios"
            shift
            ;;
        --android)
            PLATFORM="android"
            shift
            ;;
        --device)
            DEVICE_ID="$2"
            shift 2
            ;;
        login|create|edit|e2e)
            TEST_FLOW="$1"
            shift
            ;;
        *)
            echo -e "${RED}不明なオプション: $1${NC}"
            exit 1
            ;;
    esac
done

# Maestroがインストールされているか確認
if ! command -v maestro &> /dev/null; then
    echo -e "${YELLOW}Maestroがインストールされていません。インストールしています...${NC}"
    curl -Ls "https://get.maestro.mobile.dev" | bash
    export PATH="$PATH:$HOME/.maestro/bin"
fi

# Flutterアプリのビルド（必要に応じて）
echo -e "${GREEN}Flutterアプリをビルドしています...${NC}"
cd app

if [[ "$PLATFORM" == "ios" ]]; then
    echo "iOSアプリをビルド中..."
    fvm flutter build ios --debug --flavor stag --simulator
elif [[ "$PLATFORM" == "android" ]]; then
    echo "Androidアプリをビルド中..."
    fvm flutter build apk --debug --flavor stag
else
    # プラットフォームが指定されていない場合は両方ビルド
    echo "iOS/Androidアプリをビルド中..."
    fvm flutter build ios --debug --flavor stag --simulator
    fvm flutter build apk --debug --flavor stag
fi

cd ..

# アプリのインストール
echo -e "${GREEN}アプリをデバイスにインストールしています...${NC}"
if [[ "$PLATFORM" == "android" ]]; then
    # Androidの場合はAPKを直接インストール
    adb install -r app/build/app/outputs/flutter-apk/app-stag-debug.apk
elif [[ "$PLATFORM" == "ios" ]]; then
    # iOSの場合はxcrunでインストール
    if [[ -n "$DEVICE_ID" ]]; then
        xcrun simctl install "$DEVICE_ID" app/build/ios/iphonesimulator/Runner.app
    else
        xcrun simctl install booted app/build/ios/iphonesimulator/Runner.app
    fi
fi

# テストの実行
echo -e "${GREEN}E2Eテストを実行しています...${NC}"

# 実行するテストファイルを決定
if [[ -n "$TEST_FLOW" ]]; then
    case $TEST_FLOW in
        login)
            TEST_FILE=".maestro/flows/01_login_flow.yaml"
            ;;
        create)
            TEST_FILE=".maestro/flows/02_record_item_create_flow.yaml"
            ;;
        edit)
            TEST_FILE=".maestro/flows/03_record_item_edit_delete_flow.yaml"
            ;;
        e2e)
            TEST_FILE=".maestro/flows/04_end_to_end_flow.yaml"
            ;;
    esac

    echo "実行するテスト: $TEST_FILE"

    # 単一のテストを実行
    if [[ -n "$DEVICE_ID" ]]; then
        maestro test --device "$DEVICE_ID" "$TEST_FILE"
    else
        maestro test "$TEST_FILE"
    fi
else
    # 全てのテストを実行
    echo "全てのテストフローを実行します..."

    if [[ -n "$DEVICE_ID" ]]; then
        maestro test --device "$DEVICE_ID" .maestro/flows/
    else
        maestro test .maestro/flows/
    fi
fi

# テスト結果の確認
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ E2Eテストが正常に完了しました！${NC}"

    # スクリーンショットの保存場所を表示
    if [ -d ".maestro/screenshots" ]; then
        echo -e "${YELLOW}スクリーンショットは以下に保存されています:${NC}"
        echo ".maestro/screenshots/"
        ls -la .maestro/screenshots/
    fi
else
    echo -e "${RED}✗ E2Eテストが失敗しました${NC}"
    exit 1
fi

# レポートの生成（オプション）
if command -v maestro-cloud &> /dev/null; then
    echo -e "${GREEN}テストレポートを生成しています...${NC}"
    # Maestro Cloudを使用したレポート生成
    # maestro-cloud --apiKey YOUR_API_KEY upload .maestro/
fi
