# TimeManager.gd
#
# The shared game clock — the one place that decides when a new day begins.
# Pick a mode in the Inspector:
#   MANUAL    — days advance only when something calls Globals.end_day()
#               (in this template, the "End Day" button does). This is the start.
#   REAL_TIME — days tick by on their own, one every "seconds_per_day" seconds.
#
# Keeping BOTH modes here means future features (an idle "let a week pass", or a
# timed event like "an inspector visits on day 3") can share this one clock
# instead of each reinventing time. Both modes end a day the same way, by calling
# Globals.end_day(), so the rest of the game never has to care which mode is on.
extends Node

# This is the "@export var x: SomeEnum" bridge: the dropdown is the designer's
# door (pick MANUAL or REAL_TIME in the Inspector); adding a new mode would be a
# coder's door (a new enum value + a new branch below).
enum TimeMode { MANUAL, REAL_TIME }

@export var time_mode: TimeMode = TimeMode.MANUAL

# How many real-world seconds equal one in-game day (only used in REAL_TIME).
@export var seconds_per_day: float = 60.0

# The leading underscore is a convention meaning "internal — leave this alone."
# It's our running stopwatch, measured in seconds.
var _accumulated_seconds: float = 0.0

# _process() runs once per frame. We pass the work to advance() so the same logic
# can be unit-tested without waiting for real seconds to pass.
func _process(delta: float) -> void:
	advance(delta)

# "delta" is how many seconds passed since the previous frame. We add up delta
# instead of counting frames because frame rate varies between computers — adding
# delta keeps a day the same real length on a fast or slow machine.
func advance(delta: float) -> void:
	SignalBus.tick.emit(delta)
	if time_mode == TimeMode.REAL_TIME:
		_accumulated_seconds += delta
		if _accumulated_seconds >= seconds_per_day:
			_accumulated_seconds -= seconds_per_day   # keep the leftover; don't drift
			Globals.end_day()

# Future hook: advance several days at once (for an idle "let a week pass").
func advance_days(count: int) -> void:
	for i in count:
		Globals.end_day()
