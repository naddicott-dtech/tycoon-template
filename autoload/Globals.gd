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

# These MIRROR the balance knobs. They start at sensible defaults and get
# overwritten by the config file (if it exists) when the game starts. Reading
# e.g. Globals.goal_money is always safe, even before the file is made.
var starting_money := 100
var start_day := 1
var goal_money := 500
var deadline_day := 10
var show_debug_buttons := true

# _ready() runs once, automatically, as soon as this node enters the game.
func _ready() -> void:
	# If the config file exists, copy its knobs into our mirrors. (Checking first
	# means a brand-new project that hasn't made the file yet still runs fine.)
	if ResourceLoader.exists(CONFIG_PATH):
		config = load(CONFIG_PATH)
		starting_money = config.starting_money
		start_day = config.start_day
		goal_money = config.goal_money
		deadline_day = config.deadline_day
		show_debug_buttons = config.show_debug_buttons
	# Copy the starting values into the live values.
	money = starting_money
	day = start_day
	# Announce the starting money so the HUD can show it right away.
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
