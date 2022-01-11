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
var customer_orders : Array

var current_score : int
var beginning_wait_time : int
var level : int
var money : int
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$BoozeBottle.connect("pressed", self, "_on_BoozeBottle_pressed")
	$JuiceBottle.connect("pressed", self, "_on_JuiceBottle_pressed")
	$OtherStuff.connect("pressed", self, "_on_OtherStuff_pressed")
	$TrashBin.connect("pressed", self, "_on_TrashBin_pressed")
	$SubmitDrink.connect("pressed", self, "_on_SubmitDrink_pressed")
	$Timer.connect("timeout", self, "_on_Timeout")
	
	current_drink = Drink.new()
	customer_orders = []
	randomize_customer_order()
	
	current_score = 0
	beginning_wait_time = 100
	level = 1
	
	$Timer.wait_time = beginning_wait_time
	$Timer.start()

func randomize_customer_order():
	customer_orders.clear()
	var i := 0
	while (i < level % 4 + 1):
		var drink = Drink.new()
	
		drink.booze_amt = randi() % 3 + 1
		drink.juice_amt = randi() % 3
		drink.other_stuff = randi() % 3
	
		customer_orders.append(drink)
		
		i += 1

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
	# lets just say each drink is five dollars to keep it simple
	money -= 5 

func calculate_score():
	current_score += int($Timer.time_left) * level * level

func change_level():
	level += 1
	# subtract operating costs from money
	if (level % 6 == 0):
		money -= 50
	if (money < 0):
		end_game()
	$Timer.wait_time = beginning_wait_time / level
	$Timer.start()

func end_game():
	get_tree().change_scene("res://ScoreScreen.tscn")
	GameState.score = current_score
	GameState.money = money
	GameState.level = level

func _on_SubmitDrink_pressed():
	for drink in customer_orders:
		if current_drink.equals(drink):
			dump_drink()
			customer_orders.erase(drink)
			calculate_score()
			# lets just say each drink is five dollars to keep it simple
			money += 5 
			
			if len(customer_orders) == 0:
				randomize_customer_order()
				change_level()
			
			$SuccessLabel.text = "Sucess!"
		else:
			$SuccessLabel.text = "Failed!"

func _on_Timeout():
	change_level()
	randomize_customer_order()
	$SuccessLabel.text = "Failed!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Score
	$ScoreLabel.text = "Time: " + str($Timer.time_left)
	$ScoreLabel.text += "\n" + "Current Score: " + str(current_score)
	$ScoreLabel.text += "\n" + "Level: " + str(level)
	$ScoreLabel.text += "\n" + "Money Left: " + str(money)
	# Current Order
	$OrderLabel.text = "Current Orders"
	for drink in customer_orders:
		$OrderLabel.text += "\n" + "___________________________________________"
		$OrderLabel.text += "\n" + "Customer Booze Amount: " + str(drink.booze_amt)
		$OrderLabel.text += "\n" + "Customer Juice Amount: " + str(drink.juice_amt)
		$OrderLabel.text += "\n" + "Customer Amount of Other Stuff: " + str(drink.other_stuff)
		$OrderLabel.text += "\n" + "___________________________________________"
	# Drink
	$DrinkLabel.text = "Current Drink"
	$DrinkLabel.text += "\n" + "--------------------------------"
	$DrinkLabel.text += "\n" + "Current Booze Amount: " + str(current_drink.booze_amt)
	$DrinkLabel.text += "\n" + "Current Juice Amount: " + str(current_drink.juice_amt)
	$DrinkLabel.text += "\n" + "Amount of Other Stuff: " + str(current_drink.other_stuff)
