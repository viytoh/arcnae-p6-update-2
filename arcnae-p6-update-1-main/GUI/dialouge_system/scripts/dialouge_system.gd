@tool
@icon("res://GUI/dialouge_system/icon/star_bubble.svg")
class_name DialougeSystemNode extends CanvasLayer

signal finished

var is_active : bool = false

var dialouge_items : Array[ DialougeItem ]
var dialouge_item_index : int = 0

@onready var dialouge_ui: Control = $DialougeUI
@onready var content: RichTextLabel = $DialougeUI/PanelContainer/RichTextLabel
@onready var name_label : Label = $DialougeUI/Name
@onready var portrait_sprite: Sprite2D = $DialougeUI/PortraitSprite
@onready var dialouge_progress_indicator: PanelContainer = $DialougeUI/DialougeProgressIndicator
@onready var dialouge_progress_indicator_label: Label = $DialougeUI/DialougeProgressIndicator/Label



func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child( self )
			return
		return
	hide_dialouge()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if(
			event.is_action_pressed("interact") or 
			event.is_action_pressed("attack") or 
			event.is_action_pressed("ui_accept")
	):
		dialouge_item_index += 1
		if dialouge_item_index < dialouge_items.size():
			start_dialouge()
		else:
			hide_dialouge()
	pass


func show_dialouge( _items : Array[ DialougeItem ] ) -> void:
	is_active = true
	dialouge_ui.visible = true
	dialouge_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialouge_items = _items
	dialouge_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialouge()
	pass


func hide_dialouge() -> void:
	is_active = false
	dialouge_ui.visible = false
	dialouge_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass


func start_dialouge() -> void:
	show_dialouge_button_indicator( true )
	var _d : DialougeItem = dialouge_items[ dialouge_item_index ]
	set_dialouge_data( _d )
	pass


func set_dialouge_data( _d : DialougeItem ) -> void:
	if _d is DialougeText:
		content.text = _d.text
	name_label.text = _d.npc_info.npc_name
	portrait_sprite.texture = _d.npc_info.portrait
	pass


func show_dialouge_button_indicator( is_visible : bool ) -> void:
	dialouge_progress_indicator.visible = is_visible
	if dialouge_item_index + 1 < dialouge_items.size():
		dialouge_progress_indicator_label.text = "NEXT"
	else:
		dialouge_progress_indicator_label.text = "END"
