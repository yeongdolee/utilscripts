extends Camera3D

@export_group("Target Settings")
## The node the camera will follow (e.g., the Player)
@export var target: Node3D 
## Fixed distance and angle from the target (X, Y, Z)
@export var offset: Vector3 = Vector3(0, 15, 12) 

@export_group("Movement Settings")
## If enabled, the camera follows the target smoothly using interpolation.
@export var use_smoothing: bool = true
## Smoothness of the camera movement (Higher is faster, lower is smoother)
@export var follow_speed: float = 5.0
## Whether the camera should instantly snap to the target on start
@export var snap_on_ready: bool = true

func _ready():
	if target and snap_on_ready:
		_snap_to_target()

func _physics_process(delta):
	if not target:
		return
		
	# Calculate the target position based on the offset
	var desired_position = target.global_position + offset
	
	if use_smoothing:
		# Smoothly interpolate to the desired position
		global_position = global_position.lerp(desired_position, follow_speed * delta)
	else:
		# Instantly snap to the desired position every frame
		global_position = desired_position

func _snap_to_target():
	global_position = target.global_position + offset
	look_at(target.global_position)
