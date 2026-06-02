# PlayLogger.gd
#
# Writes one row to a CSV file every time a day ends, so you can open the file in
# a spreadsheet and SEE how the game played out — money per day, day by day. That
# is how a designer "reads" their game to balance it. (A spreadsheet is a kind of
# game too.)
#
# The file is "user://playlog.csv". "user://" is a private per-player folder Godot
# manages. In the web editor it lives inside the browser, so pulling the file out
# to open in a spreadsheet is a "later, on a bigger computer" activity.
extends Node

const LOG_PATH := "user://playlog.csv"

func _ready() -> void:
	_start_new_log()
	SignalBus.day_ended.connect(_on_day_ended)

func _on_day_ended(day_number: int) -> void:
	# One row per day: the day number and the money at the end of that day.
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
