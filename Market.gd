extends Node

var stock := {
	"wood": 0,
	"iron": 0,
	"tool": 0
}

var base_prices := {
	"wood": 1,
	"iron": 3,
	"tool": 5
}

func get_price(item: String) -> int:
	var quantity = stock.get(item, 0)
	return max(1, base_prices[item] - int(quantity / 10)) # crude supply/demand

func add_stock(item: String, amount: int) -> void:
	stock[item] += amount

func remove_stock(item: String, amount: int) -> bool:
	if stock.get(item, 0) >= amount:
		stock[item] -= amount
		return true
	return false
