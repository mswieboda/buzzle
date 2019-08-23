default: build_run

builds_mkdir:
	if [ ! -d "./builds" ]; then mkdir "builds"; fi

build: builds_mkdir
	env LIBRARY_PATH="$(PWD)/lib_ext" crystal build src/buzzle.cr -o builds/buzzle

build_release: builds_mkdir
	env LIBRARY_PATH="$(PWD)/lib_ext" crystal build --release --no-debug src/buzzle.cr -o builds/buzzle_release

build_run: build run

build_release_run: build_release run_release

run:
	env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/buzzle

run_release:
	env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/buzzle_release
