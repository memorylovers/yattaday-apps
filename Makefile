all: fvm fvm_install melos melos_bs flutterfire_cli

fvm:
	brew tap leoafarias/fvm
	brew install fvm

fvm_install:
	fvm install --setup

melos:
	dart pub global activate melos

melos_bs:
	dart pub get

generate_code:
	melos run gen --no-select

flutterfire_cli:
	fvm dart pub global activate flutterfire_cli

format:
	@echo "Formatting app files (excluding generated files)..."
	find app -name "*.dart" \
		-not -path "**/.*" \
		-not -path "**/*.g.dart" \
		-not -path "**/*.freezed.dart" \
		-not -path "**/firebase_options*.dart" \
		-not -path "**/_gen/**" \
		-not -path "**/build/**" \
		| xargs fvm dart format
	@echo "Formatting widgetbook files (excluding generated files)..."
	find widgetbook -name "*.dart" \
		-not -path "**/.*" \
		-not -path "**/*.g.dart" \
		-not -path "**/*.freezed.dart" \
		-not -path "**/build/**" \
		| xargs fvm dart format
	@echo "Format completed."