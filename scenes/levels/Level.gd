# Level.gd
#
# Goes on the ROOT of a level scene (Level1.tscn, and later Level2.tscn, ...).
# A "level" is one playable space: its map, its stands, its background — and its
# own GOAL. Each level owns its own targets, so different levels can be easier or
# harder.
#
# The GoalManager (over in Managers) doesn't store the goal itself; it asks the
# CURRENT level for it. This level joins the "current_level" group so the manager
# can find it. When you eventually have more than one level, each one does the
# same, and the win/lose check always uses whichever level is loaded right now.
extends Node2D

@export var goal_money: int = 500    # reach this much money to WIN this level
@export var deadline_day: int = 10   # hit the goal by the end of this day

func _ready() -> void:
	add_to_group("current_level")
