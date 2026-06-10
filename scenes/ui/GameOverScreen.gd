# GameOverScreen.gd
#
# The end-of-game overlay. It stays hidden while you play. When the GoalManager
# announces game_over, it covers the screen, shows the result, and PAUSES the
# whole game — so a finished game can't keep running behind it (no more buying
# stands after you've already lost). "Play Again" starts a fresh game.
#
# HOW THE LOCKOUT WORKS (one engine idea): get_tree().paused = true freezes
# every node — paused nodes stop processing and stop hearing input, so the End
# Day / Buy / Upgrade buttons all go dead for free, with no extra code.
#
# THE ONE TRAP: a paused node's buttons go dead too — including OURS. This
# screen only keeps working because its root node has, in the Inspector,
# Process > Mode set to "Always" (= "keep running even while paused"). If you
# copy this pattern for your own overlay and its buttons do nothing, that
# missing setting is why.
extends Control

# What the player reads at the end. Change these in the Inspector — no code.
@export var win_message: String = "You win!"
@export var lose_message: String = "Game over."

@onready var label: Label = %ResultLabel

func _ready() -> void:
	# Hidden until the game actually ends. Wired in code, nothing to connect.
	visible = false
	SignalBus.game_over.connect(_on_game_over)
	%PlayAgainButton.pressed.connect(_on_play_again)

func _on_game_over(did_win: bool) -> void:
	label.text = win_message if did_win else lose_message
	visible = true
	get_tree().paused = true

func _on_play_again() -> void:
	# Un-freeze, reset the money/day (Globals is an autoload — it survives the
	# reload, so it has to be told), and rebuild the scene from scratch.
	get_tree().paused = false
	Globals.reset()
	get_tree().reload_current_scene()
