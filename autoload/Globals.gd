# Globals.gd
#
# This script is an AUTOLOAD (set up in Project > Project Settings > Globals).
# That means Godot creates ONE copy of it when the game starts and keeps it
# alive the whole time. Any script, in any scene, can read or change it just by
# typing "Globals." — so this is the right home for game-wide facts like how
# much money the player has and what day it is.
#
# IMPORTANT: keep Globals FIRST in the autoload list. The other autoloads and
# every scene read from it, so it needs to load before them.
extends Node

# The balance knobs (starting money, the goal, the deadline) live in a Resource
# FILE so a designer can edit them in the Inspector — see GameConfig.gd. We load
# that file once here. "@export" can't be used for this job, because @export
# values on an autoload don't appear in the Inspector (there's no node to click).
const CONFIG_PATH := "res://config/game_config.tres"
var config: GameConfig

# The LIVE values that change while you play.
var money := 0
var day := 1

# These MIRROR the global config values. They start at sensible defaults and get
# overwritten by the config file (if it exists) when the game starts. (Per-rule
# knobs like the goal live on their own nodes — the goal lives on the Level, not
# here.)
var starting_money := 100
var start_day := 1

# _ready() runs once, automatically, as soon as this node enters the game.
func _ready() -> void:
	# If the config file exists, copy its values into our mirrors. (Checking first
	# means a brand-new project that hasn't made the file yet still runs fine.)
	if ResourceLoader.exists(CONFIG_PATH):
		config = load(CONFIG_PATH)
		starting_money = config.starting_money
		start_day = config.start_day
	# Then start a fresh game. Startup and "Play Again" share this one function,
	# so what "a fresh game" means lives in exactly one place.
	reset()

# Put the LIVE values back to their starting values, and announce the money so
# the HUD updates. Runs at startup (see _ready above), and again when the player
# presses "Play Again" on the Game-Over screen — this script is an autoload, so
# it SURVIVES a scene reload and has to reset itself.
func reset() -> void:
	money = starting_money
	day = start_day
	# (We "emit" on the SignalBus — see SignalBus.gd for how that works.)
	SignalBus.money_changed.emit(money)

# Call this from anywhere to give (or take, with a negative number) money.
# Doing it through one function means there is a single, reliable place where
# money changes AND the rest of the game gets told about it.
func add_money(amount: int) -> void:
	money += amount
	SignalBus.money_changed.emit(money)

# Move the game forward by one day. The "End Day" button calls this; so does the
# clock when TimeManager is in REAL_TIME mode. One shared way to end a day.
func end_day() -> void:
	day += 1
	SignalBus.day_ended.emit(day)
	# emit() doesn't return until EVERY day_ended listener has run — rent paid,
	# every stand's income in. Only then do we announce the day is settled, so
	# whoever checks the total (GoalManager, PlayLogger) sees the real number.
	SignalBus.day_settled.emit(day)
