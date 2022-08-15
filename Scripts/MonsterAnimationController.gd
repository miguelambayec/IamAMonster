extends Node

export(NodePath) var player_path
onready var player := get_node(player_path)
onready var anim_tree := $"../AnimationTree"
onready var anim_player := $"../Model/AnimationPlayer"

var loop_animations = ["Idle", "Walk", "Run"]
var idle_walk_blend = 0.0
var walk_run_blend = 0.0

func _ready():
	setup_animations()

func _physics_process(_delta):
	
	if player.is_attacking():
		anim_tree["parameters/AttackOneShot/active"] = true
	elif player.is_moving():
		idle_walk_blend = lerp(idle_walk_blend, 1.0, 0.25)
		
		if player.is_running():
			walk_run_blend = 1.0
		else:
			walk_run_blend = 0.0
	else:
		idle_walk_blend = lerp(idle_walk_blend, 0.0, 0.25)
		
	anim_tree["parameters/IdleWalkBlend/blend_amount"] = idle_walk_blend
	anim_tree["parameters/WalkRunBlend/blend_amount"] = walk_run_blend

func setup_animations():
	for anim_name in loop_animations:
		var anim = anim_player.get_animation(anim_name)
		anim.loop = true
