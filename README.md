# Tycoon Template

A small **tycoon game** you turn into your own. You own **stands** that sell
things and make money at the **end of each day**. Click **End Day** to earn, then
spend your money to **Buy** more stands or **Upgrade** the ones you own — growing
your income while you race to **reach the goal amount of money by the deadline day
to win.** Miss it and you lose. (Stands can also charge daily **upkeep** — rent —
once you switch it on.)

It ships on purpose looking **plain and unfinished — and the numbers aren't just
unfair, they're mathematically impossible.** With the shipped starting money,
income, and prices, *no* strategy reaches the goal by the deadline. Don't take
our word for it: do the math (or play a run and watch the day-by-day money log
in the **Output panel** at the bottom) and prove
it. Then make it look good, name things, and re-balance it so it's *fun-hard*
instead of impossible — **that's your job.** The machine already works; you make
it a game.

> **You can read every file in here.** Nothing is meant to be magic. If a file
> confuses you, that's a bug in our comments — say so.

---

## Your Mission

1. **Give it a theme.** Right now a stand sells "Consumable Placeholder" — it
   says so right on the stand. Rename your items and your stands to whatever
   your shop sells.
2. **Replace the placeholder art** (the gray boxes in `assets/`) with real
   pictures.
3. **Build your shop.** Add stands and set each one's level and income.
4. **Balance it.** Tune the starting money, the goal, the deadline, and your
   **shop prices** (how much it costs to buy a stand, to upgrade, and the daily
   upkeep) so a player has to think — not too easy, not impossible.
5. **Write the mission text** the player sees when the game starts.

---

## How you build: duplicate + tune (no code needed)

Almost everything happens in the **editor**, by **duplicating** things and
**changing values in the Inspector** (the panel on the right). Any variable
written with `@export` in a script shows up there as a box you can change.

**Your level is `scenes/levels/Level1.tscn`** — open it; that's your canvas.
(`Main.tscn` is the engine around it — the managers and UI you don't need to
touch.) **The duplicatable block is the `Stand`.** To add another money-maker:
1. In `Level1.tscn`, click the `Stand` under `Entities`.
2. Press **Ctrl+D** to copy it. Drag the copy somewhere else.
3. With the copy selected, change its values in the Inspector (below).

Each stand wires itself up on its own — you never connect anything.

**The Buy button does the same thing while the game runs:** it makes a copy of
the **top stand** in your level — Ctrl+D at game time. So theme and tune your
stand, and every stand you buy matches it. Two details worth knowing:
- A bought stand copies the original's **current level** too. Upgrade early,
  and every later buy is born upgraded. Is that fair? Your call, balance designer.
- Want Buy to build a *different* stand? Drag that stand to the **top** of
  `Entities` — the top one is always the model that gets copied.

