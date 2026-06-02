# AudioManager.gd
#
# Autoload (set up in Project > Project Settings > Globals). One place to play
# sound from anywhere in the game:
#     AudioManager.play_sfx(my_sound)
#     AudioManager.play_music(my_song)
# Because it's an autoload there's only ever one of it, and every scene can reach
# it by name.
extends Node

# We keep ONE player for background music, so starting a new song automatically
# replaces the old one. It's created in code when the game starts.
var _music_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)

# Play a background track, replacing whatever was playing.
# To make a song loop, select the audio file in the FileSystem dock, open the
# Import tab, turn on "Loop", and click Reimport.
func play_music(stream: AudioStream) -> void:
	if stream == null:
		return
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

# Play a one-shot sound effect (a coin pickup, a jump, a button click).
# We make a small throwaway player for each sound and free it once it finishes,
# so several effects can overlap without cutting each other off.
func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.finished.connect(player.queue_free)   # clean up after it plays
	player.play()

# Set the overall game volume. 'percent' goes from 0.0 (silent) to 1.0 (full).
func set_master_volume(percent: float) -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(clampf(percent, 0.0, 1.0)))
