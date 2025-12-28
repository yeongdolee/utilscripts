extends CharacterBody3D

@export_group("Movement Settings")
@export var speed: float = 8.0
@export var acceleration: float = 15.0
@export var rotation_speed: float = 12.0

@export_group("Visual Effects")
@export var click_effect_scene: PackedScene 
@export var effect_duration: float = 1.0 

@export_group("Raycast Settings")
## The collision mask for the floor (Set your floor to Layer 2)
@export_flags_3d_physics var floor_mask: int = 2

var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false

@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _ready():
	target_position = global_position

func _process(_delta):
	# Update target position continuously while holding right-click
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_update_target_position()

func _input(event):
	# Handle one-time visual effect on initial click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			_handle_click_visuals()

func _physics_process(delta):
	var direction = target_position - global_position
	direction.y = 0 
	
	if direction.length() > 0.2:
		is_moving = true
		var dir_normalized = direction.normalized()
		velocity = velocity.lerp(dir_normalized * speed, acceleration * delta)
		
		var target_basis = Basis.looking_at(dir_normalized)
		basis = basis.slerp(target_basis, rotation_speed * delta)
		
		move_and_slide()
	else:
		is_moving = false
		velocity = velocity.lerp(Vector3.ZERO, acceleration * delta)

func _update_target_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	# --- SOLUTION: Filter raycast to only hit the floor ---
	query.collision_mask = floor_mask 
	# Exclude the player's own body to be extra safe
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
