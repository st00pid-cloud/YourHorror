extends Node
#game architecture is so ass
# Dictionary to store all your levels and their corresponding cutscenes
var levels = {
	"level_1": {
		"scene": "res://levels/server_room.tscn",
		"intro_cutscene": preload("res://levels/Level0.tscn")
	}
}
var current_level_id = "level_1"

func load_level(level_id: String):
	if levels.has(level_id):
		current_level_id = level_id
		var data = levels[level_id]
		
		# 1. Load the Cutscene Player Scene
		var cutscene_player_scene = load("res://scenes/CutscenePlayer.tscn")
		var player_instance = cutscene_player_scene.instantiate()
		
		# 2. Inject the specific Resource for this level
		player_instance.cutscene_resource = data["intro_cutscene"]
		
		# 3. Change to the cutscene scene
		get_tree().root.add_child(player_instance)
		# Optional: Remove the old level/menu
		get_tree().current_scene.queue_free() 
		get_tree().current_scene = player_instance
