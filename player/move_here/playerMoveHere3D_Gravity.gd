extends CharacterBody3D

@export_group("Movement Settings")
@export var speed: float = 8.0
@export var use_smoothing: bool = true
@export var acceleration: float = 15.0
@export var rotation_speed: float = 12.0

@export_group("Gravity Settings")
## Enable or disable gravity for this character
@export var apply_gravity: bool = true
## Multiplier for the project's default gravity
@export var gravity_multiplier: float = 2.0

@export_group("Visual Effects")
@export var click_effect_scene: PackedScene 
@export var effect_duration: float = 1.0 

@export_group("Raycast Settings")
@export_flags_3d_physics var floor_mask: int = 2

var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _ready():
	target_position = global_position

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_update_target_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			_handle_click_visuals()

func _physics_process(delta):
	# 1. Handle Gravity
	if not is_on_floor() and apply_gravity:
		velocity.y -= gravity * gravity_multiplier * delta
	
	# 2. Handle Movement
	var direction = target_position - global_position
	direction.y = 0 # Keep movement horizontal
	
	if direction.length() > 0.2:
		is_moving = true
		var dir_normalized = direction.normalized()
		var target_velocity = dir_normalized * speed
		
		if use_smoothing:
			# Only apply lerp to X and Z to keep gravity(Y) consistent
			var horizontal_vel = Vector2(velocity.x, velocity.z).lerp(
				Vector2(target_velocity.x, target_velocity.z), acceleration * delta
			)
			velocity.x = horizontal_vel.x
			velocity.z = horizontal_vel.y
		else:
			velocity.x = target_velocity.x
			velocity.z = target_velocity.z
		
		# Smooth Rotation
		var target_basis = Basis.looking_at(dir_normalized)
		basis = basis.slerp(target_basis, rotation_speed * delta)
	else:
		is_moving = false
		if use_smoothing:
			var horizontal_vel = Vector2(velocity.x, velocity.z).lerp(Vector2.ZERO, acceleration * delta)
			velocity.x = horizontal_vel.x
			velocity.z = horizontal_vel.y
		else:
			velocity.x = 0
			velocity.z = 0

	# 3. Final Movement Call
	move_and_slide()

func _update_target_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = floor_mask 
	query.exclude = [get_rid()] 
	
	var result = space_state.intersect_ray(query)
	if result:
		target_position = result.position

func _handle_click_visuals():
	_update_target_position()
	if click_effect_scene:
		_spawn_click_effect(target_position)

func _spawn_click_effect(pos: Vector3):
	var effect = click_effect_scene.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = pos
	
	get_tree().create_timer(effect_duration).timeout.connect(
		func(): if is_instance_valid(effect): effect.queue_free()
	)
