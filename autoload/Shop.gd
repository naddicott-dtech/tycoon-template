# Shop.gd
#
# This script is an AUTOLOAD (set up in Project > Project Settings > Globals),
# so there is ONE Shop alive the whole game, reachable by typing "Shop." anywhere.
#
# The Shop is the ONE place the player spends money. It holds no prices of its
# own — it reads them off whichever level is loaded right now (the level in the
# "current_level" group) and spends through Globals.add_money(). The HUD's "Buy
# Stand" and "Upgrade All" buttons call these functions by name, the same way the
# "End Day" button calls Globals.end_day() — so the money trail is easy to follow.
extends Node

# The prefab a "Buy" creates, and how far apart auto-placed stands sit. The row
# just marches to the right — tidier layouts (a grid, wrapping rows) are a challenge.
const STAND_SCENE := preload("res://scenes/entities/Stand.tscn")
const STAND_SPACING := 128.0   # pixels between bought stands

func _ready() -> void:
	# When a day ends, charge upkeep. (We're an autoload, so this runs before the
	# Stands earn — the day's rent is taken out, then income comes in.)
	SignalBus.day_ended.connect(_on_day_ended)

# Buy one more stand, if the player can afford this level's buy_cost.
func buy_stand() -> void:
	var level := _current_level()
	if level == null:
		return
	if Globals.money < level.buy_cost:
		return   # not enough money — do nothing
	Globals.add_money(-level.buy_cost)   # spend (a negative amount takes money away)
	var stand := STAND_SCENE.instantiate()
	stand.position = _next_stand_position()
	# Drop it next to the other stands. Levels keep their stands under "Entities";
	# if that node isn't there, fall back to the level root so a buy still works.
	var parent: Node = level
	var entities := level.get_node_or_null("Entities")
	if entities != null:
		parent = entities
	parent.add_child(stand)

# Where the next bought stand goes: one step to the right of the stand you placed
# last, so they grow in a tidy row out from your existing stands — NOT on top of the
# money display at the top-left. Smarter layouts (a grid, wrapping rows) are a challenge.
func _next_stand_position() -> Vector2:
	var stands := get_tree().get_nodes_in_group("stand")
	if stands.is_empty():
		return Vector2.ZERO
	var last_stand: Node2D = stands[stands.size() - 1]
	return last_stand.position + Vector2(STAND_SPACING, 0)

# Upgrade EVERY stand by one level for a single flat price (this level's upgrade_cost).
func upgrade_all() -> void:
	var level := _current_level()
	if level == null:
		return
	if Globals.money < level.upgrade_cost:
		return   # not enough money — do nothing
	Globals.add_money(-level.upgrade_cost)
	for stand in get_tree().get_nodes_in_group("stand"):
		stand.upgrade()

# Charge daily upkeep: this level's per-stand rate times how many stands you own.
func _on_day_ended(_day_number: int) -> void:
	var level := _current_level()
	if level == null:
		return
	var count := get_tree().get_nodes_in_group("stand").size()
	var bill := _upkeep_total(level.upkeep_per_stand, count)
	if bill > 0:
		Globals.add_money(-bill)

# Pulled out as its own tiny function with no outside connections, so the upkeep
# math is easy to read AND easy to test.
func _upkeep_total(rate: int, count: int) -> int:
	return rate * count

func _current_level() -> Node:
	return get_tree().get_first_node_in_group("current_level")
