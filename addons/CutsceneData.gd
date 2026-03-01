extends Resource
class_name CutsceneData

@export_multiline var dialogue_lines: Array[String] = []
@export var scary_keywords: Dictionary = {
	"pull": "heavy_shake",
	"anything": "light_glitch"
}
@export var next_scene_path: String = "res://levels/game_itself.tscn"
