# HUD.gd
#
# The HUD ("heads-up display") is the on-screen text and buttons: the money
# counter, the day counter, and a debug button. This is a great example to
# study, because it shows the whole listen-and-react pattern in one short file.
extends Control

@export var debug_add_amount: int = 10   # how much the cheat button adds
@export var show_debug_buttons: bool = true   # show the cheat button while testing

# @onready means "grab this once the scene is loaded, before _ready() runs."
# The % is a shortcut for "find the node named MoneyLabel that I marked as a
# Scene Unique Name." Right-click a node in the scene tree and choose
# "% Access as Unique Name" to enable it. The win: you can move the node around
# in the tree and this still finds it, because it searches by name, not by path.
@onready var money_label: Label = %MoneyLabel
@onready var day_label: Label = %DayLabel

func _ready():
	# SUBSCRIBE to the bulletin board: "when money changes, run _on_money_changed."
	SignalBus.money_changed.connect(_on_money_changed)
	SignalBus.day_ended.connect(_on_day_ended)
	# Run the handlers once right now so the labels show the correct starting
	# values, instead of being blank until the first change happens.
	_on_money_changed(Globals.money)
	_on_day_ended(Globals.day)
	# Hide the cheat button unless debug mode is on (set on this HUD in the Inspector).
	%AddMoneyButton.visible = show_debug_buttons
	# The "End Day" button moves the game forward by one day. We connect it here
	# in code so it's wired the instant the scene loads — you never have to open
	# the Node panel and connect a signal yourself.
	%EndDayButton.pressed.connect(Globals.end_day)

# A "handler" is just a function that runs in response to a signal. By Godot
# convention these are named _on_<thing>. This one updates the money label.
func _on_money_changed(new_money:int) -> void:
	money_label.text = "$" + str(new_money)   # str() turns the number into text

func _on_day_ended(new_day:int) -> void:
	day_label.text = "Day " + str(new_day)

# Connected to the AddMoneyButton's "pressed" signal (wired in the scene, see
# the Node panel on the button). Notice it goes through Globals.add_money so the
# bulletin board fires and the label above updates automatically.
func _on_add_money_button_pressed():
	Globals.add_money(debug_add_amount)
