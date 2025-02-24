class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle: State = $"../Idle"


func init() -> void:
	player.player_damaged.connect( _player_damaged )


## What happens when player enters this state
func Enter() -> void:
	player.animation_player.animation_finished.connect( animation_finished )
	
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player.set_direction()
	
	player.UpdateAnimation("stun")
	player.make_invulnerable( invulnerable_duration )
	player.effect_animation_player.play("damaged")
	pass


## What happens when player exists this state
func Exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect( animation_finished )
	pass


## What happens during the _process update in this state
func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state


## What happens during the _physics_process in this state
func Physics( _delata : float ) -> State:
	return null


## WHat happens with the input events in this state
func HandleInput( _event: InputEvent ) -> State:
	return null


func _player_damaged( _hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState( self )
	pass

func animation_finished( _a : String ) -> void:
	next_state = idle
