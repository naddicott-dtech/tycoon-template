# Globals.gd
#
# This script is an AUTOLOAD (set up in Project > Project Settings > Globals).
# That means Godot creates ONE copy of it when the game starts and keeps it
# alive the whole time. Any script, in any scene, can read or change it just by
# typing "Globals." — so this is the right home for game-wide facts like how
# much money the player has and what day it is.
extends Node

# @export makes a variable show up in the Inspector panel on the right side of
# the editor. You can change these by clicking, no code needed. These are the
# STARTING values / settings — the knobs a designer is meant to tune.
@export var starting_money := 100
@export var start_day := 1
@export var show_debug_buttons: bool = true   # turn the cheat buttons on/off

# These are the LIVE values that change while you play. We keep them separate
# from the "starting_" values above so that restarting always has a clean number
# to go back to.
var money := 0
var day := 1

# _ready() runs once, automatically, as soon as this node enters the game.
func _ready():
	# Copy the designer's starting values into the live values.
	money = starting_money
	day = start_day
	# Announce the starting money so the HUD can show it right away.
	# (We "emit" on the SignalBus — see SignalBus.gd for how that works.)
	SignalBus.money_changed.emit(money)

# Call this from anywhere to give (or take, with a negative number) money.
# Doing it through one function means there is a single, reliable place where
# money changes AND the rest of the game gets told about it.
func add_money(new_money: int) -> void:
	money += new_money
	SignalBus.money_changed.emit(money)
