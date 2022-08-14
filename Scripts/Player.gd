extends KinematicBody

export var normal_speed := 3.0
export var run_speed := 6.0
export var jump_strength := 20.0
export var gravity := 50.0
export var angular_acceleration := 7.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm : SpringArm = $SpringArm
onready var _model : Spatial = $Model

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	var speed := normal_speed
	
	if is_sprinting():
		speed = run_speed
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
		
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if Vector2(_velocity.x, _velocity.z).length_squared() > 0.2:
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * angular_acceleration)
		
func is_moving():
	return _velocity.x != 0 || _velocity.z != 0
	
func is_sprinting():
	return Input.is_action_pressed("sprint")
