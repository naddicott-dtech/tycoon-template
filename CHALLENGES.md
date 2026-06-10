# CHALLENGES.md — level up your coding

You can build a whole game **without** any of this (see `README.md`). These are
for when you want to *change how the game works*, not just its numbers. They get
harder as you go. Each one has a known answer — ask your AI helper or your teacher
to check yours.

> Tip: after a code change, press **Play**. Godot 4.5 prints errors loudly in the
> Output panel at the bottom — read them; they usually tell you the line.
> One more: GDScript indents with **Tab**. If a pasted block complains about
> "space character for indentation", retype its indentation with the Tab key.

---

## Rung 1 — Change one number (no code)
**Goal:** make the game easier to win.
Open `Level1.tscn`, click the **`Level1` root**, set **Goal Money** to `200`. Play
and confirm you win sooner. (Now make it *harder*.)
*Touches: the goal knob, which lives on the level. Warm-up — just the Inspector.*

## Rung 2 — Use the dropdown (no code)
**Goal:** put a fancier stand in your shop.
Click a `Stand`, change **Tier** to `LEVEL_3`. Play: its picture and its income
both change. *That one dropdown controls both — that's "the bridge."*

## Rung 3 — Add to the bridge (your first code)
**Goal:** add a **LEVEL_4** stand that earns even more.
In `scenes/entities/Stand.gd`:
1. add `LEVEL_4` to the `enum Tier { ... }`,
2. add one line to `_tier_multiplier()`: `Tier.LEVEL_4: return 15`,
3. add a `@export var level_4_texture: Texture2D` and a matching line in
   `_show_level_picture()`.

That's the whole pattern: **one enum value + one line per `match`.** Set a stand to
LEVEL_4 and play.
*Touches: `_tier_multiplier()`. This is the coder's side of the bridge. (The built-in
`upgrade()` will now climb to LEVEL_4 for free, because it just steps the tier up.)*

## Rung 4 — Upgrade one stand at a time (read + change code)
**Goal:** the **Upgrade** button currently levels up **every** stand for one flat
price. Make it upgrade just **one** stand per click instead (cheaper, more tactical).
In `autoload/Shop.gd`, look at `upgrade_all()`. It loops over every stand:
```gdscript
for stand in get_tree().get_nodes_in_group("stand"):
    stand.upgrade()
```
Change it to upgrade only the **first** stand that isn't maxed out yet (loop, call
`upgrade()` on the first one below `Tier.LEVEL_3`, then `break`). Rename the function
and the button text to match.
*Touches: `Shop.upgrade_all()`. You're reading working code and bending it — the most
common real coding task.*

## Rung 5 — Give each stand its OWN rent (code, balance)
**Goal:** right now **Upkeep Per Stand** (on the `Level1` root) charges the *same*
rent for every stand. Make a fancy stand cost more to run than a cheap one.
1. In `Stand.gd` add `@export var upkeep: int = 0`.
2. In `Shop.gd`, change `_on_day_ended()` so instead of `rate × count` it adds up
   each stand's own `upkeep`:
   ```gdscript
   var bill := 0
   for stand in get_tree().get_nodes_in_group("stand"):
       bill += stand.upkeep
   ```
Now a weak stand can *lose* you money. Re-balance your shop.
*Touches: the daily money flow. This is what turns "buy everything" into a real
decision.*

## Rung 6 — Make expanding get pricier (code, balance)
**Goal:** buying your 5th stand should cost more than your 1st.
In `Shop.gd`'s `buy_stand()`, the price is just `level.buy_cost`. Make it climb with
how many stands you already own — e.g. `var price := level.buy_cost * (1 + stand_count)`
where `stand_count` is `get_tree().get_nodes_in_group("stand").size()`. Charge
`price`, and only buy `if Globals.money >= price`.
*Touches: `Shop.buy_stand()`. A classic tycoon curve — cheap to start, costly to
sprawl.*

