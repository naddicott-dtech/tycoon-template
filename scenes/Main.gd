# Main.gd
#
# This is attached to the root of Main.tscn — the scene the game starts on.
# Right now it does almost nothing on purpose: each template adds its own
# starting logic here. The print below is just a sanity check.
extends Node

func _ready():
	# Prints to the Output panel at the bottom of the editor when you press Play.
	# If you see real numbers here, it means Globals loaded and the wiring works.
	print("Day: ", Globals.day, " Money: ", Globals.money)
