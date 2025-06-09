#!/bin/bash
# cd app && ../_scripts/setup_firebase.sh

set -e
ACCOUNT="team.yatta.day@gmail.com"

ANDROID_PKG_NAME="com.memorylovers.yattaday"
IOS_BUNDLE_ID="com.memorylovers.yattaday"

PROJECT_ID_PROD="yattaday-prod"
PROJECT_ID_DEV="yattaday-stag"

PLATFORMS="android,ios,web"

OUTDIR_FLUTTER="lib/_gen/firebase"
OUTDIR_ANDROID="android/app/src"
OUTDIR_IOS="ios/Runner"

FLAVORS='
dev
stag
prod
'

for f in $FLAVORS; do
  if [ "$f" = "prod" ]; then
    PROJECT_ID="$PROJECT_ID_PROD"
    SUFFIX=""
  else
    PROJECT_ID="$PROJECT_ID_DEV"
    SUFFIX=".$f"
  fi

  echo "FLAVOR: ${f}, ${PROJECT_ID}"
  # for android
  flutterfire configure --yes \
    --project="${PROJECT_ID}" \
    --account="${ACCOUNT}" \
    --out="${OUTDIR_FLUTTER}/firebase_options_${f}.dart" \
    --android-package-name="${ANDROID_PKG_NAME}${SUFFIX}" \
    --android-out="${OUTDIR_ANDROID}/${f}/google-services.json" \
    --platforms="android,web"

  # for ios
  for buildConfig in Debug Release Profile; do
    flutterfire configure --yes \
      --project="${PROJECT_ID}" \
      --account="${ACCOUNT}" \
      --out="${OUTDIR_FLUTTER}/firebase_options_${f}.dart" \
      --ios-bundle-id="${IOS_BUNDLE_ID}${SUFFIX}" \
      --ios-build-config="${buildConfig}-${f}" \
      --ios-out="${OUTDIR_IOS}/${f}/GoogleService-Info.plist" \
      --platforms="ios"
  done
done
