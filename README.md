## Installation

Requires Crystal to be installed

```
$ brew install crystal
```

Install crystal shard dependencies ([cray](https://github.com/tapgg/cray))

```
$ shards install
```

Run the Makefile to build a release and run via Crystal (builds to `./builds`)

```
$ make
```

If developing/testing, quickly compile a non-release build using

(takes around 4 sec vs 12 sec as of 9/17/2019)

```
$ make test
```

The Makefile will check if there are any unstaged changes, and if so clean and rebuild

## Screenshot Example

<img src="https://user-images.githubusercontent.com/2223822/64809064-1bb50100-d55e-11e9-80b4-912859f9407d.png" width="250">


## Asset Credits

TODO: attribution, licenses, etc. the correct way

For now, listing here:

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
