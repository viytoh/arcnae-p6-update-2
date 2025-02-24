class_name Player extends CharacterBody2D

signal DirectionChanged( new_direction: Vector2 )
signal player_damaged( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine



# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ) :
	
	direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("right", "left"),
		Input.get_axis("up", "down")
	).normalized()
	pass


func _physics_process( _delta ):
	move_and_slide()


func set_direction() -> bool: 
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() 
	/ TAU * DIR_4.size() ) )
	print(direction_id)
	var new_direction = DIR_4[ direction_id ]
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	DirectionChanged.emit( new_direction )
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true



func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp(99)
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
