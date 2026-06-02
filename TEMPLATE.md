# TEMPLATE.md — Tycoon Template manifest

Token-efficient context for an AI helper, a teacher, or a student quick-ref.
For the friendly walkthrough see `README.md`; for coding tasks see `CHALLENGES.md`.

## What it is
An idle/tycoon: **stands** earn money at the **end of each day**; the player
clicks **End Day**; reaching **goal money** by the **deadline day** wins, else
loses. Ships playable, ugly, and unbalanced on purpose.

## Core loop (who tells whom)
`End Day button → Globals.end_day() → SignalBus.day_ended →`
`  each Stand earns income_for_day() → Globals.add_money() → SignalBus.money_changed → HUD`
`  GoalManager.evaluate() → (win/lose) → SignalBus.game_over → MessageCanvas`
`  PlayLogger appends a row to user://playlog.csv`

## The duplicatable block
`scenes/entities/Stand.tscn` — copy with Ctrl+D, retune in the Inspector. Each
instance self-wires to `day_ended` in `_ready()`. No signal hookup needed.

## Tuning knobs (where each lives — see DECISIONS D-019)
| Knob | Node / file | Type | Does |
|---|---|---|---|
| item_name | Stand | String | label of what it sells |
| tier | Stand | enum LEVEL_1/2/3 | picks income multiplier (×1/×3/×8) AND picture |
| base_income | Stand | int | money/day at LEVEL_1 |
| level_1/2/3_texture | Stand | Texture2D | picture per level |
| goal_money | Managers/GoalManager | int | money needed to win |
| deadline_day | Managers/GoalManager | int | win by end of this day |
| time_mode | Managers/TimeManager | enum MANUAL/REAL_TIME | button vs auto clock |
| seconds_per_day | Managers/TimeManager | float | day length in REAL_TIME |
| messages / win_message / lose_message | UI/Message | String[] / String | on-screen text |
| show_debug_buttons | HUD root | bool | show the +money cheat button |
| starting_money / start_day | config/game_config.tres | int | new-game globals (Globals-owned) |

## Role seams
Artist (`assets/` + the HUD/Message look) · Balance/Tuning (the knobs above +
`playlog.csv`) · Level/Content (add/arrange stands) · Writer-light (Message text).

## File map
`autoload/` Globals · SignalBus · SaveManager · AudioManager
`config/` GameConfig.gd + game_config.tres
`assets/` stand_level_1/2/3.svg (placeholders)
`scenes/` Main · entities/Stand · managers/{TimeManager,GoalManager,PlayLogger} · ui/{HUD,MessageCanvas}

## Pure logic seams (for tests / autograder / AI checks)
- `Stand.income_for_day()` → `base_income * _tier_multiplier()`
- `GoalManager.evaluate(money, day, goal, deadline)` → PLAYING/WON/LOST (win before lose; `day > deadline` loses)
- `Globals.end_day()` → day +1, emits `day_ended`
- `TimeManager.advance(delta)` → in REAL_TIME, rolls a day every `seconds_per_day`

## Common student tweaks
Rename items · swap `assets/` art · Ctrl+D more stands · raise a stand's Tier ·
set goal/deadline on GoalManager · edit the mission in the Message node · flip
TimeManager to REAL_TIME for an idle feel.

## Coordination point (not automatic)
The mission text in `UI/Message.messages` is plain words; keep it consistent with
`GoalManager.goal_money` / `deadline_day` by hand.

## Platform notes
Godot 4.5, GL Compatibility, web-editor/Chromebook target. Pure GDScript; no C#,
no GDExtension. Save ritual: Project > Tools > Download Project Source (IndexedDB
is volatile). `playlog.csv` lives in the browser sandbox — extracting it is a
native-editor / bigger-computer activity.
