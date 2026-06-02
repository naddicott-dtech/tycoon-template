# Template for Templates

This is the **shared starting skeleton** that every game template in this
project is built on top of. It is intentionally small. It does *not* contain a
playable game — instead it gives you the common plumbing that almost every game
needs (money/score, a day-and-time clock, saving, an on-screen display, and a
clean way for parts of the game to talk to each other).

The goal is that **you can open these files, read them, and understand them.**
Nothing here is meant to be magic. If a file feels confusing, that's a bug in
the comments — tell us.

---

## How you're meant to build with this

Most of what you do is in the **editor**, not in code:

- **Drag and drop** nodes and scenes to build your world.
- **Tune values in the Inspector** (the panel on the right). Any variable marked
  with `@export` in a script shows up there as a box you can change — no typing
  code required. Look for these; they are the "knobs" the templates give you.
- Write code only when you want *new behavior* the knobs can't express.

---

## Start here: read the files in this order

You'll understand the whole thing fastest if you read them in this order. Each
file is short and commented.

1. **`autoload/Globals.gd`** — where game-wide facts live (money, day). Shows
   what `@export` and an "autoload" are.
2. **`autoload/SignalBus.gd`** — the "bulletin board." This is the key idea that
   makes everything else click: how parts of the game talk without being glued
   together.
3. **`scenes/ui/HUD.gd`** — watch the bulletin board in action: the HUD listens
   for announcements and updates the money/day text on screen.
4. **`scenes/managers/TimeManager.gd`** — the game clock; a tidy example of doing
   something a little each frame.
5. **`scenes/managers/SaveManager.gd`** — saving and loading. The most advanced
   file. You mostly just *call* it; you rarely edit it.
6. **`scenes/Main.gd` / `scenes/Main.tscn`** — the scene the game starts on, where
   each template adds its own content.

---

## The big ideas (your vocabulary for this project)

- **Autoload** — a script Godot keeps alive for the whole game, reachable from
  anywhere by name (e.g. `Globals.money`, `SignalBus.tick`). Great for things
  there's only one of.
- **Signal** — an announcement. One script `emit`s it; other scripts `connect`
  to it and react. See `SignalBus.gd`.
- **`@export`** — exposes a variable to the Inspector so it can be changed by
  clicking instead of coding.
- **Group** — a label you can stick on any node (in the editor's Node panel).
  Code can then find every node with that label at once. The save system uses
  the `savable` group this way.
- **Manager** — a node whose only job is to run one system (time, saving, audio).
  They live under `Managers` in `Main.tscn`.

---

## What's in the box

```
template-for-templates/
├─ autoload/
│  ├─ Globals.gd        # game-wide values: money, day, settings
│  └─ SignalBus.gd      # the bulletin board of signals
├─ scenes/
│  ├─ Main.tscn / .gd   # the starting scene + world layout
│  ├─ ui/
│  │  └─ HUD.tscn / .gd # on-screen money & day display + debug button
│  └─ managers/
│     ├─ TimeManager.gd   # advances the day, ticks every frame
│     ├─ SaveManager.gd   # save/load to a file
│     └─ AudioManager.tscn # (placeholder — sound goes here later)
└─ project.godot        # Godot project settings (autoloads are registered here)
```

The `Main.tscn` world is pre-organized into spots for your content:
`WorldRoot` holds a `TileMapLayer` (your level), an `Entities` node (players,
enemies, items), and `Spawners`. Put your stuff in those.

---

## Quick how-tos

**Change money:** never set `Globals.money` directly. Call
`Globals.add_money(50)` (or a negative number to spend). Going through that one
function fires the `money_changed` signal so the HUD updates itself.

**Listen for something:** in `_ready()`, write
`SignalBus.day_ended.connect(_on_day_ended)`, then add a function
`_on_day_ended(day_number):` that does what you want. Copy the pattern from
`HUD.gd`.

**Save and load:** call `SaveManager.save_game()` and
`SaveManager.load_game()`. To make one of *your* nodes save its own data, add it
to the `savable` group and give it `get_snapshot()` and `apply_snapshot(data)`
functions — that's it. (Details are commented at the top of `SaveManager.gd`.)

**Turn off the cheat button:** select the `Globals` autoload's settings and
uncheck `show_debug_buttons` in the Inspector.
