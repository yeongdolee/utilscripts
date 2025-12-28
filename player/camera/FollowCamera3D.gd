extends Camera3D

@export_group("Target Settings")
## The node the camera will follow (e.g., the Player)
@export var target: Node3D 
## Fixed distance and angle from the target (X, Y, Z)
@export var offset: Vector3 = Vector3(0, 15, 12) 

@export_group("Movement Settings")
## Smoothness of the camera movement (Higher is faster, lower is smoother)
@export var follow_speed: float = 5.0
## Whether the camera should instantly snap to the target on start
@export var snap_on_ready: bool = true

func _ready():
	if target and snap_on_ready:
		# Set initial position immediately to avoid long travel on start
		global_position = target.global_position + offset
		# Ensure the camera looks at the target
		look_at(target.global_position)

func _physics_process(delta):
	if not target:
		return
		
	# Calculate the target position based on the offset
	var desired_position = target.global_position + offset
	
	# Smoothly interpolate the camera position
	# Using lerp prevents jittering and provides a polished feel
	global_position = global_position.lerp(desired_position, follow_speed * delta)
	
	# Optional: Maintain the initial look_at rotation if the camera needs to stay locked
	# Most LoL-style cameras use a fixed rotation set in the editor.
