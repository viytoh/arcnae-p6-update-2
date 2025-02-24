extends Area2D

@export var battle_scene: PackedScene
var is_triggered: bool = false

func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name and not is_triggered:
		is_triggered = true
		self.monitoring = false
		self.monitorable = false
		$CollisionShape2D.disabled = true
		
		$"../BattleTransition/AnimationPlayer".play("trans_in")
		await get_tree().create_timer(1.5).timeout
		
		if battle_scene:
			var battleTemp = battle_scene.instantiate()
			add_child(battleTemp)
		
		$"../BattleTransition/AnimationPlayer".play("trans_out")
