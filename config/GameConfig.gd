# GameConfig.gd
#
# A "Resource" is a little container of values you can fill in and save as a
# file. This one holds the game's BALANCE KNOBS — the numbers a designer changes
# to make the game easier or harder.
#
# Why a Resource instead of plain variables in Globals? Variables on an autoload
# don't show up in the Inspector (there's no node to click on). A Resource file
# DOES: double-click "config/game_config.tres" in the FileSystem dock and these
# fields appear on the right, ready to edit — no code needed.
#
# "class_name GameConfig" registers the type so the editor lets you create one
# (right-click in FileSystem > New Resource… > GameConfig).
class_name GameConfig
extends Resource

@export var starting_money: int = 100   # money the player begins with
@export var start_day: int = 1          # the number of the first day
@export var goal_money: int = 500       # reach this much money to WIN
@export var deadline_day: int = 10      # you must hit the goal by the end of this day
@export var show_debug_buttons: bool = true   # show the cheat buttons while testing
