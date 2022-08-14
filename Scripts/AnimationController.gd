extends Node

export(NodePath) var player_path
onready var player := get_node(player_path)
onready var animation := get_parent().get_node("Model/AnimationPlayer")

var _is_jump_pressed := false

func _ready():
	animation.connect("animation_finished", self, "_on_animation_finished")

func _process(_delta):
	if !_is_jump_pressed:
		_is_jump_pressed = Input.is_action_just_pressed("jump")
		
	if player.is_on_floor():
		_is_jump_pressed = false
		
	var is_jumping = !player.is_on_floor() and _is_jump_pressed
	
	if is_jumping:
		animation.play("Jump")
	elif player.is_moving():
		if player.is_sprinting():
			animation.play("Run")
		else:
			animation.play("Walk")
	else:
		animation.play("idle")

func _on_animation_finished(anim_name):
	if anim_name == "Jump":
		_is_jump_pressed = false
