# Minecraft written in Swift

Somewhat inspired by [minecraft-weekend](https://github.com/jdah/minecraft-weekend) 
and was originally an attempt at porting the project to Swift, however I decided to start from scratch.

> Currently There's a triangle rendered using OpenGL and some setup for a usable, generic renderer implementation.

### Why?

The idea for this project is to test how well a protocol based Swift approach can work in a game,
as well as eventually use a distributed actor system to implement multiplayer.

Because the official macOS implementation of Swift is always dynamically linking the standard library
this means it will only work on macOS 13 and newer, however this is not an issue on
other operating systems where the library can be linked statically 🙂

### Tasks

- [x] Set up SDL
- [x] Set up OpenGL
- [ ] Abstract OpenGL
- [ ] Abstract SDL
- [ ] Design the renderer
- [ ] Blocks
- [ ] Terrain
- [ ] Entities
- [ ] Items
- [ ] More tasks
