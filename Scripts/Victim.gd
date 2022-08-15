extends KinematicBody

enum state {
	standby,
	roam,
	escape,
	die,
	hit,
}

export var normal_speed := 3.0
export var run_speed := 6.0
export var angular_acceleration := 7.0

var _velocity := Vector3.ZERO
var _is_running := false
var _state
var _destination = null
var _hp = 3

onready var _model : Spatial = $Model

func _ready():
	_state = state.roam
	
func _physics_process(delta):
	if _state == state.die || _state == state.standby:
		return
		
	var move_direction := Vector3.ZERO
	
	_is_running = _state == state.escape
			
	match _state:
		state.roam, state.escape:
			if _destination == null:
				_destination = get_destination()
			
			move_direction = translation.direction_to(_destination)
		
	# if destination is reached
	if _destination != null and translation.distance_squared_to(_destination) <= 0.01:
		_destination = null
		
	var speed := run_speed if _is_running else normal_speed
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	
	if Vector2(_velocity.x, _velocity.z).length_squared() > 0.2:
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * angular_acceleration)
	
	move_and_slide(_velocity, Vector3.UP)

func hit():
	_hp -= 1
	if _hp == 0:
		_state = state.die
	else:
		_state = state.hit
		
func hit_animation_finished():
	if _hp > 0:
		_state = state.escape

func get_destination():
	var x = rand_range(-50.0, 50.0)
	var z = rand_range(-50.0, 50.0)
	return Vector3(x, 0, z)
