# TimeManager.gd
#
# Drives the game clock. It does two jobs every frame:
#   1. posts a "tick" so anything that wants per-frame updates can listen, and
#   2. counts up real seconds until a full "day" has passed, then advances it.
extends Node

# How many real-world seconds equal one in-game day. Tune it in the Inspector.
@export var seconds_per_day: float = 60.0

# The leading underscore is a convention meaning "internal — leave this alone."
# It's our running stopwatch, measured in seconds.
var _accumulated_seconds: float = 0.0

# _process() runs once per frame. "delta" is how many seconds passed since the
# previous frame (a small number like 0.016). We add up delta instead of
# counting frames because frame rate varies between computers — adding delta
# keeps the day the same real length on a fast or slow machine.
func _process(delta: float) -> void:
	SignalBus.tick.emit(delta)
	_accumulated_seconds += delta
	if _accumulated_seconds >= seconds_per_day:
		_accumulated_seconds = 0.0          # reset the stopwatch for the next day
		Globals.day += 1
		SignalBus.day_ended.emit(Globals.day)   # tell the HUD (and anyone else)
