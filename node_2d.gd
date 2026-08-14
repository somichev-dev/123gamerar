extends Node2D


# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	for i in 10:
		var my_random_number = rng.randi_range(1, 100)
		if my_random_number % 3 == 0:
			print(my_random_number)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation_degrees += 360*delta
	pass


func _on_area_2d_mouse_entered() -> void:
	print("TEXT")
	pass # Replace with function body.
