# MessageCanvas.gd
#
# Shows on-screen text from a list, one message at a time. Use it for the
# "Your Mission" instructions and a little scene-setting at the start. The
# player clicks the Dismiss button to move to the next message; when the list
# runs out, the panel hides itself. (The END of the game — win or lose — is the
# GameOverScreen's job, not this one's.)
#
# On purpose, this can ONLY show strings from a list — it has no choices or
# branching paths. (Branching stories are the Visual Novel template's job.)
# To change what it says, edit the "Messages" list in the Inspector. No code.
extends Control

@export var messages: Array[String] = [
	"Goal: reach $500 by day 10.",
	"Click End Day to advance.",
]

# Which message we're showing right now (a position in the list above).
var _index := 0

@onready var label: Label = %MessageLabel

func _ready() -> void:
	# Wire the Dismiss button in code, so there's nothing to connect in the editor.
	%DismissButton.pressed.connect(_advance)
	_show_current()

func _advance() -> void:
	_index += 1
	_show_current()

func _show_current() -> void:
	# Show the current message, or hide the whole panel once we've run out.
	visible = _index < messages.size()
	if visible:
		label.text = messages[_index]
