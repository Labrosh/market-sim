extends Control

# -- UI Node Exports --
@export var day_label: Label
@export var wood_label: Label
@export var gold_label: Label
@export var time_label: Label
@export var price_label: Label
@export var location_label: Label
@export var game_log: RichTextLabel
@export var Chop_Button: Button
@export var Sell_Button: Button
@export var Sleep_Button: Button
@export var go_to_town_button: Button
@export var go_to_forest_button: Button

# -- Core Stats --
var day := 1
var wood := 0
var gold := 0
var axe_uses := 50
var location := "forest" # or "town"

# -- Time System --
var time_of_day := 480 # 8:00 AM in minutes
const END_OF_DAY := 1320 # 10:00 PM in minutes

# -- Action Costs --
const CHOP_MINUTES := 60
const SELL_MINUTES := 60
const TRAVEL_MINUTES := 60

# -- Limits --
const MAX_WOOD := 20

func _ready():
	randomize()
	update_labels()
	log_message("The day begins. You're in the forest with nothing but an axe and determination.")

# -- Chop Wood Action --
func _on_chop_button_pressed():
	if axe_uses <= 0:
		log_message("Your axe is broken! You can't chop anything.")
		return
	if location != "forest":
		log_message("You look around — no trees here. Go to the forest first.")
		return
	if wood >= MAX_WOOD:
		log_message("You're already carrying too much wood.")
		return
	if time_of_day + CHOP_MINUTES >= END_OF_DAY:
		log_message("It's too late to start chopping now.")
		return

	var wood_gained := randi() % 3 + 1
	wood = min(wood + wood_gained, MAX_WOOD)
	axe_uses -= 1
	time_of_day += CHOP_MINUTES

	log_message("You swing your axe and collect %d wood. (%d chops left)" % [wood_gained, axe_uses])
	update_labels()

# -- Sell Wood Action --
func _on_sell_button_pressed():
	if wood <= 0:
		log_message("You check your pack... there's nothing to sell.")
		return
	if location != "town":
		log_message("You need to be in town to sell your wood.")
		return
	if time_of_day + SELL_MINUTES >= END_OF_DAY:
		log_message("The market is closing. Come back earlier tomorrow.")
		return

	var sale_price := Market.get_price("wood")
	var sold := wood
	gold += sold * sale_price
	Market.add_stock("wood", sold)
	wood = 0
	time_of_day += SELL_MINUTES

	log_message("You sold %d wood for %d gold (at %d gold each)." % [sold, sold * sale_price, sale_price])
	update_labels()

# -- Sleep Action --
func _on_sleep_button_pressed():
	log_message("You lie down and close your eyes...")
	end_day()

# -- Travel Actions --
func _on_go_to_town_button_pressed():
	if location == "town":
		log_message("You're already in town.")
		return
	if time_of_day + TRAVEL_MINUTES >= END_OF_DAY:
		log_message("It's too late to travel to town.")
		return

	location = "town"
	time_of_day += TRAVEL_MINUTES
	log_message("You walk the dusty path to town.")
	update_labels()

func _on_go_to_forest_button_pressed():
	if location == "forest":
		log_message("You're already in the forest.")
		return
	if time_of_day + TRAVEL_MINUTES >= END_OF_DAY:
		log_message("It's too late to return to the forest.")
		return

	location = "forest"
	time_of_day += TRAVEL_MINUTES
	log_message("You head back into the thick trees of the forest.")
	update_labels()

# -- End of Day --
func end_day():
	day += 1
	time_of_day = 480 # Reset to 8:00 AM
	axe_uses = 50
	log_message("A new day dawns. Your axe feels a little sharper.")
	update_labels()

# -- Log Helper --
func log_message(message: String):
	print(message)
	game_log.append_text("[color=white]%s[/color]\n" % message)
	game_log.scroll_to_line(game_log.get_line_count())

# -- Time Formatting --
func get_time_string() -> String:
	var hours := time_of_day / 60
	var minutes := time_of_day % 60
	return "%02d:%02d" % [hours, minutes]

# -- UI Refresh --
func update_labels():
	day_label.text = "Day: %d" % day
	wood_label.text = "Wood: %d / %d" % [wood, MAX_WOOD]
	gold_label.text = "Gold: %d" % gold
	time_label.text = "Time: %s" % get_time_string()
	price_label.text = "Wood Price: %d gold/ea" % Market.get_price("wood")
	location_label.text = "Location: %s" % location.capitalize()

	price_label.visible = (location == "town")
	go_to_town_button.visible = (location != "town")
	go_to_forest_button.visible = (location != "forest")

	if time_of_day >= END_OF_DAY:
		end_day()
