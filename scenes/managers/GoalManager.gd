# GoalManager.gd
#
# Decides whether the player has WON or LOST, and announces it once. It checks at
# the end of each day (after the stands have earned their money):
#   - reached the goal money?            -> WIN
#   - run past the deadline day, short?  -> LOSE
# It posts the result on the SignalBus ("game_over"), and the MessageCanvas shows
# the matching text. The goal and deadline come from the GameConfig file, so a
# designer tunes them in the Inspector (no code).
extends Node

enum Result { PLAYING, WON, LOST }

# Tune these right here on the GoalManager node in the Inspector. They live on the
# node that owns the rule (not in a global file) so you can read the goal in the
# context where it's used — see GameConfig.gd for when to use the global file.
@export var goal_money: int = 500       # reach this much money to WIN
@export var deadline_day: int = 10      # hit the goal by the end of this day

# Once the game is decided we stop checking, so the win/lose message fires once.
var _resolved := false

func _ready() -> void:
	SignalBus.day_ended.connect(_on_day_ended)

func _on_day_ended(_day_number: int) -> void:
	if _resolved:
		return
	var result := evaluate(Globals.money, Globals.day, goal_money, deadline_day)
	if result == Result.WON:
		_resolved = true
		SignalBus.game_over.emit(true)
	elif result == Result.LOST:
		_resolved = true
		SignalBus.game_over.emit(false)

# The pure rule, with no outside connections, so it's easy to read and to test.
# Order matters: we check WIN before LOSE, so reaching the goal exactly on the
# deadline day counts as a win.
func evaluate(money: int, day: int, goal: int, deadline: int) -> Result:
	if money >= goal:
		return Result.WON
	if day > deadline:
		return Result.LOST
	return Result.PLAYING
