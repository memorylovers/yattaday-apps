#!/bin/bash

# CI環境でのエミュレーター設定スクリプト

set -e

echo "Setting up emulator for CI..."

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (iOS Simulator)
  echo "Setting up iOS Simulator..."

  # Xcodeのバージョン確認
  xcodebuild -version

  # 利用可能なシミュレーターをリスト
  xcrun simctl list devices

  # iPhone 15 Proを探すか作成
  DEVICE_NAME="iPhone 15 Pro"
  DEVICE_ID=$(xcrun simctl list devices | grep "$DEVICE_NAME" | grep -v "Max" | head -1 | awk -F'[()]' '{print $2}')

  if [ -z "$DEVICE_ID" ]; then
    echo "Creating $DEVICE_NAME simulator..."
    DEVICE_ID=$(xcrun simctl create "$DEVICE_NAME" "com.apple.CoreSimulator.SimDeviceType.iPhone-15-Pro" "com.apple.CoreSimulator.SimRuntime.iOS-17-0")
  fi

  echo "Using device: $DEVICE_ID"

  # シミュレーターを起動
  xcrun simctl boot $DEVICE_ID || true

  # シミュレーターの準備を待つ
  echo "Waiting for simulator to be ready..."
  xcrun simctl bootstatus $DEVICE_ID

  # 設定を調整（アニメーション無効化など）
  xcrun simctl spawn $DEVICE_ID defaults write com.apple.SpringBoard DisableAnimations -bool true
  xcrun simctl spawn $DEVICE_ID defaults write com.apple.keyboard KeyboardAllowPaddle -bool false
  xcrun simctl spawn $DEVICE_ID defaults write com.apple.keyboard KeyboardAssistant -bool false

  echo "iOS Simulator ready!"
  echo "DEVICE_ID=$DEVICE_ID"

else
  # Linux (Android Emulator)
  echo "Setting up Android Emulator..."

  # エミュレーターのダウンロードと作成
  echo "y" | sdkmanager "platform-tools" "platforms;android-33" "emulator" "system-images;android-33;google_apis;x86_64"

  # AVDの作成
  echo "no" | avdmanager create avd -n test -k "system-images;android-33;google_apis;x86_64" --force

  # エミュレーターの起動
  emulator -avd test -no-window -gpu swiftshader_indirect -no-snapshot -noaudio -no-boot-anim &

  # ADBの起動を待つ
  echo "Waiting for emulator to start..."
  adb wait-for-device

  # ブート完了を待つ
  while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
    echo "Waiting for boot completion..."
    sleep 5
  done

  # アニメーションを無効化
  adb shell settings put global window_animation_scale 0
  adb shell settings put global transition_animation_scale 0
  adb shell settings put global animator_duration_scale 0

  echo "Android Emulator ready!"
fi
