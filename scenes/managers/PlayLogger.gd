# PlayLogger.gd
#
# Records how the game played out — money per day, day by day. That is how a
# designer "reads" their game to balance it. Each settled day goes two places:
#   1. the OUTPUT PANEL (print) — read it right after you play, anywhere;
#   2. a CSV file you can open in a spreadsheet. (A spreadsheet is a kind of
#      game too.)
#
# The file is "user://playlog.csv". "user://" is a private per-player folder Godot
# manages. In the web editor it lives inside the browser, so pulling the file out
# to open in a spreadsheet is a "later, on a bigger computer" activity — the
# Output panel is the everywhere version.
extends Node

const LOG_PATH := "user://playlog.csv"

func _ready() -> void:
	_start_new_log()
	# day_settled (not day_ended) so the row shows the day's FINAL money — after
	# every stand, even one bought mid-game, has earned. See SignalBus.gd.
	SignalBus.day_settled.connect(_on_day_settled)

func _on_day_settled(day_number: int) -> void:
	# One row per day: the day number and the money at the end of that day.
	print("playlog — day ", day_number, ": $", Globals.money)
	_append_row(str(day_number) + "," + str(Globals.money))

# Start a fresh file each run, with a header row naming the columns.
func _start_new_log() -> void:
	var file := FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if file:
		file.store_line("day,money")

# Add one line to the END of the file. We open in READ_WRITE and jump to the end
# instead of WRITE, because WRITE would erase everything written so far.
func _append_row(row: String) -> void:
	var file := FileAccess.open(LOG_PATH, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_line(row)
