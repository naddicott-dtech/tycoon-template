# Tycoon Template

A small **tycoon game** you turn into your own. You own **stands** that sell
things and make money at the **end of each day**. Click **End Day** to move
forward. **Reach the goal amount of money by the deadline day to win** — miss it
and you lose.

It ships on purpose looking **plain and unfinished, with unfair numbers**.
Making it look good, naming things, and balancing the money so it's *fun-hard*
instead of impossible — **that's your job.** The machine already works; you make
it a game.

> **You can read every file in here.** Nothing is meant to be magic. If a file
> confuses you, that's a bug in our comments — say so.

---

## Your Mission

1. **Give it a theme.** Right now a stand sells "Consumable Item A." Rename your
   items and your stands to whatever your shop sells.
2. **Replace the placeholder art** (the gray boxes in `assets/`) with real
   pictures.
3. **Build your shop.** Add stands and set each one's level and income.
4. **Balance it.** Tune the starting money, the goal, and the deadline so a
   player has to think — not too easy, not impossible.
5. **Write the mission text** the player sees when the game starts.

---

## How you build: duplicate + tune (no code needed)

Almost everything happens in the **editor**, by **duplicating** things and
**changing values in the Inspector** (the panel on the right). Any variable
written with `@export` in a script shows up there as a box you can change.

**The duplicatable block is the `Stand`.** To add another money-maker:
1. In `scenes/Main.tscn`, click the `Stand` under `WorldRoot/Entities`.
2. Press **Ctrl+D** to copy it. Drag the copy somewhere else.
3. With the copy selected, change its values in the Inspector (below).

Each stand wires itself up on its own — you never connect anything.

---

## Where every knob lives

We keep each setting **on the thing it belongs to**, so you change it right where
it makes sense. Click the node, look at the Inspector.

| You want to change... | Click this | Setting |
|---|---|---|
| What a stand sells | a `Stand` | **Item Name** |
| How good a stand is (picture + income) | a `Stand` | **Tier** (Level 1/2/3) |
| How much a stand earns | a `Stand` | **Base Income** |
| A stand's pictures | a `Stand` | **Level 1/2/3 Texture** |
| The money you start with | `config/game_config.tres` | **Starting Money** |
| The goal and the deadline | `Managers/GoalManager` | **Goal Money**, **Deadline Day** |
| How a day passes (button vs timer) | `Managers/TimeManager` | **Time Mode**, **Seconds Per Day** |
| The mission / message text | `UI/Message` | **Messages**, **Win/Lose Message** |
| Show or hide the cheat button | the `HUD` root | **Show Debug Buttons** |

> Only the **Starting Money / Start Day** live in the `game_config.tres` file,
> because they belong to `Globals` (an always-on script with no node to click).
> Everything else lives on a node. (Why this split? See `GameConfig.gd`.)

**One thing to keep in sync yourself:** the mission text ("reach $500 by day 10")
is just words you type into the `Message` node. If you change the **Goal Money**
on the GoalManager, update that text too so it still tells the truth.

---

## The jobs (pick one, or do them all)

This template is built so a team can split the work:

- **Artist** — replace the placeholder pictures in `assets/`, and restyle the
  HUD and message box (fonts, colors, a Theme). All drag-and-drop, no code.
- **Balance / Tuning designer** — set the incomes, the goal, the deadline, the
  starting money. Play, and read `playlog.csv` (a spreadsheet of money per day)
  to see how it went.
- **Level / Content designer** — add and arrange stands; decide what the shop is.
- **Writer (light)** — the mission and message text. (For a real branching story,
  that's a different template.)

---

## What's in the box

```
tycoon-template/
├─ autoload/             always-on systems, reachable anywhere by name
│  ├─ Globals.gd          money, day, add_money(), end_day()
│  ├─ SignalBus.gd        the "bulletin board" of signals
│  ├─ SaveManager.gd      save / load
│  └─ AudioManager.gd     play sounds
├─ config/
│  └─ game_config.tres    starting money / first day  (shape from GameConfig.gd)
├─ assets/                placeholder pictures — REPLACE THESE
├─ scenes/
│  ├─ Main.tscn / .gd     the game itself
│  ├─ entities/
│  │  └─ Stand.tscn/.gd   a money-making stand — DUPLICATE THIS
│  ├─ managers/
│  │  ├─ TimeManager.gd    the day clock (manual button or real-time)
│  │  ├─ GoalManager.gd    decides win / lose
│  │  └─ PlayLogger.gd     writes playlog.csv each day
│  └─ ui/
│     ├─ HUD.gd            money & day display + End Day button
│     └─ MessageCanvas.gd  shows the mission / win / lose text
└─ project.godot
```

`Main.tscn` is split into clear parts: `WorldRoot` (your stands and level),
`Managers` (the systems running the game), and `UI` (what's on screen).

---

## Want to read the code? Start here

You do **not** need to code to build a game with this. But if you want to, read
the files in this order — each is short and commented:

1. **`autoload/SignalBus.gd`** — the bulletin board. The one idea that makes the
   rest click: parts of the game talk by *announcing* things, not by reaching
   into each other.
2. **`scenes/entities/Stand.gd`** — the clearest example: a stand listens for
   "day ended," earns money, and shows the picture for its level.
3. **`scenes/ui/HUD.gd`** — listening to the bulletin board and updating the screen.
4. **`scenes/managers/GoalManager.gd`** — the win/lose rule, in one tidy function.
5. **`autoload/Globals.gd`** and the rest of the managers.

Then try the **`CHALLENGES.md`** ladder — small coding tasks that get harder.

### Words you'll see
- **Autoload** — a script Godot keeps alive the whole game, reachable by name
  (`Globals.money`). Good for things there's only one of.
- **Signal** — an announcement. One script `emit`s it; others `connect` and
  react. See `SignalBus.gd`.
- **`@export`** — makes a variable show up in the Inspector so you change it by
  clicking.
- **Manager** — a node whose only job is to run one system (the clock, the goal).
- **The bridge** — a dropdown like `Tier` that a designer picks *and* a coder can
  add to. One dropdown, two doors.

---

## Before you share your game (playtest checklist)

- [ ] It runs with **no red errors** in the Output panel.
- [ ] You can actually **reach the goal** — but it takes some thought (not free,
      not impossible).
- [ ] You **replaced the placeholder pictures** (no more gray boxes / Godot logo).
- [ ] You **renamed** "Consumable Item A" and gave your stands real names.
- [ ] The **mission text matches** your real goal and deadline.
- [ ] You turned **Show Debug Buttons off** on the HUD for the final version.
- [ ] You saved with **Project > Tools > Download Project Source** (the web editor
      forgets your work otherwise — do this often!).
