# Stand.gd
#
# A Stand sells one item and earns money at the END OF EACH DAY. This is the
# DUPLICATABLE BLOCK of the game: to add more to your shop, click a Stand in the
# scene and press Ctrl+D to copy it, then change its values in the Inspector.
# Each copy wires itself up on its own — you never have to connect anything.
extends Sprite2D

# This "@export var tier: Tier" dropdown is a BRIDGE between two kinds of people:
#  - a designer PICKS a level in the Inspector (no code), and
#  - a coder could ADD a level (one new enum value + one new line in the match).
# Higher levels earn more money per day.
enum Tier { LEVEL_1, LEVEL_2, LEVEL_3 }

@export var item_name: String = "Consumable Item A"   # what this stand sells (rename it!)
@export var tier: Tier = Tier.LEVEL_1
@export var base_income: int = 5      # money earned per day at LEVEL_1

func _ready() -> void:
	# Subscribe to the bulletin board: when a day ends, earn money. Because each
	# Stand signs itself up here, a duplicated Stand just works — no wiring.
	SignalBus.day_ended.connect(_on_day_ended)

func _on_day_ended(_day_number: int) -> void:
	Globals.add_money(income_for_day())

# How much this stand earns in one day. It's kept as its own little function with
# no outside connections, which makes it easy to read AND easy to test.
func income_for_day() -> int:
	return base_income * _tier_multiplier()

func _tier_multiplier() -> int:
	match tier:
		Tier.LEVEL_1: return 1
		Tier.LEVEL_2: return 3
		Tier.LEVEL_3: return 8
		_: return 1   # safety net if a new Tier is added without a line above
