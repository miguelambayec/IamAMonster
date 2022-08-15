extends KinematicBody

enum state {
	standby,
	follow,
	hunt,
	kill
}

export var normal_speed := 3.0
export var run_speed := 6.0
export var angular_acceleration := 7.0
export(NodePath) var target_path

var _velocity := Vector3.ZERO
var _is_running := false
var _state

onready var _target := get_node(target_path)
onready var _model : Spatial = $Model

func _ready():
	_state = state.follow

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	var target_position = _target.translation
	
	match _state:
		state.follow:
			target_position += _target.get_node("Model").transform.basis.x * 1.2
			if translation.distance_squared_to(target_position) >= 0.01:
				move_direction = translation.direction_to(target_position)
	
	var speed := run_speed if _is_running else normal_speed
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	
	if Vector2(_velocity.x, _velocity.z).length_squared() > 0.2:
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * angular_acceleration)
	
	move_and_slide(_velocity, Vector3.UP)

func is_moving():
	return _velocity.x != 0 || _velocity.z != 0
	
func is_running():
	return false
	
func is_attacking():
	return false
