extends Node


# Global Variables
## Reference to the player node. Register this in the player's _ready() via US.Player = self.
var Player: Node2D = null
## Reference to the main camera node. Register this in the camera's _ready() via US.MainCamera = self.
var MainCamera: Camera2D = null

# from Unity(Global Event Bus system)
## A class with the capability to transmit and receive global signals.
class _GlobalEvent:
	var _subscribers: Dictionary = {}
	
	## Connects a function to a specific global signal name.
	func ConnectSignal(event_name: String, callable: Callable):
		if not callable.is_valid(): return
		if not _subscribers.has(event_name): _subscribers[event_name] = []
		if callable not in _subscribers[event_name]: _subscribers[event_name].append(callable)
	
	## Emits a global signal with an array of arguments to all subscribers.
	func EmitSignal(event_name: String, var_args: Variant):
		if not _subscribers.has(event_name): return
		var list = _subscribers[event_name]
		for callable in list:
			if callable.is_valid(): callable.callv(var_args)
			else: list.erase(callable)

# from Unity(Random class)
## A class that supports functionality for random values
class _Random:
	## Returns a random integer between min (inclusive) and max (exclusive).
	func RangeI(min_val: Variant, max_val: Variant) -> int:
		var mn = int(min_val)
		var mx = int(max_val)
		if mn >= mx: return mn
		return randi_range(mn, mx - 1)
	
	## Returns a random float between min and max.
	func RangeF(min_val: Variant, max_val: Variant) -> float:
		return randf_range(float(min_val), float(max_val))
	
	## Returns a random float between 0.0 and 1.0.
	func Value() -> float:
		return randf()

# Class instantiation logic
var GlobalEvent: _GlobalEvent = _GlobalEvent.new()
var Random: _Random = _Random.new()

# from Unity(Invoke function)
## Calls a function after a specified delay in seconds.
func Invoke(callable: Callable, delay: Variant):
	var f_delay = float(delay)
	if f_delay <= 0:
		callable.call()
		return
	get_tree().create_timer(f_delay).timeout.connect(callable, CONNECT_ONE_SHOT)

## Instantiates a scene and sets its position, rotation, and parent.
## Order: Scene, Position, Rotation, Parent.
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

## Safely destroys a node (queue_free). Optional delay in seconds.
func Destroy(node: Variant, delay: float = 0.0):
	if not is_instance_valid(node) or not node is Node:
		return
	
	if delay <= 0:
		node.queue_free()
	else:
		get_tree().create_timer(delay).timeout.connect(node.queue_free)

## Reloads the current active scene.
func RestartScene():
	get_tree().reload_current_scene()

## Sets the global time scale (e.g., 0.5 for slow motion, 1.0 for normal).
func LoadScene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)

## Rotates a 2D node toward the target position smoothly using interpolation.
## @node: The Node2D to rotate.
## @target_pos: The destination coordinates to look at.
## @weight: Rotation speed (0.0 to 1.0). Lower is slower/smoother.
func LookAtSmooth(node: Node2D, target_pos: Vector2, weight: float):
	var target_angle = node.get_angle_to(target_pos) + node.rotation
	node.rotation = lerp_angle(node.rotation, target_angle, weight)

## Calls a specific method on all nodes within a given group.
## @group_name: The name of the group to target.
## @method_name: The function name to execute on each node.
## @args: (Optional) Array of arguments to pass to the method.
func CallGroup(group_name: String, method_name: String, args: Array = []):
	get_tree().call_group(group_name, method_name, args)

func _ready():
	randomize()