## Rung 7 — A new way to lose (code)
**Goal:** go bankrupt and lose immediately.
In `scenes/managers/GoalManager.gd`, add one line at the top of `evaluate()`:
```gdscript
	if money < 0:
		return Result.LOST
```
Now spending (or rent) past zero ends the game.
*Touches: `evaluate()` — the pure win/lose rule, the easiest thing to grade
automatically.*

## Rung 8 — Grey out what you can't afford (code, UI polish)
**Goal:** the **Buy** and **Upgrade** buttons should *look* dead when you're short
on money, instead of silently doing nothing.
Buttons have a built-in `disabled` property. The HUD already hears every money
change — in `scenes/ui/HUD.gd`, add to the end of `_on_money_changed()`:
```gdscript
	var level = get_tree().get_first_node_in_group("current_level")
	if level:
		%BuyButton.disabled = new_money < level.buy_cost
		%UpgradeButton.disabled = new_money < level.upgrade_cost
```
*Touches: `HUD._on_money_changed()`. Five lines: drive the UI from a signal you
already have. A big quality-of-life win for your players.*

## Rung 9 — Choose what Buy builds (code + a new knob)
**Goal:** Buy normally copies your **top** stand. Give the *level* a knob that
says exactly which stand scene to build instead.
1. In `scenes/levels/Level.gd` add: `@export var stand_to_buy: PackedScene`
2. In `autoload/Shop.gd`'s `_make_stand()`, add at the very top:
```gdscript
	var level = _current_level()
	if level != null and level.stand_to_buy != null:
		return level.stand_to_buy.instantiate()
```
3. Make a scene to sell: select your themed `Stand` in the tree, right-click →
   **Save Branch as Scene**. Then click the `Level1` root and drag your new
   scene into the **Stand To Buy** slot.
Leave the slot empty and Buy behaves like before. Now each level can sell its
own kind of stand.
*Touches: `Shop._make_stand()` — you're putting your own rule in front of a
built-in one. The empty-slot fallback is what keeps it safe.*

## Rung 10 — Keep playing after you win (code + editor)
**Goal:** after a win, let the player wave off the Game-Over screen and keep
running their shop, sandbox-style.
1. In `Main.tscn`, add a **Button** under `UI/GameOverScreen` next to
   `PlayAgainButton`. Name it `KeepPlayingButton`, set its text, and right-click
   it → **% Access as Unique Name**.
2. In `scenes/ui/GameOverScreen.gd`'s `_ready()`, wire it up:
   `%KeepPlayingButton.pressed.connect(_on_keep_playing)`
3. Add the handler — three lines:
   ```gdscript
   func _on_keep_playing() -> void:
   	get_tree().paused = false
   	visible = false
   ```
No reset, no reload — the game just continues where it ended.
Heads-up: your button shows after a **loss** too — fine for a sandbox. Want it
win-only? Save `did_win` into a variable in `_on_game_over` and hide the button
when it's false. That's the stretch version.
*Touches: the pause pattern. Your new button works while everything else is
frozen ONLY because the screen's **Process > Mode** is `Always` — read the
comment at the top of `GameOverScreen.gd` before you start.*

---

## Going further (open-ended — no single right answer)
- **Tidy the layout.** New stands march off the right edge (`Shop._next_stand_position()`
  just adds to the X). Wrap them into rows, or lay them on a grid.
- **Drag a stand to place it.** Let the player reposition a stand by dragging it
  (give `Stand.gd` a `_gui_input` / drag handler). Bigger job — real input handling.
- **A second level.** Make a `Level2.tscn` (copy `Level1`), give it harder numbers
  and a food-truck theme, and switch to it when Level 1 is won.

---

### For teachers / graders
Most rungs map to a **pure function** so a solution can be auto-checked:
`_tier_multiplier()` (R3), `Shop._upkeep_total()` and the per-stand upkeep loop (R5),
`evaluate()` (R7). Buy/upgrade changes (R4, R6) touch the live scene tree, so they're
checked by a small integration test (build a level + stands, call the Shop function,
assert money/stand count) — see `ShopTest.gd` in the developer repo for the pattern.
Solutions stay as hidden GdUnit4 tests in the developer repo — never in the student
project.
