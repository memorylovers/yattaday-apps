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

format:
	melos run format --no-select

lint:
	melos run lint --no-select

lint-md:
	npx markdownlint-cli2 "**/*.md" "#**/.dart_tool" "#**/.fvm" "#**/ios"

test:
	melos run test --no-select

cc:
	npx ccusage@latest
