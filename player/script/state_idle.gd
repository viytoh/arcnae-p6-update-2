class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"


## What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass


## What happens when player exists this state
func Exit() -> void:
	pass


## What happens during the _process update in this state
func Process( _delta : float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null


## What happens during the _physics_process in this state
func Physics( _delata : float ) -> State:
	return null


## WHat happens with the input events in this state
func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
