# Installation

Requires [Crystal](https://crystal-lang.org) to be installed

```
$ brew install crystal
```

Install crystal shard dependencies ([cray](https://gitlab.com/Zatherz/cray))

```
$ shards install
```

# Running

Run the Makefile to build a release and run

```
$ make
```

## Screenshot Example

<img src="https://user-images.githubusercontent.com/2223822/64809064-1bb50100-d55e-11e9-80b4-912859f9407d.png" width="250">

## Development/Testing

Compile a non-release build quicker using

```
$ make test
```

`make test` takes around 4 sec vs 12 sec for a release as of 9/17/2019.

All builds are compiled to `./builds`.

### Distribution Notes

Running a build requires referencing the RayLib external library (in `./lib_ext`) so using the `Makefile` is easiest. This could be wrapped in a script, that a native wrapper application can call.

Ultimately, I'd like the release to create a distribution of a native system application wrapper like `.app` for OSX, `.exe` for Windows, etc. This is doable, but since crystal static compiling is only currently available on Alpine Linux, all libraries crystal depends on still need to be installed for the target. See [Static Linking](https://github.com/crystal-lang/crystal/wiki/Static-Linking) Crystal wiki. I could possibly figure out the libraries needed and supply them, or install Crystal as a setup/installing part of the distribution.

### Cross-Platform

If anyone reading this knows how to use Crystal (with or without RayLib) to develop for native platforms like Nintendo Switch, Xbox, PlayStation, etc, or Roms for older platforms (GBA, GBC, NES, SNES, etc), please let me know, I'd be very interested on how I could compile Crystal to be executed on a platform other than a Linux/MacOS/Windows. I very much doubt it's possible right now, or really ever in the future, but hey, I can dream! Developing prototype games in Crystal/RayLib has been far more enjoyable for me than the game engine bohemoths like Unity, Godot, UnrealEngine, etc. I also just really prefer the syntax of Crystal/Ruby to everything else. I'm guessing custom compilers would need to be written, similar to jruby, IronRuby, etc for Ruby? Maybe it would be more similar to a transpiler like Opal for Ruby to JavaScript, except it would be Crystal to C/C++? I'll probably post something on the [Crystal forum](https://forum.crystal-lang.org/) if I realize it's more than a pipe dream.

# Credits

Thanks to [Zatherz](https://gitlab.com/Zatherz) for creating the RayLib Crystal bindings ([cray](https://gitlab.com/Zatherz/cray))!

## Assets Attribution

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