> **Two editor gotchas that look like bugs (they aren't):**
> - A number box doesn't always select its text when you click it. If your
>   typing seems ignored: click the box, type the number, press **Enter**, then
>   look again to make sure it took.
> - **Ctrl/Cmd+A** pressed outside a text field opens the **Add Node** dialog.
>   If a mystery node shows up in your scene, that's how it got there —
>   Ctrl/Cmd+Z and carry on.

---

## Where every knob lives

We keep each setting **on the thing it belongs to**, so you change it right where
it makes sense. Click the node, look at the Inspector.

| You want to change... | Click this | Setting |
|---|---|---|
| What a stand sells (shows on its name tag) | a `Stand` | **Item Name** |
| How good a stand is (picture + income) | a `Stand` | **Tier** (Level 1/2/3) |
| How much a stand earns | a `Stand` | **Base Income** |
| A stand's pictures | a `Stand` | **Level 1/2/3 Texture** |
| The money you start with | `config/game_config.tres` | **Starting Money** |
| The goal and the deadline | the `Level1` root (in `Level1.tscn`) | **Goal Money**, **Deadline Day** |
| The price to **buy** another stand | the `Level1` root | **Buy Cost** |
| The price to **upgrade** all stands at once | the `Level1` root | **Upgrade Cost** |
| Daily **upkeep** per stand (`0` = off) | the `Level1` root | **Upkeep Per Stand** |
| How a day passes (button vs timer) | `Managers/TimeManager` | **Time Mode**, **Seconds Per Day** |
| The mission / message text | `UI/Message` | **Messages** |
| The end-of-game text | `UI/GameOverScreen` | **Win Message**, **Lose Message** |
| Show or hide the cheat button | the `HUD` root | **Show Debug Buttons** |
| How much the cheat button adds | the `HUD` root | **Debug Add Amount** |

> Only the **Starting Money / Start Day** live in the `game_config.tres` file,
> because they belong to `Globals` (an always-on script with no node to click).
> Everything else lives on a node. (Why this split? See `GameConfig.gd`.)

**One thing to keep in sync yourself:** the mission text ("reach $500 by day 10")
is just words you type into the `Message` node. If you change the **Goal Money**
on the `Level1` root, update that text too so it still tells the truth.

> **Why are the prices on the `Level1` root?** Because they belong to *this level*.
> When you make a second, harder level later, its food truck can charge more rent
> and cost more to expand than the front lawn did — each level carries its own
> numbers. (The Shop just *reads* whichever level is loaded; see `Shop.gd`.)

---

## The jobs (pick one, or do them all)

This template is built so a team can split the work:

- **Artist** — replace the placeholder pictures in `assets/`, and restyle the
  HUD and message box (fonts, colors, a Theme). All drag-and-drop, no code.
- **Balance / Tuning designer** — set the incomes, the goal, the deadline, the
  starting money. Play, and read how it went: every day prints a `playlog` line
  in the **Output panel**, and the same rows are saved as `playlog.csv`, a
  spreadsheet of money per day. (On a desktop computer the file is in Godot's
  user-data folder: **Project > Open User Data Folder**. In the web editor,
  stick to the Output panel.)
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
│  ├─ Shop.gd             the ONE place money is spent: buy / upgrade / upkeep
│  ├─ SaveManager.gd      save / load
│  └─ AudioManager.gd     play sounds
├─ config/
│  └─ game_config.tres    starting money / first day  (shape from GameConfig.gd)
├─ assets/                placeholder pictures — REPLACE THESE
├─ scenes/
│  ├─ Main.tscn / .gd     the engine: the level holder + managers + UI
│  ├─ levels/
│  │  └─ Level1.tscn      YOUR LEVEL — your stands live here; its root holds the
│  │                      level's goal (Level.gd)
│  ├─ entities/
│  │  └─ Stand.tscn/.gd   a money-making stand — DUPLICATE THIS into your level
│  ├─ managers/
│  │  ├─ TimeManager.gd    the day clock (manual button or real-time)
│  │  ├─ GoalManager.gd    decides win / lose
│  │  └─ PlayLogger.gd     writes playlog.csv each day
│  └─ ui/
│     ├─ HUD.gd            money & day display + End Day / Buy / Upgrade buttons
│     ├─ MessageCanvas.gd  shows the mission text at the start
│     └─ GameOverScreen.gd the end screen: win/lose text, pauses the game, Play Again
└─ project.godot
```

`Main.tscn` is the **engine**: `WorldRoot` holds your current level
(`WorldRoot/Level1`), `Managers` runs the systems, and `UI` is what's on screen.
You build inside **`Level1.tscn`**; `Main` is just the frame around it.

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
5. **`autoload/Shop.gd`** — spending money: buy a stand, upgrade them all, charge
   upkeep. Notice it holds no prices itself — it reads them off the current level.
6. **`autoload/Globals.gd`** and the rest of the managers.

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
- [ ] **Buy** and **Upgrade** both work, and the prices feel fair (not free, not
      hopeless). If you turned on **upkeep**, the game is still winnable.
- [ ] You can actually **reach the goal** — but it takes some thought (not free,
      not impossible).
- [ ] Lose on purpose once: the **Game-Over screen** covers the game, the buttons
      under it stop working, and **Play Again** starts a fresh run (day 1,
      starting money).
- [ ] You **replaced the placeholder pictures** (no more gray boxes / Godot logo).
- [ ] You **renamed** "Consumable Placeholder" and gave your stands real names.
- [ ] The **mission text matches** your real goal and deadline.
- [ ] You turned **Show Debug Buttons off** on the HUD for the final version.
- [ ] You saved with **Project > Tools > Download Project Source** (the web editor
      forgets your work otherwise — do this often!). *That menu item only exists
      in the web editor; on a desktop install your project saves to disk normally.*
