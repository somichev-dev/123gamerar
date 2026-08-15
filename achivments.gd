extends Node

@export var achievements = {
	"start_game": false,
}

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
		return
	for id in achievements:
		achievements[id] = config.get_value("achievements", id)
		

signal unlocked(id: String)
func _process(delta: float) -> void:
	pass
