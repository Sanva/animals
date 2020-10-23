Animals
-------

This is a frankenstein demo app where I'm mixing what I'm learning
about 2D and 3D graphics programming using Haxe and Kha.

The ultimate goal could be to create a basic 2D oriented 3D game engine,
to explore 2D and 3D graphics programming with an incredible
multiplatform support.

At the time of writing this, the app is kind of a game,
but with no purpose, only very basic graphical
objects moving around. You can test it online at
https://lab.sanva.now.sh/animals.html (~3 MB) . There is also
an Android APK at the bottom — please, take into account
that both the APK link and the HMTL version could be
more up to date than this code. Also, this is only a
proof of concept of Haxe & Kha multiplatform capabilities,
I have no clear plans about continuing this thing.

**Beware**, this is quick and dirty, I'm learning really disparate
stuff and I'm not caring about architecture or design patterns,
everything is evolving in a very naive way — I'm more concerned about
learning and advancing quickly than in creating some useful software. But
that's about general programming, if you happen to know
Kha / 2D graphics / 3D graphics and you see
some wrong thing, please tell me ;) .

Features
--------

You control a cat with an on screen joystick or with
`↑` `→` `↓` `←` keys, moving in an infinite pink plane. If you
press the virtual button `A` or space key,
you change to a dog which is followed by
another one if it moves.

The sprite animation of the animals is done using Kha2D,
some kind of a demo 2D game engine.

You have an options menu, accesible pressing a button
in the upper right corner of the screen, where
you can activate various objects and configure
basic attributes, like color and position, or
enable/disable behaviors like playing sounds
or animations.

Options above *Audio*, and also the animals you
can control and the gamepad with the joystick
and virtual button are drawn using a 2D API,
something like Cairo or the HTML5 Canvas.

Options below *Audio* are drawn using a
3D API that is just like OpenGL, with
vertex and fragment shaders using GLSL.

The menu is created using Zui, and I'm also
using some data structures and math functions
from Iron, a 3D game engine core.

Options:

- *Rotating rectangle* and *Concentric circles*
  are super basic objects with
  some configurable attributes.

- With *Balls* you can add a lot
  of balls that bounce around
  the screen. They are not in
  world space with the rest of
  the objects, so strange moving
  effects are expected if you
  move the screen/camera. The balls
  emit a sound and particles when
  hitting the screen borders.

  If you add *many* balls (50~100 depending
  of target) the app may crash. I think that's
  because I'm acting negligently with
  the audio channels and the particle
  system. Those sounds would
  be also very annoying, by the way.

- *Grid* is a shame.

- *Audio* allows you to play
  a song, controlling it's volume.

- *Shader Block* is a plane in 3D space,
  or a rectangle in 2D. It has it's
  own basic fragment shader that
  changes its color depending of
  mouse / last touch position.

- *Sprite*, *Textured Sprite*,
  *Tilesheet Sprite* and *Cube*
  support transparency and
  textures with UVs, and they are drawn
  sharing the same pipeline, buffers
  and shaders, and can be moved around
  with the virtual joystick like the main
  characters.

  *Tilesheet Sprite* features a very basic
  animation system — not using Kha2D, unlike
  the main characters.

You can also activate a very basic particles
system pressing with the middle
mouse button / touching the
screen with 3 fingers.

Known issues
------------

- Performance is bad. Not because
  of Haxe or Kha, just because this is
  very *quick and dirty* and I make
  so many unnecesary function calls,
  object allocations and even
  simple repeated calculations.

- I'm not sure I'm using Kha time
  system right — I'm not even sure
  about my FPS calculation...

- There is no collision system — animals
  are really ghosts.

- Follower dog doesn't know how
  to move diagonally yet.

- The joystick control is terrible.

- App crashes with *many* balls,
  probably because I'm naively abusing
  the audio system. The sounds are
  also very annoying when playing some
  of them at the same time.

- The grid is a shame in every way.

- No link to YouTube video of playable
  audio in platforms other than
  HTML5.

- Window resize and screen rotation
  are badly supported.

- Mesh baching is really incomplete.

- Context menu scrolling doesn't work
  in Android.

- There is no documentation.

- Sorry, no instructions for compilation — but
  should be fairly easy if you know Kha.

Downloads
---------

- Android (arm64-v8a debug, ~25 MB): https://lab.sanva.now.sh/animals-debug.apk

Some references
---------------

- Lubos Lenco Kha 3D examples: https://github.com/luboslenco/kha3d_examples/wiki
- opengl-tutorial: http://www.opengl-tutorial.org/
- Lewis Lepton Kha tutorial series: https://www.youtube.com/playlist?list=PL4neAtv21WOmmR5mKb7TQvEQHpMh1h0po
- GamesWithGave: https://www.youtube.com/c/GamesWithGabe/playlists

See also
--------

- Haxe: https://haxe.org/
- Kha: http://kha.tech/
- Zui: https://github.com/armory3d/zui
- Iron: https://github.com/armory3d/iron
- Armory: https://armory3d.org/
- Blender: https://www.blender.org/

Assets
------

- Animals pixel art: http://finalbossblues.com/timefantasy/freebies/cats-and-dogs/
- Ball hit sound: https://freesound.org/people/OwlStorm/sounds/209018/
- Background sound: https://www.youtube.com/watch?v=ccYpgiylfQI
- Font: https://fonts.google.com/specimen/Russo+One?query=russo

