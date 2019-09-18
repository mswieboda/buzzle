## Installation

Requires [Crystal](https://crystal-lang.org) to be installed

```
$ brew install crystal
```

Install crystal shard dependencies ([cray](https://gitlab.com/Zatherz/cray))

```
$ shards install
```

## Running

Run the Makefile to build a release and run

```
$ make
```

### Development/Testing

Compile a non-release build quicker using

```
$ make test
```

`make test` takes around 4 sec vs 12 sec for a release as of 9/17/2019.

The Makefile checks if there are any unstaged changes, and if so clean and rebuild, for both `make` and `make test`.

All builds are compiled to `./builds`, however, running it requires the RayLib external library (in `./lib_ext`) so using the `Makefile` is easiest for now.

Ultimately, I'd like the release to create a native system application wrapper like `.app` for OSX, `.exe` for Windows, etc. This would be doable, however the libraries crystal depends on still need to be installed for the target
machine, so installing `crystal` is easiest for now.

## Screenshot Example

<img src="https://user-images.githubusercontent.com/2223822/64809064-1bb50100-d55e-11e9-80b4-912859f9407d.png" width="250">


## Credits

Thanks to [Zatherz](https://gitlab.com/Zatherz) for creating the RayLib Crystal bindings ([cray](https://gitlab.com/Zatherz/cray))!

### Assets Attribution

TODO: attribution, licenses, etc. the correct way

For now, just listing here:

https://opengameart.org/content/a-blocky-dungeon
- resized to 32x32
- uses door, switch, walls, gate, chest
- modified door, switch, walls, gate, chest

https://opengameart.org/content/dungeon-tileset
- resized torch to 32x32
- modified torch

https://opengameart.org/content/fps-placeholder-sounds
- used footsteps (1-4) sounds
- used at different volumes and pitches
