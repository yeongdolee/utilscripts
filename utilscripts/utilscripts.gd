extends Node

# A class with the capability to transmit and receive global signals
# from Unity(Global Event Bus system)
class _GlobalEvent:
	var _subscribers: Dictionary = {}
	
	# Transmitting the end-of-transmission signal
	func ConnectSignal(event_name: String, callable: Callable):
		if not callable.is_valid(): return
		if not _subscribers.has(event_name): _subscribers[event_name] = []
		if callable not in _subscribers[event_name]: _subscribers[event_name].append(callable)
	
	# Received the end-of-transmission signal
	func EmitSignal(event_name: String, var_args: Variant):
		if not _subscribers.has(event_name): return
		var list = _subscribers[event_name]
		for callable in list:
			if callable.is_valid(): callable.callv(var_args)
			else: list.erase(callable)

# A class that supports functionality for random values
# from Unity(Random class)
class _Random:
	# Generate random values of type int within a specified range
	func RangeI(min_val: Variant, max_val: Variant) -> int:
		var mn = int(min_val)
		var mx = int(max_val)
		if mn >= mx: return mn
		return randi_range(mn, mx - 1)
	
	# Generate random values of type float within a specified range
	func RangeF(min_val: Variant, max_val: Variant) -> float:
		return randf_range(float(min_val), float(max_val))
	
	# Generate a value of type float between 0 and 1
	func Value() -> float:
		return randf()

# Class instantiation logic
var GlobalEvent: _GlobalEvent = _GlobalEvent.new()
var Random: _Random = _Random.new()

# Wait for a specified period of time and execute the function
# from Unity(Invoke function)
func Invoke(callable: Callable, delay: Variant):
	var f_delay = float(delay)
	if f_delay <= 0:
		callable.call()
		return
	get_tree().create_timer(f_delay).timeout.connect(callable, CONNECT_ONE_SHOT)

# Adding another scene by instantiating it within a specific scene 
func Instantiate(scene: PackedScene, position: Variant = null, rotation: Variant = null, parent: Node = null) -> Node:
	var instance = scene.instantiate()
	
	var target_parent = parent if parent != null else get_tree().current_scene
	target_parent.add_child(instance)
	
	if position != null:
		if instance is Node2D or instance is Control or instance is Node3D:
			instance.global_position = position
			
	
	if rotation != null:
		if instance is Node2D:
			instance.global_rotation = rotation
		elif instance is Node3D:
			if rotation is Vector3:
				instance.global_rotation_degrees = rotation
			else:
				instance.global_rotation = rotation
				
	return instance

# Remove node from the current scene
func Destroy(node: Variant, delay: float = 0.0):
	if not is_instance_valid(node) or not node is Node:
		return
	
	if delay <= 0:
		node.queue_free()
	else:
		get_tree().create_timer(delay).timeout.connect(node.queue_free)

# Restart scene
func RestartScene():
	get_tree().reload_current_scene()

# Load other scene
func LoadScene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)

func _ready():
	randomize()
