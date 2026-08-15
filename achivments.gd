extends Node

@export var achievements = {
	"start_game": false,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_achievements()

func unlock(id: String) -> void:
	if not achievements.has(id):
		return
	if achievements[id]:
		return
	achievements[id] = true
	emit_signal("unlocked", id)
	save_achievements()

func save_achievements() -> void:
	var config = ConfigFile.new()
	for id in achievements:
		config.set_value("achievements", id, achievements[id])
	config.save("user://achievements.cfg")

func load_achievements() -> void:
	var config = ConfigFile.new()
	if config.load("user://achievements.cfg") != OK:
		print("aaaaaa")
		return
	print("config")
	for id in achievements:
		achievements[id] = config.get_value("achievements", id)
		

signal unlocked(id: String)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
