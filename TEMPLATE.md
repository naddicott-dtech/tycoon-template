# TEMPLATE.md — Tycoon Template manifest

Token-efficient context for an AI helper, a teacher, or a student quick-ref.
For the friendly walkthrough see `README.md`; for coding tasks see `CHALLENGES.md`.

## What it is
An idle/tycoon: **stands** earn money at the **end of each day**; the player
clicks **End Day**, and spends earnings via **Buy** / **Upgrade** buttons to grow
income (optional per-day **upkeep** pushes back). Reaching **goal money** by the
**deadline day** wins, else loses. Ships playable, ugly, and unbalanced on purpose.

## Core loop (who tells whom)
`End Day button → Globals.end_day() → SignalBus.day_ended →`
`  Shop charges upkeep (autoload, fires first): upkeep_per_stand × stand_count`
`  each Stand earns income_for_day() → Globals.add_money() → SignalBus.money_changed → HUD`
`then SignalBus.day_settled (fires after ALL day_ended handlers → money is FINAL; bought stands connect late, so final-total listeners must NOT ride day_ended) →`
`  GoalManager reads current level's goal → evaluate() → SignalBus.game_over → GameOverScreen`
`  (GameOverScreen shows the result + PAUSES the tree = input lockout; Play Again → Globals.reset() + scene reload)`
`  PlayLogger prints the day's row to the Output panel + appends it to user://playlog.csv`

## Invest loop (who tells whom)
`Buy button → Shop.buy_stand() → reads Level.buy_cost → spends → CLONES the top stand in the tree into Entities`
`  (duplicate() carries every @export — name, income, current tier; no stands → falls back to the Stand prefab)`
`Upgrade button → Shop.upgrade_all() → reads Level.upgrade_cost → spends → Stand.upgrade() on every "stand"`
`Shop holds NO numbers: reads them off the current_level; spends through Globals.add_money(-cost)`

## The duplicatable block
`scenes/entities/Stand.tscn` — copy with Ctrl+D inside the level
(`scenes/levels/Level1.tscn`), retune in the Inspector. Each instance self-wires
to `day_ended` in `_ready()`. No signal hookup needed.

## Tuning knobs (where each lives — see DECISIONS D-019)
| Knob | Node / file | Type | Does |
|---|---|---|---|
| item_name | Stand | String | what it sells — shown on the StandLabel name tag |
| tier | Stand | enum LEVEL_1/2/3 | picks income multiplier (×1/×3/×8) AND picture |
| base_income | Stand | int | money/day at LEVEL_1 |
| level_1/2/3_texture | Stand | Texture2D | picture per level |
| goal_money | Level1 root (Level.gd) | int | money to win THIS level |
| deadline_day | Level1 root (Level.gd) | int | win by end of this day |
| buy_cost | Level1 root (Level.gd) | int | price to buy one more stand |
| upgrade_cost | Level1 root (Level.gd) | int | price to upgrade ALL stands one tier |
| upkeep_per_stand | Level1 root (Level.gd) | int | per-day rent per stand (default 0 = off) |
| time_mode | Managers/TimeManager | enum MANUAL/REAL_TIME | button vs auto clock |
| seconds_per_day | Managers/TimeManager | float | day length in REAL_TIME |
| messages | UI/Message | String[] | mission / intro text |
| win_message / lose_message | UI/GameOverScreen | String | end-screen text |
| show_debug_buttons | HUD root | bool | show the +money cheat button |
| debug_add_amount | HUD root | int | how much the cheat button adds |
| starting_money / start_day | config/game_config.tres | int | new-game globals (Globals-owned) |

## Role seams
Artist (`assets/` + the HUD/Message look) · Balance/Tuning (the knobs above +
`playlog.csv`) · Level/Content (add/arrange stands) · Writer-light (Message +
end-screen text).

## File map
`autoload/` Globals · SignalBus · Shop · SaveManager · AudioManager
`config/` GameConfig.gd + game_config.tres
`assets/` stand_level_1/2/3.svg (placeholders)
`scenes/` Main (holds WorldRoot/Level1) · levels/Level1 (Level.gd: per-level goal) · entities/Stand · managers/{TimeManager,GoalManager,PlayLogger} · ui/{HUD,MessageCanvas,GameOverScreen}

## Pure logic seams (for tests / autograder / AI checks)
- `Stand.income_for_day()` → `base_income * _tier_multiplier()`
- `Stand.upgrade()` → tier +1, capped at LEVEL_3 (drives both income and picture)
- `Shop._upkeep_total(rate, count)` → `rate * count` (the gradeable upkeep seam)
- `GoalManager.evaluate(money, day, goal, deadline)` → PLAYING/WON/LOST (win before lose; `day > deadline` loses)
- `Globals.end_day()` → day +1, emits `day_ended`, then `day_settled` once all earnings are in
- `Globals.reset()` → money/day back to starting values, emits `money_changed` (startup AND Play Again share it)
- `TimeManager.advance(delta)` → in REAL_TIME, rolls a day every `seconds_per_day`

## Live-tree seams (integration-tested, not pure)
- `Shop.buy_stand()` → spends `Level.buy_cost`, clones the TOP `"stand"` (tree order — test-pinned) into `Entities`, rows it right
- `Shop.upgrade_all()` → spends `Level.upgrade_cost`, calls `upgrade()` on every `"stand"`
- `Shop._on_day_ended()` → drains `upkeep_per_stand × stand_count` (see `ShopTest.gd`)

## Common student tweaks
Rename items · swap `assets/` art · Ctrl+D more stands · raise a stand's Tier ·
set goal/deadline AND buy/upgrade/upkeep prices on the `Level1` root · edit the
mission in the Message node and the end text on the GameOverScreen · flip
TimeManager to REAL_TIME for an idle feel · drag a stand to the top of Entities
to choose what Buy copies.

## Coordination point (not automatic)
The mission text in `UI/Message.messages` is plain words; keep it consistent
with the Level's `goal_money` / `deadline_day` by hand.

## Platform notes
Godot 4.5, GL Compatibility, web-editor/Chromebook target. Pure GDScript; no C#,
no GDExtension. Save ritual: Project > Tools > Download Project Source (IndexedDB
is volatile). `playlog.csv` lives in the browser sandbox — extracting it is a
native-editor / bigger-computer activity.
