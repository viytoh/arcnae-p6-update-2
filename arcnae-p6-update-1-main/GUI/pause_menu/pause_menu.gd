extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var button_menu: Button = $Control/VBoxContainer/Button_Menu
@onready var item_description: Label = $Control/ItemDescription
@onready var item_name: Label = $Control/ItemName
@onready var item_icon: TextureRect = $Control/ItemIcon


var is_paused : bool = false


func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	button_menu.pressed.connect( _on_menu_pressed )
	pass


func _unhandled_input( event : InputEvent ) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass


func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass


func _on_menu_pressed() -> void:
	if is_paused == false:
		return
	
	hide_pause_menu()
	
	var main_menu_path = "res://GUI/main_menu/main_menu.tscn"  # Replace with your actual main menu path
	if ResourceLoader.exists(main_menu_path):
		LevelManager.load_new_level(main_menu_path, "", Vector2.ZERO)
	pass


func update_item_description( new_text : String ) -> void:
	item_description.text = new_text


func update_item_name( new_text : String ) -> void:
	item_name.text = new_text


func update_item_texture( new_texture : Texture2D ) -> void:
	item_icon.texture = new_texture
	pass

func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
