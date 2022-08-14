extends Node

export(NodePath) var player_path
onready var player := get_node(player_path)
onready var animation := get_parent().get_node("Model/AnimationPlayer")

func _physics_process(_delta):
	if player.is_attacking():
		animation.play("Attack")
	elif player.is_moving():
		if player.is_running():
			animation.play("Run")
		else:
			animation.play("Walk")
	else:
		animation.play("Idle")
