@tool
@icon(  "res://GUI/dialouge_system/icon/chat_bubbles.svg" )
class_name DialougeInteraction extends Area2D

signal player_interacted
signal finished

@export var enabled : bool = true


var dialouge_items : Array[ DialougeItem ]

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c is DialougeItem:
			dialouge_items.append( c )


func player_interact() -> void:
	player_interacted.emit()
	await  get_tree().process_frame
	await get_tree().process_frame
	DialougeSystem.show_dialouge( dialouge_items )
	DialougeSystem.finished.connect( _on_dialouge_finished )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	if enabled == false || dialouge_items.size() == 0:
		return
	animation_player.play("show")
	PlayerManager.interact_pressed.connect( player_interact )
	pass

 
func _on_area_exit( _a : Area2D ) -> void:
	animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_dialouge_finished() -> void:
	DialougeSystem.finished.disconnect( _on_dialouge_finished )
	finished.emit()


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialouge_items() == false:
		return[ "Require at least one DialougeItem node." ]
	else:
		return []


func _check_for_dialouge_items() -> bool:
	for c in get_children():
		if c is DialougeItem:
			return true
	return false
