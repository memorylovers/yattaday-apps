all: fvm fvm_install melos melos_bs flutterfire_cli

fvm:
	brew tap leoafarias/fvm
	brew install fvm

fvm_install:
	fvm install --setup

melos:
	dart pub global activate melos

melos_bs:
	melos bootstrap

gen:
	melos run gen --no-select

flutterfire_cli:
	fvm dart pub global activate flutterfire_cli

check-all:
	make format && make lint && make test

format:
	melos run format --no-select

lint: lint-flutter lint-md

lint-flutter:
	melos run lint --no-select

lint-md:
	npx markdownlint-cli2 "**/*.md" "#**/.dart_tool" "#**/.fvm" "#**/ios"

test:
	melos run test

book:
	cd widgetbook && fvm flutter run lib/main.dart --device-id=chrome

mock:
	npx http-server app-mock/

# Maestro E2Eテスト
e2e:
	./_scripts/run_maestro_tests.sh

e2e-ios:
	./_scripts/run_maestro_tests.sh --ios

e2e-android:
	./_scripts/run_maestro_tests.sh --android

e2e-login:
	./_scripts/run_maestro_tests.sh login

e2e-create:
	./_scripts/run_maestro_tests.sh create

e2e-edit:
	./_scripts/run_maestro_tests.sh edit

e2e-full:
	./_scripts/run_maestro_tests.sh e2e

# Maestroのインストール
maestro:
	curl -Ls "https://get.maestro.mobile.dev" | bash
	@echo "PATHに以下を追加してください: export PATH=\"\$$PATH:\$$HOME/.maestro/bin\""

cc:
	npx ccusage@latest
