extends CharacterBody3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var vertical_dir := 0.0
	if Input.is_action_pressed("ui_accept"):
		vertical_dir = 1.0
	elif Input.is_action_pressed("ui_cancel"):
		vertical_dir = -1.0

	var direction := (transform.basis * Vector3(input_dir.x, vertical_dir, input_dir.y)).normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
