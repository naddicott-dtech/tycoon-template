# GoalManager.gd
#
# Decides whether the player has WON or LOST, and announces it once. It checks at
# the end of each day (after the stands have earned their money):
#   - reached the goal money?            -> WIN
#   - run past the deadline day, short?  -> LOSE
# It posts the result on the SignalBus ("game_over"), and the MessageCanvas shows
# the matching text. The goal and deadline belong to the LEVEL (each level sets
# its own — see Level.gd), so this manager asks the current level for them. That
# means it holds no numbers of its own and keeps working no matter which level is
# loaded.
extends Node

enum Result { PLAYING, WON, LOST }

# Once the game is decided we stop checking, so the win/lose message fires once.
var _resolved := false

func _ready() -> void:
	SignalBus.day_ended.connect(_on_day_ended)

func _on_day_ended(_day_number: int) -> void:
	if _resolved:
		return
	# Ask the current level for its goal. (The level put itself in the
	# "current_level" group in its _ready — see Level.gd.)
	var level := get_tree().get_first_node_in_group("current_level")
	if level == null:
		return
	var result := evaluate(Globals.money, Globals.day, level.goal_money, level.deadline_day)
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
