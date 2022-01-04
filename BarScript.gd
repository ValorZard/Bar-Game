extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Drink:
	var booze_amt : int
	var juice_amt : int
	var other_stuff : int
	
	func _init():
		booze_amt = 0
		juice_amt = 0
		other_stuff = 0
	
	func equals(other_drink : Drink) -> bool:
		return (self.booze_amt == other_drink.booze_amt 
		and self.juice_amt == other_drink.juice_amt 
		and self.other_stuff == other_drink.other_stuff)

var current_drink : Drink
var customer_order : Drink


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$BoozeBottle.connect("pressed", self, "_on_BoozeBottle_pressed")
	$JuiceBottle.connect("pressed", self, "_on_JuiceBottle_pressed")
	$OtherStuff.connect("pressed", self, "_on_OtherStuff_pressed")
	$TrashBin.connect("pressed", self, "_on_TrashBin_pressed")
	$SubmitDrink.connect("pressed", self, "_on_SubmitDrink_pressed")
	
	current_drink = Drink.new()
	randomize_customer_order()
	pass

func randomize_customer_order():
	var drink = Drink.new()
	
	drink.booze_amt = randi() % 3 + 1
	drink.juice_amt = randi() % 3
	drink.other_stuff = randi() % 3
	
	customer_order = drink

func _on_BoozeBottle_pressed():
	current_drink.booze_amt += 1

func _on_JuiceBottle_pressed():
	current_drink.juice_amt += 1

func _on_OtherStuff_pressed():
	current_drink.other_stuff += 1

func dump_drink():
	current_drink = Drink.new()

func _on_TrashBin_pressed():
	dump_drink()

func _on_SubmitDrink_pressed():
	if current_drink.equals(customer_order):
		dump_drink()
		randomize_customer_order()
		$SuccessLabel.text = "Sucess!"
	else:
		$SuccessLabel.text = "Failed!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$OrderLabel.text = "Customer Booze Amount: " + str(customer_order.booze_amt)
	$OrderLabel.text += "\n" + "Customer Juice Amount: " + str(customer_order.juice_amt)
	$OrderLabel.text += "\n" + "Customer Amount of Other Stuff: " + str(customer_order.other_stuff)
	$OrderLabel.text += "\n" + "Current Booze Amount: " + str(current_drink.booze_amt)
	$OrderLabel.text += "\n" + "Current Juice Amount: " + str(current_drink.juice_amt)
	$OrderLabel.text += "\n" + "Amount of Other Stuff: " + str(current_drink.other_stuff)
