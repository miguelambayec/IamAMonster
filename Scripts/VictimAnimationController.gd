extends Node

export(NodePath) var character_path
onready var character = get_node(character_path)
onready var anim_player := $"../Model/AnimationPlayer"

func _ready():
	anim_player.connect("animation_finished", self, "_on_animation_finished")

func _physics_process(_delta):
	match character._state:
		character.state.standby:
			anim_player.play("Idle")
		character.state.die:
			anim_player.play("Die")
		character.state.roam:
			anim_player.play("Walk")
		character.state.escape:
			anim_player.play("Run")
		character.state.hit:
			anim_player.play("Hit")

func _on_animation_finished(anim_name):
	if anim_name == "Hit":
		character.hit_animation_finished()
