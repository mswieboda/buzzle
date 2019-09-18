.PHONY: default clean clean_if_diff test release

clean = env echo "cleaning builds..." && rm -r builds

default: release

builds:
	@if [ ! -d "./builds" ]; then mkdir "builds"; fi

clean:
	@$(call clean)

clean_if_diff:
	@[[ -z `git status -s -uall` ]] || $(call clean)

builds/buzzle_test: builds
	@echo "compiling test build..."
	@env LIBRARY_PATH="$(PWD)/lib_ext" crystal build src/buzzle.cr -o builds/buzzle_test

test: clean_if_diff builds/buzzle_test
	@env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/buzzle_test

builds/buzzle: builds
	@echo "compiling release build..."
	@env LIBRARY_PATH="$(PWD)/lib_ext" crystal build --release --no-debug src/buzzle.cr -o builds/buzzle

release: clean_if_diff builds/buzzle
	@env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/buzzle
