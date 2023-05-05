extends Node2D

@export var curve:Curve
@export var SPREAD:float
@export var NUM_CARDS:int
@export var ycurve:Curve
@export var rotcurve:Curve

# Set the time interval in seconds between object instantiations
const X = 2
var numInstantiated=0
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = 1000
	self.position.y=500
	# Create a Timer node and connect its timeout signal to the instantiateObject function
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(X)
	timer.set_one_shot(false)
	timer.timeout.connect(instantiateObject)
	# Start the timer
	timer.start()
	
	#var cardPrefab = load("res://Assets/Card.tscn") # Replace with function body.
	#for int in NUM_CARDS:
	#	var cardInstance = cardPrefab.instantiate()
	#	cardInstance.position = Vector2(0,0)
	#	$HBoxContainer.add_child(cardInstance)



func alignCards():
	var leftPosition = $HBoxContainer.position - Vector2(min(NUM_CARDS * 70, 400),0)
	var rightPosition = $HBoxContainer.position + Vector2(min(NUM_CARDS * 70, 400),0)

	if(NUM_CARDS>1):
		for card in $HBoxContainer.get_children():
			var hand_ratio:float = .5
			if get_child_count()>1:
				hand_ratio = float(card.get_index())/ float($HBoxContainer.get_child_count()-1)
				card.position = leftPosition.lerp(rightPosition,hand_ratio)
				card.position.y =  ycurve.sample(hand_ratio) * -SPREAD
				card.rotation = -rotcurve.sample(hand_ratio)  *.3


func instantiateObject():
	# Replace "ObjectScene" with the name of your object's scene
	var cardPrefab = load("res://Assets/Card.tscn")
	var cardInstance = cardPrefab.instantiate()
	cardInstance.position = Vector2(0,0)
	$HBoxContainer.add_child(cardInstance)
	alignCards()
	numInstantiated += 1
	if numInstantiated >= NUM_CARDS:
		timer.stop()


