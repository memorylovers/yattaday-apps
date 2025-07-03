all: fvm fvm_install melos melos_bs flutterfire_cli submodule

fvm:
	brew tap leoafarias/fvm
	brew install fvm

fvm_install:
	fvm install --setup

submodule:
	git submodule update --init --recursive

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

run:
	cd apps/app && fvm flutter run lib/main.dart --flavor=stag

book:
	cd apps/widgetbook && fvm flutter run lib/main.dart --device-id=chrome

# mockコマンドは削除（app-mockディレクトリは削除済み）

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

# Planning file management
plan-new:
	@mkdir -p _planning
	@filename=$$(date +"%y%m%d_%H%M")_$${name:-task}.md; \
	touch _planning/$$filename && \
	echo "# $${name:-task}" > _planning/$$filename && \
	echo "" >> _planning/$$filename && \
	echo "作成日時: $$(date +"%Y-%m-%d %H:%M")" >> _planning/$$filename && \
	echo "" >> _planning/$$filename && \
	echo "## 概要" >> _planning/$$filename && \
	echo "" >> _planning/$$filename && \
	echo "## タスク" >> _planning/$$filename && \
	echo "" >> _planning/$$filename && \
	echo "Created: _planning/$$filename"
