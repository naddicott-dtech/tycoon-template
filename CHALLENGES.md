# CHALLENGES.md — level up your coding

You can build a whole game **without** any of this (see `README.md`). These are
for when you want to *change how the game works*, not just its numbers. They get
harder as you go. Each one has a known answer — ask your AI helper or your teacher
to check yours.

> Tip: after a code change, press **Play**. Godot 4.5 prints errors loudly in the
> Output panel at the bottom — read them; they usually tell you the line.

---

## Rung 1 — Change one number (no code)
**Goal:** make the game easier to win.
Click `Managers/GoalManager`, set **Goal Money** to `200`. Play and confirm you
win sooner. (Now make it *harder*.)
*Touches: the goal knob. Warm-up — just the Inspector.*

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
*Touches: `_tier_multiplier()`. This is the coder's side of the bridge.*

## Rung 4 — A new behavior: upgrade a stand (code)
**Goal:** let a stand level up *during play* instead of being fixed.
Add this to `Stand.gd`:
```gdscript
func upgrade() -> void:
	if tier < Tier.LEVEL_3:
		tier += 1            # enums are really numbers underneath
		_show_level_picture()
```
Then make it happen. The easiest trigger is a **button**, exactly like the End Day
button you already have: add an "Upgrade" button and, in code, call the stand's
`upgrade()`. (Bonus: charge money for it — only upgrade `if Globals.money >= 50`,
then `Globals.add_money(-50)`.)
*Touches: a new method + `_show_level_picture()`. Note: leveling up is NOT a scene
change — it's the same stand, you just flip its tier.*

## Rung 5 — Costs money to run (code, balance)
**Goal:** stands shouldn't earn free money — give them an upkeep cost.
In `Stand.gd` add `@export var upkeep: int = 2`, then change `_on_day_ended` to:
```gdscript
func _on_day_ended(_day_number: int) -> void:
	Globals.add_money(income_for_day() - upkeep)
```
Now a weak stand can *lose* you money. Re-balance your shop.
*Touches: the daily money flow. This is what makes a tycoon a real decision.*

## Rung 6 — A new way to lose (code)
**Goal:** go bankrupt and lose immediately.
In `scenes/managers/GoalManager.gd`, add one line at the top of `evaluate()`:
```gdscript
	if money < 0:
		return Result.LOST
```
Now spending past zero ends the game.
*Touches: `evaluate()` — the pure win/lose rule, the easiest thing to grade
automatically.*

---

### For teachers / graders
Every rung maps to a **pure function** so a solution can be auto-checked:
`_tier_multiplier()` (R3), `upgrade()` (R4), the daily flow in `_on_day_ended` /
`income_for_day()` (R5), `evaluate()` (R6). Solutions can be encoded as hidden
GdUnit4 tests against these seams, kept in the developer repo — never in the
student project.
