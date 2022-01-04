extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var booze_amt := 0
var juice_amt := 0
var other_stuff := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$BoozeBottle.connect("pressed", self, "_on_BoozeBottle_pressed")
	$JuiceBottle.connect("pressed", self, "_on_JuiceBottle_pressed")
	$OtherStuff.connect("pressed", self, "_on_OtherStuff_pressed")
	pass

func _on_BoozeBottle_pressed():
	booze_amt += 1

func _on_JuiceBottle_pressed():
	juice_amt += 1

func _on_OtherStuff_pressed():
	other_stuff += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "Current Booze Amount: " + str(booze_amt)
	$Label.text += "\n" + "Current Juice Amount: " + str(juice_amt)
	$Label.text += "\n" + "Amount of Other Stuff: " + str(other_stuff)
