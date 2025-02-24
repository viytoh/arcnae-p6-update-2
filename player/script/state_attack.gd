class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1.20,0.5) var decelerate_speed : float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackFXSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var hurt_box: HurtBox = %AttackHurtBox



## What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play( "attack_" + player.AnimDirection() )
	animation_player.animation_finished.connect( EndAttack )
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	if attacking:
		hurt_box.monitoring = true
	pass


## What happens when player exists this state
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	pass


## What happens during the _process update in this state
func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


## What happens during the _physics_process in this state
func Physics( _delta : float ) -> State:
	return null


## WHat happens with the input events in this state
func HandleInput( _event: InputEvent ) -> State:
	return null



func EndAttack( _newAnimName : String ) -> void:
	attacking = false
