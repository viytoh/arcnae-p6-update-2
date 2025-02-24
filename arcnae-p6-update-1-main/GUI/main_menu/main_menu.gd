extends CanvasLayer

@onready var button_new: Button = $VBoxContainer/Button_New
@onready var button_load: Button = $VBoxContainer/Button_Load
@onready var button_exit: Button = $VBoxContainer/Button_Exit

const NEW_GAME_SCENE: String = "res://Levels/Area1/01.tscn"

var save_manager := SaveManager

func ready() -> void:
	button_new.pressed.connect(_on_button_new_pressed)
	button_load.pressed.connect(_on_button_load_pressed)
	button_exit.pressed.connect(_on_button_exit_pressed)
	pass


func _on_button_new_pressed() -> void:
	var level_path = "res://Levels/Area1/01.tscn" # Set your starting level here
	var initial_transition = ""  # No specific transition for the new game
	var initial_position_offset = Vector2.ZERO # Default starting position
	
	LevelManager.load_new_level(level_path, initial_transition, initial_position_offset)
	pass # Replace with function body.


func _on_button_load_pressed() -> void:
	if FileAccess.file_exists(SaveManager.SAVE_PATH + "save.sav"):
		print("Loading saved game...")
		SaveManager.load_game()
	else:
		print("No save file found!")


func _on_button_exit_pressed() -> void:
	print("Exiting game...")
	get_tree().quit()
