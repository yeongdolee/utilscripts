extends Camera3D

@export_group("Target Settings")
@export var target: Node3D 

@export_group("Movement Settings")
@export var use_smoothing: bool = true
@export var follow_speed: float = 5.0

var _auto_offset: Vector3 = Vector3.ZERO

func _ready():
	if target:
		_auto_offset = global_position - target.global_position
		
		_snap_to_target()

func _physics_process(delta):
	if not target:
		return
		
	var desired_position = target.global_position + _auto_offset
	
	if use_smoothing:
		global_position = global_position.lerp(desired_position, follow_speed * delta)
	else:
		global_position = desired_position

func _snap_to_target():
	global_position = target.global_position + _auto_offset
