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

gen:
	melos run gen

flutterfire_cli:
	fvm dart pub global activate flutterfire_cli

format:
	melos run format

lint:
	melos run lint

test:
	melos run test

cc:
	npx ccusage@latest