# GameConfig.gd
#
# A "Resource" is a little container of values you can fill in and save as a
# file. This one holds the few GLOBAL "new game" values that don't belong to any
# single node — the money you start with and the first day's number.
#
# MOST balance knobs do NOT live here. They live on the node that owns them: a
# stand's income is on the Stand, the goal is on the GoalManager, the day length
# is on the TimeManager. You tune those right on the node, in the Inspector, in
# context. This file is only for values that have no node to live on, because
# they belong to an autoload (Globals).
#
# To edit these: double-click "config/game_config.tres" in the FileSystem dock.
class_name GameConfig
extends Resource

@export var starting_money: int = 100   # money the player begins with
@export var start_day: int = 1          # the number of the first day
